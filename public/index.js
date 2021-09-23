/** @typedef {{load: (Promise<unknown>); flags: (unknown)}} ElmPagesInit */

import {render} from 'https://cdn.skypack.dev/pin/datocms-structured-text-to-dom-nodes@v1.2.0-QoqZtEGY3vNWth00FpJ2/mode=imports,min/optimized/datocms-structured-text-to-dom-nodes.js';
import highlightJs from 'https://cdn.skypack.dev/pin/highlight.js@v11.2.0-K5rmnVDpjYZTNzS4QEU2/mode=imports,min/optimized/highlightjs.js';


/** @type ElmPagesInit */
export default {
  load: async function (elmLoaded) {
    const app = await elmLoaded;
  },
  flags: function () {
    return "You can decode this in Shared.elm using Json.Decode.string!";
  },
};

class StructuredText extends HTMLElement {
  static get observedAttributes() {
    return ['content', 'blocks'];
  }

  attributeChangedCallback() {
    if (!this.hasAttribute('content') || !this.hasAttribute('blocks')) {
      return;
    }
    const content = JSON.parse(
      this.getAttribute('content')
    )
    const blocks = JSON.parse(
      this.getAttribute('blocks')
    )
    render({value: content, blocks }, {
      renderBlock({ record, adapter: { renderNode } }) {
        return renderNode('img', { src: record.url, className: record.size !== 'FULL_WIDTH' ? 'fullWidth' : ''});
      }
    }).forEach(child => this.appendChild(child));
    setTimeout(() => {
      document.querySelectorAll('pre code').forEach((el) => {
        console.log(highlightJs.highlightElement)
        highlightJs.highlightElement(el);
      });
    });
  }
}

customElements.define("structured-text", StructuredText);


class YoutubeEmbed extends HTMLElement {
  static get observedAttributes() {
    return ['data-content'];
  }

  attributeChangedCallback() {
    console.log(this.getAttribute('data-content').replace(/aaaaa/g, '"'))
    this.innerHTML = this.getAttribute('data-content').replace(/aaaaa/g, '"');
  }
}

customElements.define("youtube-embed", YoutubeEmbed);


// Load hightlight.js stylesheet
const stylesheetTag = document.createElement('link');
stylesheetTag.rel = 'stylesheet';
stylesheetTag.href = 'https://cdn.skypack.dev/-/highlight.js@v11.2.0-K5rmnVDpjYZTNzS4QEU2/dist=es2020,mode=raw/styles/dark.css';
window.document.head.appendChild(stylesheetTag);

// Load Plausible (analytics)
const scriptTag = document.createElement('script');
scriptTag.type = 'text/javascript';
scriptTag.async = true;
scriptTag.src = 'https://plausible.io/js/plausible.js';
scriptTag.defer = true;
scriptTag['data-domain'] = 'grenat.eu';
window.document.body.appendChild(scriptTag);
