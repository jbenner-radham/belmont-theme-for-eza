import buffer from 'node:buffer';
import fs from 'node:fs';
import path from 'node:path';

const filenames = [
  '.pre-commit-config.yaml',
  'arch.iso',
  'Cargo.toml',
  'bin',
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
  'file.yml',
  'Makefile',
  'nginx.conf',
  'package.json',
  'pyproject.toml',
  'README.md',
  'song.flac'
];
const examplePath = path.resolve(import.meta.dirname, '..', 'example');
const dirnames = ['src'];

fs.rmSync(examplePath, { force: true, recursive: true });
fs.mkdirSync(examplePath, { recursive: true });
filenames.forEach((filename) => {
  const { MAX_STRING_LENGTH } = buffer.constants;
  const totalCharCount =
    Math.random() *
    (Math.random() > 0.5 ? 10_000 : 1) *
    (Math.random() > 0.5 ? 10_000 : 1) *
    (Math.random() > 0.5 ? 10_000 : 1);
  const createCharCount = Math.min(MAX_STRING_LENGTH, totalCharCount);
  const appendCharCountCandidate = Math.max(
    totalCharCount - MAX_STRING_LENGTH,
    0
  );
  const appendCharCount = Math.min(MAX_STRING_LENGTH, appendCharCountCandidate);
  const filePath = path.join(examplePath, filename);
  fs.writeFileSync(filePath, '0'.repeat(createCharCount));
  fs.appendFileSync(filePath, '0'.repeat(appendCharCount));
});
dirnames.forEach((dirname) =>
  fs.mkdirSync(path.join(examplePath, dirname), { recursive: true })
);
fs.chmodSync(path.join(examplePath, 'bin'), 0o755);
