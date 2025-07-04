import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    if (localStorage.theme === "dark") {
      document.body.dataset.theme = "sapphire";
    }
  }

  toggle(e) {
    if (localStorage.theme === "dark") {
      localStorage.theme = "light";
      document.body.dataset.theme = "aqua";
    } else {
      localStorage.theme = "dark";
      document.body.dataset.theme = "sapphire";
    }
  }
}
