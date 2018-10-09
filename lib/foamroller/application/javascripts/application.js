let containerId = function(feature) {
  return feature + 's_container';
}

let inputId = function(feature) {
  return feature + '_input';
}

let listElement = function(feature, value) {
  let liElement          = document.createElement('li');
  let divRow             = document.createElement('row');
  let input              = document.createElement('input');
  let divValueContainer  = document.createElement('div');
  let divButtonContainer = document.createElement('div');
  let clearBtn           = document.createElement('button');
  let x                  = '\u00D7';

  // Assign classes to enclosing containers
  divRow.className = 'row alignItems-center';
  divValueContainer.className = 'col-auto';

  input.type  = 'hidden';
  input.name  = feature + 's[]';
  input.value = value;

  divButtonContainer.className = 'paddingRight-1';

  clearBtn.className = 'button link clear_feature';
  clearBtn.innerText = x;
  clearBtn.addEventListener('click', clearFeatureClickHandler);

  divRow.appendChild(divValueContainer);
  divRow.appendChild(divButtonContainer);

  if (feature == 'user') {
    divValueContainer.innerText = value + " - " + users[value];
  } else {
    divValueContainer.innerText = value;
  }

  divButtonContainer.appendChild(clearBtn);

  liElement.appendChild(input);
  liElement.appendChild(divRow);

  return liElement;
}

let addBtnClickHandler = function(event) {
  event.preventDefault();

  let feature       = event.currentTarget.getAttribute('feature');
  let valueInput    = document.getElementById(inputId(feature));
  let containerArea = document.getElementById(containerId(feature));
  let liEl          = listElement(feature, valueInput.value);

  valueInput.value = null;
  containerArea.appendChild(liEl);
}

let clearFeatureClickHandler = function(event) {
  event.preventDefault();
  let feature = event.currentTarget.closest('li');
  let featuresContainer = feature.parentElement;
  featuresContainer.removeChild(feature);
}

let rangeInputOninputHandler = function(event) {
  let percentValue = document.getElementById('percent_value');
  percentValue.innerText = event.currentTarget.value;
}

let inputEnterHandler = function(event) {
  if (event.keyCode == 13) {
    event.preventDefault();
    let buttons = document.getElementsByClassName('add_btn');
    let currentFeature = event.currentTarget.getAttribute('feature');

    for (let i=0; i < buttons.length; i++) {
      var buttonFeature = buttons[i].getAttribute('feature');

      if (currentFeature == buttonFeature) {
        buttons[i].click();
        break;
      }
    }
  }
}

document.addEventListener('DOMContentLoaded', function() {
  let addBtn = document.querySelectorAll('.add_btn');
  let clearBtn = document.querySelectorAll('.clear_feature');
  let rangeInput = document.getElementById('percentage_input');
  let featureInputs = document.querySelectorAll('.feature_input');

  addBtn.forEach(function(element) {
    element.addEventListener('click', addBtnClickHandler);
  });

  clearBtn.forEach(function(element) {
    element.addEventListener('click', clearFeatureClickHandler);
  });

  featureInputs.forEach(function(element) {
    element.addEventListener('keydown', inputEnterHandler);
  });

  if (typeof rangeInput != 'undefined' && rangeInput != null ) {
    rangeInput.addEventListener('input', rangeInputOninputHandler);
  }
});

