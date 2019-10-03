import hljs from "highlight.js";
import elm from "highlight.js/lib/languages/elm.js";
import "./style.css";
import "highlight.js/styles/dracula.css";

// @ts-ignore
window.hljs = hljs;
hljs.registerLanguage('elm', elm);

const { Elm } = require("./src/Main.elm");
const pagesInit = require("elm-pages");

pagesInit({
  mainElmModule: Elm.Main
});

hljs.initHighlightingOnLoad();