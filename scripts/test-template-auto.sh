#!/usr/bin/env bash
# Automated test script for Claude Flow Docker template

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🧪 Testing Claude Flow Docker Template (Automated)"
echo ""

# Create test directory
TEST_DIR="test-project-auto-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "📁 Created test directory: $TEST_DIR"

# Create a minimal package.json
cat > package.json << EOF
{
  "name": "test-project",
  "version": "1.0.0",
  "scripts": {
    "dev": "echo 'Development server would start here'",
    "build": "echo 'Build would run here'"
  }
}
EOF

# Copy template files manually (simulating setup.sh)
echo "📋 Copying template files..."

# Copy Docker files (root layout)
cp ../docker/Dockerfile .
cp ../docker/docker-compose.yml .
cp ../docker/.dockerignore .

# Copy scripts
mkdir -p scripts
cp ../scripts/deno-shim-safe.js scripts/
cp ../scripts/claude-flow-launcher.sh scripts/

# Copy bin
cp -r ../bin .
chmod +x bin/*

# Copy env files
cp ../.envrc .
cp ../.env.example .env

# Add test API key
echo "ANTHROPIC_API_KEY=test_key_123" >> .env

echo ""
echo "✅ Files copied successfully"

# Verify files
echo ""
echo "📋 Verifying files..."

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅ $1 exists${NC}"
    else
        echo -e "${RED}❌ $1 missing${NC}"
        exit 1
    fi
}

check_file "Dockerfile"
check_file "docker-compose.yml"
check_file ".dockerignore"
check_file "scripts/deno-shim-safe.js"
check_file "scripts/claude-flow-launcher.sh"
check_file "bin/cf"
check_file "bin/shell"
check_file ".envrc"
check_file ".env"

# Check executable permissions
if [ -x "bin/cf" ]; then
    echo -e "${GREEN}✅ bin/cf is executable${NC}"
else
    echo -e "${RED}❌ bin/cf is not executable${NC}"
    exit 1
fi

# Check Docker syntax
if command -v docker &> /dev/null; then
    echo ""
    echo "🐳 Validating Docker configuration..."
    
    # Validate docker-compose.yml syntax
    if docker compose config > /dev/null 2>&1; then
        echo -e "${GREEN}✅ docker-compose.yml is valid${NC}"
    else
        echo -e "${RED}❌ docker-compose.yml has syntax errors${NC}"
        docker compose config
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  Docker not available, skipping validation${NC}"
fi

echo ""
echo -e "${GREEN}🎉 All tests passed!${NC}"
echo ""
echo "Cleaning up test directory..."
cd ..
rm -rf "$TEST_DIR"
echo "Done!"