import { Modifiers } from "@/shortcuts/shortcuts_utils.js";

export default function () {
  const registeredShortcuts = {
    [Modifiers.Shift]: {},
    [Modifiers.Ctrl]: {},
    [Modifiers.Alt]: {},
  };

  /**
   * @param {Object} keyCombo
   * @param {string} keyCombo.key
   * @param {string} keyCombo.modifier
   * @param action function(event)
   */
  const register = (keyCombo, action) => {
    if (keyCombo.key === null || keyCombo.key === undefined) {
      throw  new Error("No Key Provided for shortcut");
    }

    if (keyCombo?.modifier) {
      registeredShortcuts[keyCombo.modifier][keyCombo.key] = action;
    } else {
      registeredShortcuts[keyCombo.key] = action;
    }
  };

  /**
   * @param {KeyboardEventInit} event
   */
  const invoke = (event) => {
    if (event.shiftKey) {
      registeredShortcuts[Modifiers.Shift]?.[event.key]?.();
    } else if (event.altKey) {
      registeredShortcuts[Modifiers.Alt]?.[event.key]?.();
    } else if (event.ctrlKey) {
      registeredShortcuts[Modifiers.Ctrl]?.[event.key]?.();
    } else {
      registeredShortcuts[event.key]?.();
    }
  };

  const setup = () => {
    console.log("Setting up shortcuts");
    document.addEventListener("keydown", invoke);
  };

  const dispose = () => {
    document.removeEventListener("keydown", invoke);
  };

  return {
    register,
    setup,
    dispose,
  };
}
