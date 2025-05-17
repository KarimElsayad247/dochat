// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>

console.log("Vite ⚡️ Rails");

import "../controllers";
import "@hotwired/turbo-rails";
import { importChannels } from "~/hmr/channel_hmr.js";

// Import all channels.
const channels = importChannels(
  import.meta.glob("../channels/*_channel.js", {
    eager: true,
  }),
);


// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'
if (import.meta.hot) {
  import.meta.hot.accept((newModule) => {
    console.log("Hot Reloading application.js");
  });

  import.meta.hot.dispose((data) => {
    console.log("Dispose called on data", data);
    channels.forEach((channel) => {
      channel.teardown();
    });
  });
}
