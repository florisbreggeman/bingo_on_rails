// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// TODO figure out how to load javascript from separate files

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
  if(method !== "GET" && typeof(body) === "object"){
    let token_name = document.getElementsByName("csrf-param")[0].content
    let token = document.getElementsByName("csrf-token")[0].content
    body[token_name] = token
  }

  function transferComplete() {
    try {
      if (this.getResponseHeader('content-type') !== null && this.getResponseHeader('content-type').includes("application/json")) {
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

function removeAllChildNodes(parent){
  while(parent.firstChild) {
    parent.removeChild(parent.firstChild);
  }
}

function onEnter(field, fun){
  field.addEventListener("keydown", function(e){
    if(e.code === "Enter"){
      fun(e);
    }
  })
}

function editField(element, container, field_id){
  let card_id = container.getAttribute("card_id");
  let contents = element.value
  apiCall("/card/" + card_id + "/fields/" + field_id, "PATCH", {"contents": contents}, (_res) => buildFieldEditList(container), (res, status) => console.warn(status, res));
  //TODO give the user any feedback this just happened
}

function deleteField(container, field_id){
  let card_id = container.getAttribute("card_id");
  apiCall("/card/" + card_id + "/fields/" + field_id, "DELETE", {}, (_res) => buildFieldEditList(container), (res, status) => console.warn(status, res));
}

function buildFieldEditList(container) {
  let card_id = container.getAttribute("card_id")

  function onSuccess(fields){
    removeAllChildNodes(container)
    fields.forEach( item => {
      let element = document.createElement("li");
      element.classList.add("pure-form");
      
      let input_div = document.createElement("div");
      input_div.classList.add("pure-u-3-4");
      let input = document.createElement("input");
      input.classList.add("pure-input-1");
      input.type = "text";
      input.value = item.contents;
      input_div.appendChild(input);


      let edit_button_div = document.createElement("div");
      edit_button_div.classList.add("pure-u-1-8");
      let edit_button = document.createElement("button");
      edit_button.classList.add("pure-button");
      edit_button.classList.add("pure-input-1");
      edit_button.appendChild(document.createTextNode("Edit"));
      edit_button.addEventListener("click", (_e) => editField(input, container, item.id));
      onEnter(input, (_e) => editField(input, container, item.id));
      edit_button_div.appendChild(edit_button);

      let delete_button_div = document.createElement("div");
      delete_button_div.classList.add("pure-u-1-8");
      let delete_button = document.createElement("button");
      delete_button.classList.add("button-delete");
      delete_button.classList.add("pure-button");
      delete_button.classList.add("pure-input-1");
      delete_button.appendChild(document.createTextNode("Delete"));
      delete_button.addEventListener("click", (_e) => deleteField(container, item.id));
      delete_button_div.appendChild(delete_button);

      element.appendChild(input_div);
      element.appendChild(edit_button_div);
      element.appendChild(delete_button_div);
      container.appendChild(element);
    });

    let how_many = document.getElementById("how-many");
    removeAllChildNodes(how_many);
    if(fields.length < 24){
      // fun fact: if you don't put the parenthesis here, text will start with "NaN fields"... js operator precedence continues to be a mystery
      let text = "Add " + (24 - fields.length) + " fields to make this card playable";
      how_many.appendChild(document.createTextNode(text));
      document.getElementById("play-button").style.display = "none";
    }else{
      let text = "24 out of " + fields.length + " fields will be randomly selected for each player";
      how_many.appendChild(document.createTextNode(text));
      document.getElementById("play-button").style.display = "block";
    }
  }

  apiCall("/card/" + card_id + "/fields", "GET", null, onSuccess, (res, status) => console.warn(status, res));
}

function addField(card_id) {
  let contents = document.getElementById("fields-add-text").value
  apiCall("/card/" + card_id + "/fields", "PUT", {"contents": contents}, (_res) => buildFieldEditList(document.getElementById("fields-container")), (res, status) => console.warn(status, res))
}

window.addEventListener("turbo:load", _e => {
  let fields = document.getElementsByClassName("field");
  Array.from(fields).forEach(f => processBingoField(f));

  let fields_container = document.getElementById("fields-container");
  if(fields_container !== null){
    buildFieldEditList(fields_container)
  }

  let fields_add_button = document.getElementById("fields-add-button");
  let fields_add_text = document.getElementById("fields-add-text");
  if(fields_add_button !== null){
    let card_id = fields_add_button.getAttribute("card_id");
    let f = function(_e){
      addField(card_id);
    }
    fields_add_button.addEventListener("click", f)
    onEnter(fields_add_text, f)
  }
});

//It's all Purecss from here on out
(function (window, document) {
    // we fetch the elements each time because docusaurus removes the previous
    // element references on page navigation
    function getElements() {
        return {
            layout: document.getElementById('layout'),
            menu: document.getElementById('menu'),
            menuLink: document.getElementById('menuLink')
        };
    }
    function toggleClass(element, className) {
        var classes = element.className.split(/\s+/);
        var length = classes.length;
        var i = 0;

        for (; i < length; i++) {
            if (classes[i] === className) {
                classes.splice(i, 1);
                break;
            }
        }
        // The className is not found
        if (length === classes.length) {
            classes.push(className);
        }

        element.className = classes.join(' ');
    }

    function toggleAll() {
        var active = 'active';
        var elements = getElements();

        toggleClass(elements.layout, active);
        toggleClass(elements.menu, active);
        toggleClass(elements.menuLink, active);
    }

    function handleEvent(e) {
        var elements = getElements();

        if (e.target.id === elements.menuLink.id) {
            toggleAll();
            e.preventDefault();
        } else if (elements.menu.className.indexOf('active') !== -1) {
            toggleAll();
        }
    }

    document.addEventListener('click', handleEvent);

}(window, document));
