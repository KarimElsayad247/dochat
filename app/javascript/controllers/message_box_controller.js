import { Controller } from "@hotwired/stimulus";
import {
  Modifiers,
  NamedControlCharacters,
} from "@/shortcuts/shortcuts_utils.js";

export default class extends Controller {
  static targets = ["form", "input", "send"];
  onSubmitHandler;

  initialize() {
    window.shortcutsManager.register(
      {
        modifier: Modifiers.Ctrl,
        key: NamedControlCharacters.Enter,
      },
      () => {
        this.formTarget.requestSubmit();
      },
    );
  }

  clearInput() {
    this.inputTarget.value = "";
  }
}
