import childProcess from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import pkg from '../package.json' with { type: 'json' };

const rootPath = path.resolve(import.meta.dirname, '..');
const artifactsPath = path.resolve(rootPath, 'dist');
const themeSourcePath = path.resolve(rootPath, pkg.main);
const themeArtifactFilename = 'theme.yml';
const themeArtifactPath = path.resolve(artifactsPath, themeArtifactFilename);
const themeArtifactPrefix = `belmont-theme-for-eza-${pkg.version}`;

fs.rmSync(artifactsPath, { force: true, recursive: true });
fs.mkdirSync(artifactsPath, { recursive: true });
fs.copyFileSync(themeSourcePath, themeArtifactPath);

const themeArtifactSrc = fs.readFileSync(themeArtifactPath).toString();
const themeArtifactSrcPrefix = `# Belmont Theme for Eza v${pkg.version}\n\n`;

fs.writeFileSync(themeArtifactPath, themeArtifactSrcPrefix + themeArtifactSrc);

childProcess.execSync(
  `tar -czf ${themeArtifactPrefix}.tar.gz ${themeArtifactFilename}`,
  { cwd: artifactsPath }
);
childProcess.execSync(
  `zip ${themeArtifactPrefix}.zip ${themeArtifactFilename}`,
  { cwd: artifactsPath }
);
fs.rmSync(themeArtifactPath, { force: true });
