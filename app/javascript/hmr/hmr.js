import { DiffDOM } from "diff-dom";

export const handleHmr = (html) => {
  const newDocument = new DOMParser().parseFromString(html, "text/html");
  let options = {
    diffcap: 500,
    maxDepth: 9999,
    maxChildCount: 9999,
    valueDiffing: false,
  };
  const dd = new DiffDOM(options);
  const diff = dd.diff(document.body, newDocument.body);
  dd.apply(document.body, diff);
};
