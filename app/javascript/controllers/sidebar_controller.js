import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar", "chat", "forum", "docs"];
  activeClass = "active";
  sidebarEntries = [];

  connect() {
    this.sidebarEntries = [
      this.chatTarget,
      this.forumTarget,
      this.docsTarget,
    ]
    document.addEventListener("turbo:visit", (event) => {
      console.log("visit");
      console.log(event);
    });

  }

  toggleActiveLink(event) {
    this.sidebarEntries.forEach((entry) => {
      entry.querySelector(".icon-button").classList.remove(this.activeClass)
    })
    this.sidebarEntries.forEach((entry) => {
      if (entry.pathname.startsWith(URL.parse(event.detail.url).pathname)) {
        entry.querySelector(".icon-button").classList.add(this.activeClass);
      }
    })

  }

  focusActiveLink(_event) {
    this.sidebarEntries.forEach((entry) => {
      if (entry.pathname.startsWith(document.location.pathname)) {
        entry.querySelector(".icon-button").classList.add(this.activeClass);
      }
    })
  }
}
