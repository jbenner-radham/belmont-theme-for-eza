import fs from 'node:fs';
import path from 'node:path';

const filenames = [
  '.editorconfig',
  '.gitignore',
  '.markdownlint.yaml',
  '.node-version',
  '.pre-commit-config.yaml',
  '.python-version',
  'arch.iso',
  'Cargo.lock',
  'Cargo.toml',
  'cfg.ini',
  'CHANGELOG.md',
  'demo.cast',
  'file',
  'file.c',
  'file.cjs',
  'file.cpp',
  'file.h',
  'file.js',
  'file.mjs',
  'file.mp4',
  'file.pdf',
  'file.pem',
  'file.png',
  'file.py',
  'file.rs',
  'file.sh',
  'file.tar.gz',
  'file.tgz',
  'file.toml',
  'file.yaml',
  'file.yml',
  'justfile',
  'LICENSE',
  'LICENSE.md',
  'LICENSE.txt',
  'LICENSE-APACHE',
  'LICENSE-MIT',
  'Makefile',
  'nginx.conf',
  'package.json',
  'package-lock.json',
  'pyproject.toml',
  'README.md',
  'resume.docx',
  'song.flac',
  'song.mp3',
  'theme.yaml',
  'theme.yml',
  'uv.lock'
];
const examplePath = path.resolve(import.meta.dirname, '..', 'example');
const dirnames = [
  '.idea',
  '.venv',
  '.vscode',
  'node_modules'
];

fs.rmSync(examplePath, { force: true, recursive: true });
fs.mkdirSync(examplePath, { recursive: true })
filenames.forEach(filename => fs.writeFileSync(path.join(examplePath, filename), ''))
dirnames.forEach(dirname => fs.mkdirSync(path.join(examplePath, dirname), { recursive: true }));
