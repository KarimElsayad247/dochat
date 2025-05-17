export const wrapChannel = (createSubscription) => {
  let subscription;

  const setup = () => {
    subscription = createSubscription();
  };

  const teardown = () => {
    console.log("Removing subscription ", subscription);
    subscription.unsubscribe();
  };

  return {
    setup,
    teardown,
  };
};

export const importChannels = (channelExports) => {
  const channelKeys = Reflect.ownKeys(channelExports);
  const channels = channelKeys.map((key) => {
    return channelExports[key].default;
  });

  channels.forEach((channel) => {
    channel.setup();
  });

  return channels;
};
