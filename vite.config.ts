import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import StimulusHMRPlugin from "vite-plugin-stimulus-hmr";

export default defineConfig({
  plugins: [RubyPlugin(), StimulusHMRPlugin()],
});
