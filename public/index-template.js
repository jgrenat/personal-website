/** @typedef {{load: (Promise<unknown>); flags: (unknown)}} ElmPagesInit */

import hljs from 'highlight.js/lib/core';
import elm from "highlight.js/lib/languages/elm.js";
import rust from "highlight.js/lib/languages/rust.js";
import typescript from "highlight.js/lib/languages/typescript.js";
import javascript from "highlight.js/lib/languages/javascript.js";
import java from "highlight.js/lib/languages/java.js";
import bash from "highlight.js/lib/languages/bash.js";
import haskell from "highlight.js/lib/languages/haskell.js";
import idris from "highlight.js/lib/languages/ocaml.js";

/** @type ElmPagesInit */
export default {
  load: async function (elmLoaded) {
    const app = await elmLoaded;
  },
  flags: function () {
    return "You can decode this in Shared.elm using Json.Decode.string!";
  },
};


class YoutubeEmbed extends HTMLElement {
  static get observedAttributes() {
    return ['data-content'];
  }

  attributeChangedCallback() {
    this.innerHTML = this.getAttribute('data-content').replace(/aaaaa/g, '"');
  }
}

customElements.define("youtube-embed", YoutubeEmbed);


// Load hightlight.js stylesheet
const stylesheetTag = document.createElement('link');
stylesheetTag.rel = 'stylesheet';
stylesheetTag.href = 'https://cdn.skypack.dev/-/highlight.js@v11.2.0-K5rmnVDpjYZTNzS4QEU2/dist=es2020,mode=raw/styles/dark.css';
window.document.head.appendChild(stylesheetTag);

console.log("here", hljs)
hljs.registerLanguage('elm', elm);
hljs.registerLanguage('rust', rust);
hljs.registerLanguage('typescript', typescript);
hljs.registerLanguage('javascript', javascript);
hljs.registerLanguage('js', javascript);
hljs.registerLanguage('bash', bash);
hljs.registerLanguage('java', java);
hljs.registerLanguage('haskell', haskell);
hljs.registerLanguage('idris', idris);
setTimeout(() => hljs.highlightAll(), 1000);

// Load Plausible (analytics)
const scriptTag = document.createElement('script');
scriptTag.type = 'text/javascript';
scriptTag.async = true;
scriptTag.src = 'https://plausible.io/js/plausible.js';
scriptTag.defer = true;
scriptTag['data-domain'] = 'grenat.eu';
window.document.body.appendChild(scriptTag);
