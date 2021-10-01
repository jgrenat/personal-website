import nodeResolve from 'rollup-plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';

export default {
  input: 'public/index-template.js',
  plugins: [
    commonjs(),
    nodeResolve({
      jsnext: true
    })
  ],
  output: {
    file: 'public/index.js',
    format: 'es'
  }
}
