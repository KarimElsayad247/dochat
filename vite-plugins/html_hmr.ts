import { HmrContext, Plugin } from "vite";

export const DisableHtmlReload = (): Plugin => {
  return {
    name: "DisableHtmlReload",
    async handleHotUpdate(ctx: HmrContext) {
      if (ctx.file.endsWith("html") || ctx.file.endsWith("erb")) {
        return [];
      }
    },
  };
};
