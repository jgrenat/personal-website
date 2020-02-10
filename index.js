import hljs from "highlight.js/lib/highlight";
import elm from "highlight.js/lib/languages/elm.js";
import rust from "highlight.js/lib/languages/rust.js";
import typescript from "highlight.js/lib/languages/typescript.js";
import javascript from "highlight.js/lib/languages/javascript.js";
import java from "highlight.js/lib/languages/java.js";
import bash from "highlight.js/lib/languages/bash.js";
import haskell from "highlight.js/lib/languages/haskell.js";
import idris from "highlight.js/lib/languages/ocaml.js";
import "highlight.js/styles/dracula.css";
hljs.registerLanguage('elm', elm);
hljs.registerLanguage('rust', rust);
import "./style.css";

// @ts-ignore
window.hljs = hljs;
hljs.registerLanguage('elm', elm);
hljs.registerLanguage('rust', rust);
hljs.registerLanguage('typescript', typescript);
hljs.registerLanguage('javascript', javascript);
hljs.registerLanguage('bash', bash);
hljs.registerLanguage('java', java);
hljs.registerLanguage('haskell', haskell);
hljs.registerLanguage('idris', idris);

const { Elm } = require("./src/Main.elm");
const pagesInit = require("elm-pages");

pagesInit({
  mainElmModule: Elm.Main
});

hljs.initHighlightingOnLoad();
