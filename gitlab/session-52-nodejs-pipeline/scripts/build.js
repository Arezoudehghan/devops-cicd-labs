const fs = require('node:fs');
const path = require('node:path');

const source = path.join(__dirname, '..', 'src', 'index.js');
const outputDir = path.join(__dirname, '..', 'dist');
const output = path.join(outputDir, 'index.js');

fs.rmSync(outputDir, { recursive: true, force: true });
fs.mkdirSync(outputDir, { recursive: true });
fs.copyFileSync(source, output);

console.log(`Build created: ${output}`);
