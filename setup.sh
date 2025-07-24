#!/usr/bin/env bash
# Claude Flow Docker Setup Script
# This script sets up Claude Flow Docker environment in your project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}🌊 Claude Flow Docker Setup${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker Desktop first.${NC}"
    exit 1
fi

# Check if docker compose is available
if ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not available. Please install Docker Desktop with Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker is installed${NC}"

# Function to copy files
copy_with_check() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ]; then
        echo -e "${YELLOW}⚠️  $dest already exists. Skipping...${NC}"
    else
        cp -r "$src" "$dest"
        echo -e "${GREEN}✅ Created $dest${NC}"
    fi
}

# Detect if we're in the template directory or installing to a project
if [ -f "$SCRIPT_DIR/docker/Dockerfile" ]; then
    echo "Setting up Claude Flow Docker in current directory..."
    TEMPLATE_DIR="$SCRIPT_DIR"
    TARGET_DIR="$PWD"
else
    echo -e "${RED}❌ Template files not found. Please run from the claude-flow-docker-template directory.${NC}"
    exit 1
fi

# Ask for project layout preference
echo ""
echo "Choose your Docker files layout:"
echo "1) Root level (docker-compose.yml in project root)"
echo "2) Docker subdirectory (docker/docker-compose.yml)"
read -p "Enter choice (1 or 2): " layout_choice

case $layout_choice in
    1)
        # Root level layout
        echo "Using root level layout..."
        
        # Copy Docker files
        copy_with_check "$TEMPLATE_DIR/docker/Dockerfile" "$TARGET_DIR/Dockerfile"
        copy_with_check "$TEMPLATE_DIR/docker/docker-compose.yml" "$TARGET_DIR/docker-compose.yml"
        copy_with_check "$TEMPLATE_DIR/docker/.dockerignore" "$TARGET_DIR/.dockerignore"
        ;;
    2)
        # Docker subdirectory layout
        echo "Using docker subdirectory layout..."
        
        # Create docker directory
        mkdir -p "$TARGET_DIR/docker"
        
        # Copy Docker files
        copy_with_check "$TEMPLATE_DIR/docker/Dockerfile" "$TARGET_DIR/docker/Dockerfile"
        copy_with_check "$TEMPLATE_DIR/docker/docker-compose.yml" "$TARGET_DIR/docker/docker-compose.yml"
        copy_with_check "$TEMPLATE_DIR/docker/.dockerignore" "$TARGET_DIR/docker/.dockerignore"
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

# Copy scripts directory
if [ ! -d "$TARGET_DIR/scripts" ]; then
    mkdir -p "$TARGET_DIR/scripts"
fi
copy_with_check "$TEMPLATE_DIR/scripts/deno-shim-safe.js" "$TARGET_DIR/scripts/deno-shim-safe.js"
copy_with_check "$TEMPLATE_DIR/scripts/claude-flow-launcher.sh" "$TARGET_DIR/scripts/claude-flow-launcher.sh"

# Copy bin directory
copy_with_check "$TEMPLATE_DIR/bin" "$TARGET_DIR/bin"

# Make bin scripts executable
chmod +x "$TARGET_DIR/bin/"*

# Copy environment files
copy_with_check "$TEMPLATE_DIR/.envrc" "$TARGET_DIR/.envrc"
copy_with_check "$TEMPLATE_DIR/.env.example" "$TARGET_DIR/.env.example"

# Create .env if it doesn't exist
if [ ! -f "$TARGET_DIR/.env" ]; then
    cp "$TARGET_DIR/.env.example" "$TARGET_DIR/.env"
    echo -e "${GREEN}✅ Created .env from .env.example${NC}"
    echo -e "${YELLOW}⚠️  Please edit .env and add your ANTHROPIC_API_KEY${NC}"
else
    echo -e "${YELLOW}⚠️  .env already exists. Please ensure ANTHROPIC_API_KEY is set.${NC}"
fi

# Get user's UID and GID
USER_UID=$(id -u)
USER_GID=$(id -g)

# Update .env with user's UID/GID
if [ -f "$TARGET_DIR/.env" ]; then
    if grep -q "USER_UID=" "$TARGET_DIR/.env"; then
        sed -i.bak "s/USER_UID=.*/USER_UID=$USER_UID/" "$TARGET_DIR/.env"
        sed -i.bak "s/USER_GID=.*/USER_GID=$USER_GID/" "$TARGET_DIR/.env"
        rm -f "$TARGET_DIR/.env.bak"
        echo -e "${GREEN}✅ Updated USER_UID and USER_GID in .env${NC}"
    fi
fi

# Check for direnv
if command -v direnv &> /dev/null; then
    echo -e "${GREEN}✅ direnv is installed${NC}"
    echo ""
    echo "To enable direnv shortcuts, run:"
    echo -e "${BLUE}  direnv allow${NC}"
else
    echo -e "${YELLOW}⚠️  direnv is not installed (optional)${NC}"
    echo "Install direnv to use convenient shortcuts: https://direnv.net"
fi

echo ""
echo -e "${GREEN}🎉 Claude Flow Docker setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Edit .env and add your ANTHROPIC_API_KEY"
echo "2. Run 'direnv allow' if you have direnv installed"
echo "3. Start using Claude Flow:"
echo "   - ${BLUE}./bin/cf${NC} - Run Claude Flow"
echo "   - ${BLUE}./bin/shell${NC} - Enter container shell"
echo "   - ${BLUE}./bin/dev${NC} - Start development server"
echo ""
echo "Or use Docker Compose directly:"
echo "   - ${BLUE}docker compose up -d${NC} - Start container"
echo "   - ${BLUE}docker compose exec claude-flow bash${NC} - Enter shell"
echo ""

# Offer to start container now
read -p "Would you like to start the Claude Flow container now? (y/n): " start_now
if [[ $start_now =~ ^[Yy]$ ]]; then
    echo "Starting Claude Flow container..."
    if [ "$layout_choice" = "2" ]; then
        docker compose -f "$TARGET_DIR/docker/docker-compose.yml" up -d
    else
        docker compose -f "$TARGET_DIR/docker-compose.yml" up -d
    fi
    echo -e "${GREEN}✅ Container started!${NC}"
    echo ""
    echo "Run ${BLUE}./bin/shell${NC} to enter the container."
fi