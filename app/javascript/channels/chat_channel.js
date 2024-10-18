import consumer from "./consumer";

consumer.subscriptions.create(
  { channel: "ChatChannel", room: "Best Room" },
  {
    received(date) {
      this.appendLine(data);
    },

    appendLine(data) {
      const chatMessage = this.createLine(data);
      const chatContainer = document.querySelector("[data-chat-room='Best Room']");
      chatContainer.insertAdjacentHtml("beforeend", chatMessage)
    },

    createLine(data) {
      return `
      <article className="chat-line">
        <span className="speaker">${data["sent_by"]}</span>
        <span className="body">${data["body"]}</span>
      </article>
    `;
    },
  }
);
