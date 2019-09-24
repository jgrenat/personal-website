import {Elm} from './src/Main.elm';

const app = Elm.Main.init({flags: null});

app.ports.highlightAll.subscribe(() => {
    setTimeout(function() {
        document.querySelectorAll('pre code').forEach((block) => {
            hljs.highlightBlock(block);
        });
    }, 100);
});

