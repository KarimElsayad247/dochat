import consumer from "./consumer";

console.log("subscribing")

consumer.subscriptions.create(
  { channel: "ChatChannel", room: "Best Room" },
  {
    received(data) {
      this.appendLine(data);
    },

    appendLine(data) {
      const chatMessage = this.createLine(data);
      const chatContainer = document.querySelector("[data-chat-room='Best Room']");
      chatContainer.insertAdjacentHTML("beforeend", chatMessage)
    },

    createLine(data) {
      return `
      <article class="chat-line">
        <span class="speaker">${data["sent_by"]}</span>
        <span class="body">${data["body"]}</span>
      </article>
    `;
    },
  }
);
