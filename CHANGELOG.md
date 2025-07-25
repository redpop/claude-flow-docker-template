# Changelog

All notable changes to the Claude Flow Docker Template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-07-25

### Fixed
- **Volume name mismatches** in docker-compose.yml causing container startup failures
- **macOS GID 20 conflict** with intelligent fallback to safe GID values (501, 1000, 999, etc.)
- **Docker context issues** when using docker/ subdirectory layout
- **.env file handling** with automatic symlink creation for docker subdirectory

### Added
- Automatic platform detection for macOS-specific GID handling in setup.sh
- Intelligent GID conflict resolution in Dockerfile with fallback mechanism
- Better error messages and validation in setup script
- Comprehensive documentation about template purpose and future outlook
- Enhanced troubleshooting section in README

### Changed
- Simplified volume naming convention (removed dynamic PROJECT_NAME prefixes in volume references)
- Improved setup.sh script with automatic .env symlink creation for docker/ layout
- Updated README with clear explanation of template purpose, roadmap, and obsolescence plan
- Enhanced Docker Compose profiles documentation with use cases
- Better cross-platform compatibility with macOS GID detection

### Security
- Improved GID conflict resolution preventing Docker build failures
- Better isolation between named volumes and host system groups

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