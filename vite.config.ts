import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import StimulusHMRPlugin from "vite-plugin-stimulus-hmr";
import { DisableHtmlReload } from "./vite-plugins/html_hmr.js";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [
    tailwindcss(),
    RubyPlugin(),
    StimulusHMRPlugin(),
    DisableHtmlReload(),
  ],
});
