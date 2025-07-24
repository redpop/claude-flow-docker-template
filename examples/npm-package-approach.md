# NPM Package Approach (Alternative)

If you prefer to distribute the Claude Flow Docker setup as an npm package, here's how to set it up:

## Creating the NPM Package

1. **Create package.json for the template:**

```json
{
  "name": "@yourorg/claude-flow-docker",
  "version": "1.0.0",
  "description": "Docker setup for Claude Flow development",
  "bin": {
    "claude-flow-docker-init": "./init.js"
  },
  "files": [
    "docker/",
    "scripts/",
    "bin/",
    "templates/",
    "init.js"
  ],
  "keywords": ["claude-flow", "docker", "development"],
  "license": "MIT"
}
```

2. **Create init.js script:**

```javascript
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const templateDir = path.join(__dirname, 'templates');
const targetDir = process.cwd();

console.log('🌊 Setting up Claude Flow Docker environment...');

// Copy template files
const filesToCopy = [
  'docker/Dockerfile',
  'docker/docker-compose.yml',
  'docker/.dockerignore',
  'scripts/deno-shim-safe.js',
  'scripts/claude-flow-launcher.sh',
  'bin/cf',
  'bin/claude-flow',
  'bin/shell',
  'bin/dev',
  '.envrc',
  '.env.example'
];

filesToCopy.forEach(file => {
  const src = path.join(templateDir, file);
  const dest = path.join(targetDir, file);
  
  // Create directory if needed
  const dir = path.dirname(dest);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  
  // Copy file
  if (!fs.existsSync(dest)) {
    fs.copyFileSync(src, dest);
    console.log(`✅ Created ${file}`);
  } else {
    console.log(`⚠️  ${file} already exists, skipping...`);
  }
});

// Make scripts executable
execSync('chmod +x bin/*');

// Create .env from .env.example
if (!fs.existsSync('.env')) {
  fs.copyFileSync('.env.example', '.env');
  console.log('✅ Created .env from .env.example');
}

console.log('\n✅ Claude Flow Docker setup complete!');
console.log('\nNext steps:');
console.log('1. Edit .env and add your ANTHROPIC_API_KEY');
console.log('2. Run: ./bin/cf --help');
```

## Publishing the Package

```bash
npm publish --access public
```

## Using the Package

In any project:

```bash
# Install and run setup
npx @yourorg/claude-flow-docker

# Or install globally
npm install -g @yourorg/claude-flow-docker
claude-flow-docker-init
```

## Advantages

- ✅ Easy distribution via npm
- ✅ Version management
- ✅ Can include setup logic
- ✅ Works with corporate npm registries

## Disadvantages

- ❌ Requires npm/node to install
- ❌ Updates require re-running init
- ❌ More complex than Git template