import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="sidebar"
export default class extends Controller {
  connect() {
    const sidebar = document.getElementById("super-sidebar");
    // sidebar.dataset.expanded = document.cookie["sidebar_expanded"];
  }

  toggle(e) {
    const sidebar = document.getElementById("super-sidebar");
    const newState = sidebar.dataset.expanded === "true" ? "false" : "true";
    sidebar.dataset.expanded = newState;
    // document.cookie = `sidebar_expanded=${newState}`;
    // console.log(document.cookie);
  }
}
