#!/bin/bash
# Smart launcher for claude-flow that handles NODE_OPTIONS issue

# Check if running SPARC command
if [[ "$*" == *"sparc"* ]]; then
    echo "⚠️  Note: SPARC mode may have limited functionality without Deno runtime"
fi

# Temporarily unset NODE_OPTIONS to avoid output issues
NODE_OPTIONS="" exec npx claude-flow@alpha "$@"