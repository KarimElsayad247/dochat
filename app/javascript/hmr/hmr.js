import { DiffDOM, nodeToObj } from "diff-dom";

export const handleHmr = (html) => {
  const newDocument = new DOMParser().parseFromString(html, "text/html");
  let options = {
    diffcap: 500,
    maxDepth: 9999,
    maxChildCount: 9999,
    valueDiffing: false,
  };
  const dd = new DiffDOM(options);

  const oldObj = nodeToObj(document.body, options);
  const newObj = nodeToObj(newDocument.body, options);

  const diff = dd.diff(oldObj, newObj);
  dd.apply(document.body, diff);
  console.log(diff);
};
