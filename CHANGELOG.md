# Changelog

All notable changes to the Claude Flow Docker Template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-07-24

### Added
- Initial release of Claude Flow Docker Template
- Dockerfile with Node.js 22 and Deno support
- Flexible docker-compose.yml with environment variable configuration
- Deno shim for SPARC mode compatibility
- Shell scripts for easy Claude Flow access (cf, claude-flow, shell, dev)
- direnv integration for convenient command shortcuts
- Automated setup script for quick installation
- Support for multiple package managers (npm, yarn, pnpm)
- Optional PostgreSQL and Redis services via Docker Compose profiles
- Comprehensive documentation and troubleshooting guide
- Security-focused configuration with non-root user
- Resource limits and health checks
- Project-agnostic design with customization via environment variables

### Security
- Non-root user execution by default
- Minimal base image (node:22-slim)
- Proper .dockerignore to exclude sensitive files

[1.0.0]: https://github.com/redpop/claude-flow-docker-template/releases/tag/v1.0.0