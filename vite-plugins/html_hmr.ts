import { HmrContext, Plugin } from "vite";

export const DisableHtmlReload = (): Plugin => {
  return {
    name: "rails_hmr:disable_reload",
    async handleHotUpdate(ctx: HmrContext) {
      if (ctx.file.endsWith("html") || ctx.file.endsWith("erb")) {
        return [];
      }
    },
  };
};
