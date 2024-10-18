// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

const refreshCss = (filename) => {
  const stylesheetsNodelist = document.querySelectorAll("[rel='stylesheet']");
  const stylesheets = Array.from(stylesheetsNodelist);
  const stylesheetToUpdate = stylesheets.filter((stylesheet) => {
    const href = stylesheet.getAttribute("href");
    const assetName = href.split("/").pop();
    const filenameWithoutExtention = filename.split(".")[0];
    return assetName.startsWith(filenameWithoutExtention);
  })[0];
  console.log(stylesheetToUpdate);

  const href = stylesheetToUpdate.getAttribute("href").split("?")[0];
  const newHref = href + "?version=" + new Date().toISOString();
  stylesheetToUpdate.setAttribute("href", newHref);
};

const refresh = (filename) => {
  if (filename.endsWith(".css")) {
    refreshCss(filename)
  }
};

window.refresh = refresh;
window.addEventListener("load", () => {
  const ws = new WebSocket("ws://localhost:9999/");
  ws.onopen = () => {
    console.log("Hot reload web socket connection opened");
  };
  ws.onmessage = (event) => {
    let filename;
    try {
      filename = JSON.parse(event.data).filename;
    } catch (e) {
      console.log(event.data);
    }

    if (filename) {
      refresh(filename);
    }
  };
});
