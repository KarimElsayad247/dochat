// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>

console.log("Vite ⚡️ Rails");

import "../controllers";
import "@hotwired/turbo-rails";
import { hmrImportChannels } from "~/hmr/channel_hmr.js";
import ShortcutsManager from "@/shortcuts/shortcuts_manager.js";

const shortcutsManager = ShortcutsManager();
shortcutsManager.setup();
window.shortcutsManager = shortcutsManager;

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
  });
}
