# Claude Flow Docker Template 🌊

A reusable Docker environment for running Claude Flow in any project, with full support for SPARC mode and Deno runtime.

## Features

- 🚀 **One-command setup** - Get Claude Flow running in minutes
- 🔧 **Deno support** - Full SPARC mode compatibility with Deno shim
- 📦 **Project-agnostic** - Works with any Node.js project
- 🛠️ **Flexible configuration** - Customize via environment variables
- 🔄 **Multiple package managers** - Support for npm, yarn, and pnpm
- 🎯 **Convenient shortcuts** - Simple commands like `cf` and `shell`
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
4. Add your API key to `.env`:
   ```bash
   ANTHROPIC_API_KEY=your_key_here
   ```
5. Start using Claude Flow:
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

3. Configure and start using Claude Flow as above

## Available Commands

After setup, these commands are available in your project:

| Command | Description |
|---------|-------------|
| `./bin/cf` | Run Claude Flow (recommended, without Deno shim) |
| `./bin/claude-flow` | Run Claude Flow with Deno shim (for SPARC compatibility) |
| `./bin/shell` | Enter the container shell |
| `./bin/dev` | Start your development server in the container |

### With direnv (Optional)

If you have [direnv](https://direnv.net) installed:

```bash
direnv allow
```

Then you can use the commands without the `./bin/` prefix:
```bash
cf swarm init --topology mesh
shell
dev
```

## Configuration

### Environment Variables

Edit `.env` to customize your setup:

```bash
# Required
ANTHROPIC_API_KEY=your_api_key_here

# Project settings
PROJECT_NAME=myproject
PACKAGE_MANAGER=pnpm  # or yarn, npm

# Ports
VITE_PORT=5173
CLAUDE_FLOW_PORT=3000

# Resources (optional)
CPU_LIMIT=2
MEMORY_LIMIT=4G
```

### Docker Compose Profiles

The template includes optional services:

```bash
# Start with PostgreSQL
docker compose --profile with-db up -d

# Start with Redis
docker compose --profile with-cache up -d

# Start with both
docker compose --profile with-db --profile with-cache up -d
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
│   ├── shell
│   └── dev
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
./bin/shell
# Inside container:
claude-flow --version
deno --version
node --version
```

## Advanced Usage

### Custom Dockerfile Extensions

Create `docker/Dockerfile.local` to extend the base image:

```dockerfile
FROM claude-flow:latest

# Add your customizations
RUN apt-get update && apt-get install -y vim

# Add custom tools
COPY my-tools /usr/local/bin/
```

### CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Claude Flow CI
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Start Claude Flow
        run: docker compose up -d
      - name: Run Claude Flow task
        run: ./bin/cf task orchestrate --task "Run tests"
```

### Production Deployment

For production use:

1. Build optimized image:
   ```bash
   docker build --target production -t myapp:latest .
   ```

2. Use production compose file:
   ```yaml
   # docker-compose.prod.yml
   services:
     claude-flow:
       image: myapp:latest
       restart: always
       deploy:
         replicas: 2
   ```

## Contributing

1. Fork the template repository
2. Create your feature branch
3. Test your changes thoroughly
4. Submit a pull request

## License

MIT License - feel free to use this template in your projects!

## Support

- 🐛 [Report issues](https://github.com/redpop/claude-flow-docker-template/issues)
- 💬 [Discussions](https://github.com/redpop/claude-flow-docker-template/discussions)
- 📚 [Claude Flow Documentation](https://docs.anthropic.com/claude-flow)

---

Made with ❤️ for the Claude Flow community