import consumer from "./consumer.js";
import { handleHmr } from "~/hmr/hmr.js";
import { wrapChannel } from "~/hmr/channel_hmr.js";

const createSubscription = () => {
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

export default wrapChannel(createSubscription);
