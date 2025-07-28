import childProcess from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import pkg from '../package.json' with { type: 'json' };

const rootPath = path.resolve(import.meta.dirname, '..');
const artifactsPath = path.resolve(rootPath, 'dist');
const themePath = path.resolve(rootPath, pkg.main);
const artifactThemeFilename = 'theme.yml';
const artifactThemePath = path.resolve(artifactsPath, artifactThemeFilename);
const artifactArchivePathStem = `belmont-theme-for-eza-${pkg.version}`;

fs.rmSync(artifactsPath, { force: true, recursive: true });
fs.mkdirSync(artifactsPath, { recursive: true });
fs.copyFileSync(themePath, artifactThemePath);

const artifactThemeSrc = fs.readFileSync(artifactThemePath).toString();
const artifactThemeSrcPrefix = `# Belmont Theme for Eza v${pkg.version}\n\n`;

fs.writeFileSync(artifactThemePath, artifactThemeSrcPrefix + artifactThemeSrc);
childProcess.execSync(
  `tar -czf ${artifactArchivePathStem}.tar.gz ${artifactThemeFilename}`,
  { cwd: artifactsPath }
);
childProcess.execSync(
  `zip ${artifactArchivePathStem}.zip ${artifactThemeFilename}`,
  { cwd: artifactsPath }
);
fs.rmSync(artifactThemePath, { force: true });
