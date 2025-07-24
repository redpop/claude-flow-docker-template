# Using Claude Flow Docker Template with Git Subtree

This example shows how to integrate the Claude Flow Docker template into an existing project using Git subtree, allowing you to pull updates while maintaining your customizations.

## Initial Setup

1. **Add the template as a subtree in your project:**

```bash
cd /path/to/your/project
git subtree add --prefix=.claude-flow \
  https://github.com/redpop/claude-flow-docker-template.git main --squash
```

This creates a `.claude-flow` directory with all template files.

2. **Run the setup from the subtree:**

```bash
.claude-flow/setup.sh
```

3. **Commit the changes:**

```bash
git add .
git commit -m "Add Claude Flow Docker environment"
```

## Pulling Updates

When the template is updated, you can pull the changes:

```bash
git subtree pull --prefix=.claude-flow \
  https://github.com/redpop/claude-flow-docker-template.git main --squash
```

This will merge the updates while preserving your local modifications.

## Custom Modifications

You can customize the Docker setup without affecting updates:

1. **Create a custom Dockerfile extension:**

```dockerfile
# docker/Dockerfile.custom
FROM myproject-claude-flow:latest

# Add project-specific tools
RUN apt-get update && apt-get install -y postgresql-client

# Add custom scripts
COPY scripts/custom/ /usr/local/bin/
```

2. **Override docker-compose.yml:**

```yaml
# docker-compose.override.yml
services:
  claude-flow:
    build:
      dockerfile: docker/Dockerfile.custom
    environment:
      - CUSTOM_VAR=value
```

## Advantages of Git Subtree

- ✅ No submodule complexity
- ✅ Template code is part of your repository
- ✅ Can modify template files and still pull updates
- ✅ Works with any Git workflow
- ✅ No special commands needed for cloning

## Alternative: Symlink Approach

If you prefer to keep the template separate:

```bash
# Clone template to a shared location
git clone https://github.com/redpop/claude-flow-docker-template.git \
  ~/shared/claude-flow-docker-template

# In your project, create symlinks
ln -s ~/shared/claude-flow-docker-template/docker docker
ln -s ~/shared/claude-flow-docker-template/scripts scripts
ln -s ~/shared/claude-flow-docker-template/bin bin
```

This keeps the template centralized but requires the template to be cloned separately on each machine.