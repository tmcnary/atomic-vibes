#!/bin/bash
# initialize.sh - Install Atomic Vibes into any project
# An atomic vibe-coding harness for AI agents
# Usage:
#   Local: ./.agent/scripts/initialize.sh
#   Remote: curl -fsSL https://raw.githubusercontent.com/tmcnary/atomic-vibes/main/scripts/initialize.sh | bash

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo "========================================="
echo -e "${BLUE}⚛️  Atomic Vibes${NC}"
echo -e "${BLUE}An atomic vibe-coding harness for AI agents${NC}"
echo "========================================="
echo ""

# Determine if we're running locally or from remote
if [ -d ".agent" ]; then
    echo -e "${YELLOW}⚠ .agent/ directory already exists${NC}"
    echo "This project appears to already have Atomic Vibes installed."
    echo ""
    read -p "Do you want to re-initialize? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Initialization cancelled."
        exit 0
    fi
    REINIT=true
else
    REINIT=false
fi

# Check if this is being run from the template repo or remotely
TEMPLATE_DIR=""
if [ -f "scripts/initialize.sh" ] && [ -f ".agent/protocols/AGENT_README.md" ]; then
    # Running locally from template
    TEMPLATE_DIR="."
    echo -e "${GREEN}✓ Running from template directory${NC}"
else
    # Need to download template
    echo -e "${BLUE}Downloading atomic implementation template...${NC}"
    TEMP_DIR=$(mktemp -d)
    TEMPLATE_DIR="$TEMP_DIR/atomic-implementation"

    # Clone the template (replace with your actual repo URL)
    REPO_URL="${ATOMIC_TEMPLATE_REPO:-https://github.com/tmcnary/atomic-vibes.git}"

    if command -v git &> /dev/null; then
        git clone --depth 1 "$REPO_URL" "$TEMPLATE_DIR" 2>/dev/null || {
            echo -e "${RED}✗ Failed to clone template repository${NC}"
            echo "Please check the repository URL or download manually."
            exit 1
        }
    else
        echo -e "${RED}✗ Git not found. Please install git or download template manually.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Template downloaded${NC}"
fi

echo ""
echo -e "${BLUE}Step 1: Project Detection${NC}"
echo "Analyzing current project..."
echo ""

# Detect project type
PROJECT_TYPE="unknown"
if [ -f "package.json" ]; then
    PROJECT_TYPE="node"
    echo -e "${GREEN}✓ Node.js project detected${NC}"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="python"
    echo -e "${GREEN}✓ Python project detected${NC}"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
    echo -e "${GREEN}✓ Rust project detected${NC}"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
    echo -e "${GREEN}✓ Go project detected${NC}"
else
    echo -e "${YELLOW}⚠ Unknown project type${NC}"
fi

# Check if git repo
if [ -d ".git" ]; then
    echo -e "${GREEN}✓ Git repository detected${NC}"
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
else
    echo -e "${YELLOW}⚠ Not a git repository${NC}"
    CURRENT_BRANCH="main"
fi

echo ""
echo -e "${BLUE}Step 2: Installing Template Structure${NC}"
echo ""

# Create .agent directory structure
mkdir -p .agent/protocols
mkdir -p .agent/memory
mkdir -p .agent/state
mkdir -p .agent/logs

echo -e "${GREEN}✓ Created .agent/ directory structure${NC}"

# Copy protocol files
if [ -f "$TEMPLATE_DIR/.agent/protocols/agent-protocol.md" ]; then
    cp "$TEMPLATE_DIR/.agent/protocols/agent-protocol.md" .agent/protocols/
    echo -e "${GREEN}✓ Copied agent-protocol.md${NC}"
fi

if [ -f "$TEMPLATE_DIR/.agent/protocols/pr-template.md" ]; then
    cp "$TEMPLATE_DIR/.agent/protocols/pr-template.md" .agent/protocols/
    echo -e "${GREEN}✓ Copied pr-template.md${NC}"
fi

# Copy domain template
if [ -f "$TEMPLATE_DIR/.agent/memory/domain.md" ]; then
    cp "$TEMPLATE_DIR/.agent/memory/domain.md" .agent/memory/
    echo -e "${GREEN}✓ Copied domain.md template${NC}"
fi

# Copy context template (with placeholders)
if [ -f "$TEMPLATE_DIR/.agent/memory/context.json" ]; then
    cp "$TEMPLATE_DIR/.agent/memory/context.json" .agent/memory/
    echo -e "${GREEN}✓ Copied context.json template${NC}"
fi

# Create scripts directory structure
mkdir -p scripts/lib

# Copy core scripts
if [ -d "$TEMPLATE_DIR/scripts" ]; then
    for script in boot-up.sh run-checks.sh new-feature.sh update-state.sh create-pr.sh validate-tests.sh install-hooks.sh; do
        if [ -f "$TEMPLATE_DIR/scripts/$script" ]; then
            cp "$TEMPLATE_DIR/scripts/$script" scripts/
            chmod +x "scripts/$script"
            echo -e "${GREEN}✓ Copied scripts/$script${NC}"
        fi
    done

    # Copy lib directory
    if [ -d "$TEMPLATE_DIR/scripts/lib" ]; then
        cp -r "$TEMPLATE_DIR/scripts/lib/"* scripts/lib/ 2>/dev/null || true
        chmod +x scripts/lib/*.sh 2>/dev/null || true
        echo -e "${GREEN}✓ Copied scripts/lib/ utilities${NC}"
    fi
fi

# Copy git hooks
if [ -d "$TEMPLATE_DIR/.githooks" ]; then
    mkdir -p .githooks
    cp -r "$TEMPLATE_DIR/.githooks/"* .githooks/ 2>/dev/null || true
    chmod +x .githooks/* 2>/dev/null || true
    echo -e "${GREEN}✓ Copied .githooks/ templates${NC}"
fi

# Protocol files are already part of .agent/protocols/
# No need to copy them separately - they come with the .agent directory structure

# Create initial current-state.json
cat > .agent/state/current-state.json <<EOF
{
  "lastUpdated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "currentBranch": "$CURRENT_BRANCH",
  "focusFeature": null,
  "blockers": [],
  "lastCommit": "$(git rev-parse HEAD 2>/dev/null || echo 'none')",
  "buildStatus": "unknown",
  "lintStatus": "unknown",
  "testStatus": "unknown",
  "nextActions": [
    "Run './atomic boot-up' to validate environment",
    "Review and fill in .agent/memory/context.json placeholders",
    "Create or update feature-requirements.json",
    "Start working on first feature"
  ],
  "agentRuns": [
    {
      "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
      "agent": "initialize.sh",
      "action": "Initial setup of Atomic Vibes",
      "outcome": "success"
    }
  ]
}
EOF

echo -e "${GREEN}✓ Created initial current-state.json${NC}"

# Create sample feature-requirements.json if it doesn't exist
if [ ! -f "feature-requirements.json" ]; then
    cat > feature-requirements.json <<EOF
{
  "metadata": {
    "version": "1.0.0",
    "lastUpdated": "$(date -u +"%Y-%m-%d")",
    "project": "$(basename $(pwd))",
    "description": "Feature requirements catalog - update this file with your actual features"
  },
  "features": [
    {
      "id": "SETUP-001",
      "category": "infrastructure",
      "priority": "high",
      "description": "Project initialization and setup",
      "steps": [
        "Atomic implementation system installed",
        "All scripts are executable",
        "Boot-up script runs successfully",
        "Quality checks pass (lint, build, test)"
      ],
      "passes": false
    }
  ]
}
EOF
    echo -e "${GREEN}✓ Created initial feature-requirements.json${NC}"
else
    echo -e "${YELLOW}⚠ feature-requirements.json already exists, skipping${NC}"
fi

# Update .gitignore if it exists
if [ -f ".gitignore" ]; then
    if ! grep -q ".agent/logs/" .gitignore 2>/dev/null; then
        echo "" >> .gitignore
        echo "# Atomic Implementation System" >> .gitignore
        echo ".agent/logs/*.json" >> .gitignore
        echo -e "${GREEN}✓ Updated .gitignore${NC}"
    fi
else
    cat > .gitignore <<EOF
# Atomic Implementation System
.agent/logs/*.json

# OS
.DS_Store

# Editor
.vscode/
.idea/
EOF
    echo -e "${GREEN}✓ Created .gitignore${NC}"
fi

echo ""
echo -e "${BLUE}Step 3: Installing Git Hooks${NC}"
echo ""

# Install git hooks if this is a git repository
if [ -d ".git" ]; then
    if ./atomic install-hooks 2>/dev/null; then
        echo -e "${GREEN}✓ Git hooks installed${NC}"
    else
        echo -e "${YELLOW}⚠ Could not install git hooks (run ./atomic install-hooks manually)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Not a git repository - git hooks will be installed after 'git init'${NC}"
    echo "  Run ./atomic install-hooks after initializing git"
fi

echo ""
echo -e "${BLUE}Step 4: Next Steps${NC}"
echo ""
echo "The Atomic Vibes has been installed!"
echo ""
echo "To complete setup, you need to:"
echo ""
echo "1. ${YELLOW}Fill in project-specific details:${NC}"
echo "   - Edit .agent/memory/context.json (replace all [PLACEHOLDER] values)"
echo "   - Edit .agent/memory/domain.md (describe your project domain)"
echo "   - Update feature-requirements.json (add your actual features)"
echo ""
echo "2. ${YELLOW}Or use an LLM to auto-fill (recommended):${NC}"
echo "   Run this in Claude Code or similar:"
echo ""
echo -e "   ${GREEN}I need you to analyze this codebase and fill in the atomic"
echo "   implementation system. Please:"
echo "   1. Read .agent/memory/context.json and replace all [PLACEHOLDER]"
echo "      values with actual project details from package.json and the codebase"
echo "   2. Read .agent/memory/domain.md and fill it with actual domain knowledge"
echo "      by analyzing the code"
echo "   3. Generate a comprehensive feature-requirements.json by analyzing"
echo "      what features exist and what still needs to be built"
echo -e "   4. Run ./atomic boot-up to validate everything${NC}"
echo ""
echo "3. ${YELLOW}Run the boot-up script:${NC}"
echo "   ./atomic boot-up"
echo ""
echo "4. ${YELLOW}Read the documentation:${NC}"
echo "   - .agent/protocols/CLAUDE.md - Quick reference for Claude Code"
echo "   - .agent/protocols/AGENT_README.md - Complete agent guide"
echo "   - .agent/docs/ - Additional system documentation"
echo ""

# Cleanup temp directory if we downloaded
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo "========================================="
echo -e "${GREEN}Installation Complete!${NC}"
echo "========================================="
echo ""
echo "🔒 Test Immutability Protection:"
echo "   - Pre-commit hook installed (validates feature-requirements.json)"
echo "   - Only 'passes' field can be modified"
echo "   - Test steps are immutable"
echo ""
