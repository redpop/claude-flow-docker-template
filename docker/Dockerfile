FROM node:22-slim

# Metadata
LABEL maintainer="your-email@example.com"
LABEL description="Claude Flow development environment with Deno support"
LABEL version="1.0.0"

# Build arguments for customization
ARG NODE_VERSION=22
ARG PACKAGE_MANAGER=pnpm
ARG CLAUDE_FLOW_VERSION=alpha
ARG EXTRA_PACKAGES=""

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-distutils \
    ca-certificates \
    unzip \
    ${EXTRA_PACKAGES} \
    && rm -rf /var/lib/apt/lists/*

# Install Deno (required for Claude Flow SPARC mode)
RUN curl -fsSL https://deno.land/install.sh | sh

# Set environment for Deno
ENV DENO_INSTALL=/root/.deno
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

# Install package manager based on argument
RUN if [ "$PACKAGE_MANAGER" = "pnpm" ]; then \
        npm install -g pnpm@latest; \
    elif [ "$PACKAGE_MANAGER" = "yarn" ]; then \
        npm install -g yarn@latest; \
    fi

# Set working directory
WORKDIR /app

# Copy Deno shim file and launcher scripts
COPY scripts/deno-shim-safe.js /usr/local/lib/deno-shim.js
COPY scripts/claude-flow-launcher.sh /usr/local/bin/claude-flow
RUN chmod +x /usr/local/bin/claude-flow

# Configure Node to load the Deno shim (can be disabled via NODE_OPTIONS="")
ENV NODE_OPTIONS="--require=/usr/local/lib/deno-shim.js"

# Pre-cache claude-flow to avoid timeout during first run
RUN npx claude-flow@${CLAUDE_FLOW_VERSION} --version || true

# Create non-root user for better security
ARG USER_UID=1001
ARG USER_GID=1001
RUN groupadd -g ${USER_GID} appuser && \
    useradd -m -u ${USER_UID} -g appuser -s /bin/bash appuser && \
    chown -R appuser:appuser /app

# Create aliases for easier claude-flow usage
RUN echo '#!/bin/bash' > /etc/profile.d/claude-flow.sh && \
    echo 'alias cf="claude-flow"' >> /etc/profile.d/claude-flow.sh && \
    echo 'alias claude-flow-direct="NODE_OPTIONS=\"\" npx claude-flow@'${CLAUDE_FLOW_VERSION}'"' >> /etc/profile.d/claude-flow.sh && \
    chmod +x /etc/profile.d/claude-flow.sh

# Add to both root and user bashrc
RUN cp /etc/profile.d/claude-flow.sh /root/.bashrc_claude && \
    cp /etc/profile.d/claude-flow.sh /home/appuser/.bashrc_claude && \
    echo 'source ~/.bashrc_claude' >> /root/.bashrc && \
    echo 'source ~/.bashrc_claude' >> /home/appuser/.bashrc && \
    chown appuser:appuser /home/appuser/.bashrc_claude

# Expose common development ports
EXPOSE 3000 3001 4173 5173 8080

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "console.log('OK')" || exit 1

# Display welcome message
RUN echo '#!/bin/bash' > /usr/local/bin/welcome && \
    echo 'echo "🌊 Claude Flow Docker Environment"' >> /usr/local/bin/welcome && \
    echo 'echo ""' >> /usr/local/bin/welcome && \
    echo 'echo "Available commands:"' >> /usr/local/bin/welcome && \
    echo 'echo "  claude-flow       - Run with Deno shim (for SPARC mode)"' >> /usr/local/bin/welcome && \
    echo 'echo "  cf                - Alias for claude-flow"' >> /usr/local/bin/welcome && \
    echo 'echo "  claude-flow-direct - Run without shim"' >> /usr/local/bin/welcome && \
    echo 'echo ""' >> /usr/local/bin/welcome && \
    echo 'echo "Node version: $(node --version)"' >> /usr/local/bin/welcome && \
    echo 'echo "Deno version: $(deno --version | head -1)"' >> /usr/local/bin/welcome && \
    echo 'echo ""' >> /usr/local/bin/welcome && \
    chmod +x /usr/local/bin/welcome

# Default command shows welcome and starts bash
CMD ["/bin/bash", "-c", "welcome && exec bash"]