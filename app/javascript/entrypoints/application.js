// Make sure this is in application layout
// <%= vite_client_tag %>
// <%= vite_javascript_tag 'application' %>
console.log("Vite ⚡️ Rails");

import "../controllers";
import "@hotwired/turbo-rails";
import { hmrImportChannels } from "~/hmr/channel_hmr.js";
import ShortcutsManager from "@/shortcuts/shortcuts_manager.js";
import { Idiomorph } from "idiomorph"

const shortcutsManager = ShortcutsManager();
shortcutsManager.setup();
window.shortcutsManager = shortcutsManager;


const morphPageUpdates = (event) => {
  event.detail.render = (currentElement, newElement) => {
    Idiomorph.morph(currentElement, newElement)
  }
}

document.addEventListener("turbo:before-render", morphPageUpdates)

// Import all channels.
const channels = hmrImportChannels(
  import.meta.glob("../channels/*_channel.js", {
    eager: true,
  }),
);

if (import.meta.hot) {
  import.meta.hot.accept((newModule) => {
    console.log(`ActionCableHmr: Performing HMR`);
  });

  import.meta.hot.dispose((data) => {
    console.log("Dispose called on data", data);
    channels.forEach((channel) => {
      channel.teardown();
    });

    window.shortcutsManager.dispose();
    window.shortcutsManager = null;

    document.removeEventListener("turbo:before-render", morphPageUpdates)
  });
}
