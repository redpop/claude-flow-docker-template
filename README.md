# Claude Flow Docker Template 🌊


A reusable Docker environment for running [Claude Flow](https://github.com/ruvnet/claude-flow) in any project, solving the current Node.js/Deno compatibility issues with SPARC mode.

## 🎯 Why This Template Exists

**Current Problem**: [Claude Flow](https://github.com/ruvnet/claude-flow) v2.0.0-alpha has compatibility issues with Node.js environments, specifically:
- "Deno is not defined" errors when using SPARC mode ([Issue #146](https://github.com/ruvnet/claude-flow/issues/146))
- Runtime conflicts between Node.js and Deno dependencies ([Issue #108](https://github.com/ruvnet/claude-flow/issues/108))
- Inconsistent behavior across different operating systems

**This Template Solves**:
- ✅ Provides isolated Docker environment with both Node.js and Deno
- ✅ Includes custom Deno shim for Node.js compatibility
- ✅ Ensures consistent behavior across macOS, Linux, and Windows
- ✅ Eliminates local environment conflicts

**Future Outlook**: This template serves as a **temporary workaround** until [Claude Flow's](https://github.com/ruvnet/claude-flow) Node.js/Deno integration is stabilized. However, it will remain valuable for:
- Consistent development environments across teams
- Isolation of [Claude Flow](https://github.com/ruvnet/claude-flow) dependencies
- Production deployments requiring containerization

## Features

- 🚀 **One-command setup** - Get [Claude Flow](https://github.com/ruvnet/claude-flow) running in minutes
- 🔧 **Deno support** - Full SPARC mode compatibility with Deno shim
- 📦 **Project-agnostic** - Works with any Node.js project
- 🛠️ **Flexible configuration** - Customize via environment variables
- 🔄 **Multiple package managers** - Support for npm, yarn, and pnpm
- 🎯 **Convenient shortcuts** - Simple commands like `cf` and `cf-shell`
- 🐳 **Production-ready** - Optimized Dockerfile with multi-stage builds
- 🔒 **Security-focused** - Non-root user, minimal attack surface

## Quick Start

### Option 1: Using GitHub Template (Recommended)

1. Click "Use this template" on GitHub
2. Clone your new repository
3. Run the setup:
   ```bash
   ./setup.sh
   ```
4. Start using [Claude Flow](https://github.com/ruvnet/claude-flow):
   ```bash
   ./bin/cf --help
   ```

### Option 2: Manual Installation

1. Download the template:
   ```bash
   git clone https://github.com/redpop/claude-flow-docker-template
   cd claude-flow-docker-template
   ```

2. Run setup in your project:
   ```bash
   cd /path/to/your/project
   /path/to/claude-flow-docker-template/setup.sh
   ```

3. Configure and start using [Claude Flow](https://github.com/ruvnet/claude-flow) as above

## Available Commands

After setup, these commands are available in your project:

| Command | Description |
|---------|-------------|
| `./bin/cf` | Run [Claude Flow](https://github.com/ruvnet/claude-flow) (recommended, without Deno shim) |
| `./bin/claude-flow` | Run [Claude Flow](https://github.com/ruvnet/claude-flow) with Deno shim (for SPARC compatibility) |
| `./bin/cf-shell` | Enter the Claude Flow container shell |

### With direnv (Optional)

If you have [direnv](https://direnv.net) installed:

```bash
direnv allow
```

Then you can use the commands without the `./bin/` prefix:
```bash
cf swarm init --topology mesh
cf-shell
```

## Configuration

### Environment Variables

Edit `.env` to customize your setup (optional):

```bash
# User Configuration (automatically set by setup.sh)
USER_UID=1001
USER_GID=1001

# Optional: Customize if needed
PROJECT_NAME=myproject
```

### Starting Claude Flow

```bash
# Start the Claude Flow container
docker compose up -d

# Or use the convenient shell script
./bin/cf-shell
```

## Directory Structure

After setup, your project will have:

```
your-project/
├── docker/                 # (optional, based on setup choice)
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── .dockerignore
├── scripts/
│   ├── deno-shim-safe.js
│   └── claude-flow-launcher.sh
├── bin/
│   ├── cf
│   ├── claude-flow
│   └── cf-shell
├── .envrc                  # direnv configuration
├── .env                    # Your configuration
└── .env.example            # Configuration template
```

## Updating the Template

To update your Docker setup with the latest template changes:

### If using Git subtree:
```bash
git subtree pull --prefix=.claude-flow-docker \
  https://github.com/yourusername/claude-flow-docker-template main
```

### Manual update:
1. Pull the latest template
2. Re-run `setup.sh`
3. Review and merge any changes

## Troubleshooting

### Common Issues

#### "Deno is not defined" error
The template includes a Deno shim that solves this. Use `./bin/claude-flow` for SPARC mode.

#### Permission denied errors
Make sure your USER_UID and USER_GID in `.env` match your host user:
```bash
echo "USER_UID=$(id -u)" >> .env
echo "USER_GID=$(id -g)" >> .env
```

#### Container won't start
Check Docker logs:
```bash
docker compose logs claude-flow
```

#### Port conflicts
Change port mappings in `.env`:
```bash
VITE_PORT=5174
CLAUDE_FLOW_PORT=3001
```

### Debug Mode

Enter the container for debugging:
```bash
./bin/cf-shell
# Inside container:
claude-flow --version
deno --version
node --version
```

## 🛠️ Recent Improvements (v1.1.0)

**Fixed in this version**:
- ✅ Volume name mismatches in docker-compose.yml
- ✅ macOS GID 20 conflict with intelligent fallback
- ✅ Automatic .env symlink creation for docker/ subdirectory
- ✅ Better cross-platform compatibility

## 🔄 When Will This Template Be Obsolete?

This template becomes less critical when:
- ✅ Claude Flow natively supports Node.js environments without Deno conflicts
- ✅ SPARC mode works consistently across operating systems
- ✅ Installation doesn't require runtime workarounds

**Current Status**: Still necessary due to ongoing Deno/Node.js compatibility issues in Claude Flow alpha versions.

## Contributing

We welcome contributions that improve cross-platform compatibility and ease of use:

1. Fork the template repository
2. Create your feature branch
3. Test your changes thoroughly across platforms
4. Submit a pull request with clear description

**Testing Priorities**: macOS, Linux, Windows, ARM64, AMD64

## License

MIT License - feel free to use this template in your projects!

## Support

- 🐛 [Report issues](https://github.com/redpop/claude-flow-docker-template/issues)
- 📚 [Claude Flow Documentation](https://github.com/ruvnet/claude-flow)

---

Made with ❤️ for the [Claude Flow](https://github.com/ruvnet/claude-flow) community