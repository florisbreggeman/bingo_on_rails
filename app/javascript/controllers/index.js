// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

const BACKGROUND_IMAGE = 'url("/bug.png")';

// To my great disappointment, localStorage only supports strings...

function toggleBingoField(field, _event) {
  if(localStorage.getItem(field.id) === "true"){
    localStorage.setItem(field.id, "false");
    field.style.backgroundImage = "";
  } else { 
    localStorage.setItem(field.id, "true");
    field.style.backgroundImage = BACKGROUND_IMAGE;
  }
}

function processBingoField(field) {
  if(localStorage.getItem(field.id) === null){
    localStorage.setItem(field.id, "false");
  }else if(localStorage.getItem(field.id) === "true"){
    field.style.backgroundImage = BACKGROUND_IMAGE;
  }
  field.addEventListener("click", e => toggleBingoField(field, e));
}


function apiCall(path, method, body, onSuccess, onError=console.warn) {
  function transferComplete() {
    try {
      if (this.getResponseHeader('content-type').includes("application/json")) {
       var res = JSON.parse(this.responseText);
      } else {
       var res = this.responseText;
      }
      if (this.status > 399) {
        onError(res, this.status);
      } else {
        onSuccess(res);
      }
    } catch (e) {
      console.warn(e);
      onError(e, 600);
    }
  }

  function transferFailed(e) {
    console.warn("Transfer Failed: ", e);
    onError(e, 600);
  }

  var xhr = new XMLHttpRequest();
  xhr.addEventListener("load", transferComplete);
  xhr.addEventListener("error", transferFailed);

  xhr.open(method, path);

  if (body == null) {
    xhr.send();
  } else {
    xhr.setRequestHeader('content-type', 'application/json');
    xhr.send(JSON.stringify(body))
  }
}

function buildFieldEditList(container) {
  function onSuccess(fields){
    fields.forEach( item => {
      let element = document.createElement('li');
      element.classList.add('pure-form');
      element.classList.add('pure-form-aligned');
      
      let input = document.createElement('input');
      input.classList.add('pure-input');
      input.classList.add('pure-input-1');
      input.type = "text";
      input.value = item.contents

      element.appendChild(input)
      container.appendChild(element)
    })
  }

  let card_id = container.getAttribute("card_id")
  apiCall("/card/" + card_id + "/fields", "GET", null, onSuccess, (res, status) => console.warn(status, res));
}

window.addEventListener("turbo:load", _e => {
  let fields = document.getElementsByClassName("field");
  Array.from(fields).forEach(f => processBingoField(f));

  let fields_container = document.getElementById("fields-container");
  if(fields_container !== null){
    buildFieldEditList(fields_container)
  }
});

