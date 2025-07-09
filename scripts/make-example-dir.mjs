import fs from 'node:fs';
import path from 'node:path';

const filenames = [
  '.pre-commit-config.yaml',
  'arch.iso',
  'Cargo.lock',
  'Cargo.toml',
  'cfg.ini',
  'file',
  'file.cjs',
  'file.cpp',
  'file.js',
  'file.mp4',
  'file.pdf',
  'file.pem',
  'file.png',
  'file.py',
  'file.rs',
  'file.sh',
  'file.tar.gz',
  'file.toml',
  'file.yaml',
  'justfile',
  'LICENSE',
  'Makefile',
  'nginx.conf',
  'package.json',
  'package-lock.json',
  'pyproject.toml',
  'README.md',
  'resume.docx',
  'song.flac',
  'song.mp3',
  'theme.yaml'
];
const examplePath = path.resolve(import.meta.dirname, '..', 'example');
const dirnames = ['src'];

fs.rmSync(examplePath, { force: true, recursive: true });
fs.mkdirSync(examplePath, { recursive: true });
filenames.forEach((filename) => {
  const count = Math.random() * 10_000 * (Math.random() > 0.5 ? 10_000 : 1);
  fs.writeFileSync(path.join(examplePath, filename), '0'.repeat(count));
});
dirnames.forEach((dirname) =>
  fs.mkdirSync(path.join(examplePath, dirname), { recursive: true })
);
fs.chmodSync(path.join(examplePath, 'file'), 0o755);
