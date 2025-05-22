const wrapChannel = (createSubscription) => {
  let subscription;

  const setup = () => {
    subscription = createSubscription();
  };

  const teardown = () => {
    console.debug("Removing subscription ", subscription);
    subscription.unsubscribe();
  };

  return {
    setup,
    teardown,
  };
};

export const hmrImportChannels = (channelExports) => {
  const channelKeys = Reflect.ownKeys(channelExports);
  const channels = channelKeys.map((key) => {
    return wrapChannel(channelExports[key].default);
  });

  channels.forEach((channel) => {
    channel.setup();
  });

  return channels;
};
