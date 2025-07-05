import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar", "chat", "forum", "docs"];
  activeClass = "active";
  sidebarEntries = [];

  connect() {
    if (document.documentElement.hasAttribute('data-turbo-preview')) {
      return;
    }

    console.log("connected");
    this.sidebarEntries = [
      this.chatTarget,
      this.forumTarget,
      this.docsTarget,
    ]

  }

  disconnect() {
    console.log("disconnected");
    console.log("will connect again soon");
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
