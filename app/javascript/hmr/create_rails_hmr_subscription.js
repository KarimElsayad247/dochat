import consumer from "@/channels/consumer.js";
import { handleHmr } from "@/hmr/hmr.js";

export default () => {
  console.log("setting up hmr subscription");

  return consumer.subscriptions.create(
    { channel: "HmrChannel" },
    {
      connected() {
        console.log("Hot Markup Replacement is ready");
      },

      received(data) {
        console.log("Received HMR Request");
        handleHmr(data.html);
      },
    },
  );
};
