require File.expand_path('../../spec_helper', __FILE__)

describe Foamroller::Server, type: :controller do
  def app
    Foamroller::Server
  end

  let(:features) { %w(super_cool_feature no_adoption low_barrier) }

  before do
    app.redis.set 'feature:__features__', features.join(',')
    app.redis.set 'feature:super_cool_feature', '11||popsicles,ice_cream_sandwiches'
    app.redis.set 'feature:no_adoption', '0||'
    app.redis.set 'feature:low_barrier', '85|1,2,3,4,5|hurdle'
    app.redis.set 'foamroller:groups', %w(foo bar baz)
  end

  context 'index' do
    it 'responds with a 200' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'prints the features' do
      get '/'
      features.each do |f|
        expect(last_response.body).to match /#{f}/
      end
    end

    it 'tells you to "Pick one"' do
      get '/'
      expect(last_response.body).to match /Pick one/
    end
  end

  context 'show' do
    context 'feature super_cool_feature' do
      it 'has the correct groups' do
        get '/super_cool_feature'
        expect(last_response).to match /popsicles/
        expect(last_response).to match /ice_cream_sandwiches/
      end
    end

    context 'feature low_barrier' do
      it 'has the correct user ids' do
        get '/low_barrier'

        (1..5).each do |i|
          expect(last_response).to match /#{i}/
        end
      end
    end

    context 'feature no_adoption' do
      it 'has the correct random percent of users' do
        get '/no_adoption'
        expect(last_response).to match /0/
      end
    end
  end
end
