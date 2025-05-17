import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import StimulusHMRPlugin from "vite-plugin-stimulus-hmr";
import { DisableHtmlReload } from "./vite-plugins/html_hmr.js";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMRPlugin(),
    DisableHtmlReload(),
  ],
});
