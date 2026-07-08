// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

const BACKGROUND_IMAGE = 'url("/bug.png")';

// To my great disappointment, localStorage only supports strings...

function toggleBingoField(field, _event) {
  if(localStorage.getItem(field.id) === "true"){
    localStorage.setItem(field.id, "false")
    field.style.backgroundImage = ""
  } else { 
    localStorage.setItem(field.id, "true")
    field.style.backgroundImage = BACKGROUND_IMAGE;
  }
}

function processBingoField(field) {
  if(localStorage.getItem(field.id) === null){
    localStorage.setItem(field.id, "false")
  }else if(localStorage.getItem(field.id) === "true"){
    field.style.backgroundImage = BACKGROUND_IMAGE;
  }
  field.addEventListener("click", e => toggleBingoField(field, e))
}


window.addEventListener("turbo:load", _e => {
  let fields = document.getElementsByClassName("field")
  Array.from(fields).forEach(f => processBingoField(f))
});

