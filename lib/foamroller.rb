require 'sinatra/base'
require 'redis'
require 'rollout'

module Foamroller
  class Server < Sinatra::Base
    def self.redis_url
      @redis_url ||= 'redis://localhost:6379'
    end

    def self.redis_url=(r_url)
      @redis_url = r_url
    end

    configure do |c|
      enable :logging
    end

    set(:redis,
      Proc.new do
        if ENV['RACK_ENV'] == 'test' then
          return @redis unless @redis.nil?
          require 'mock_redis';
          @redis = MockRedis.new
        else
          @redis ||= Redis.new url: self.redis_url
        end
      end
     )
    set(:rollout, Proc.new { @rollout ||= Rollout.new(redis) })
    set(:groups, Proc.new { @groups ||= redis.smembers('foamroller:groups').sort })
    set(:users,
        Proc.new do
          return @users unless @users.nil?
          @users = redis.hgetall('foamroller:users').to_h
        end
       )
    set :static, true
    set :public_dir, File.expand_path('../foamroller/application', __FILE__)

    set :views, File.expand_path('../foamroller/application/views', __FILE__)

    helpers do
      def url_path(*path_parts)
        [path_prefix, path_parts].join('/').squeeze('/')
      end

      def path_prefix
        request.env['SCRIPT_NAME']
      end
    end

    get '/' do
      features = settings.rollout.features.sort

      if features.size > 0
        @features = settings.rollout.multi_get *features
      else
        @features = []
      end

      erb :index
    end

    get '/:feature_flag' do
      features = settings.rollout.features.sort
      @features = settings.rollout.multi_get *features

      if @features.detect{ |f| f.name.to_s == params[:feature_flag] }.nil?
        not_found do
          "Feature flag #{params[:feature_flag]} does not exist"
        end
      end

      @feature = settings.rollout.get params[:feature_flag]

      erb :show
    end

    get '/:feature_flag/edit' do
      features = settings.rollout.features.sort
      @features = settings.rollout.multi_get *features

      if @features.detect{ |f| f.name.to_s == params[:feature_flag] }.nil?
        not_found do
          "Feature flag #{params[:feature_flag]} does not exist"
        end
      end

      @feature = settings.rollout.get params[:feature_flag]

      erb :edit
    end

    post '/update_feature_flag' do
      logger.info params
      feature = Rollout::Feature.new params[:name]
      feature.percentage = params[:percentage]
      feature.users      = params[:users]
      feature.groups     = params[:groups]

      data = {}
      data[:friendly_name] = params[:friendly_name] if params[:friendly_name]
      data[:description] = params[:description] if params[:description]

      if data.keys.size > 0
        feature.data = data
      end

      settings.redis.set "feature:#{feature.name}", feature.serialize

      redirect to "/#{params[:name]}"
    end
  end
end
