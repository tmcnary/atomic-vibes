#!/bin/bash
# install-hooks.sh - Install git hooks for test immutability validation
# Usage: ./atomic install-hooks.sh

set -e

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo ""
echo "🔧 Installing Git Hooks"
echo "======================="
echo ""

# Check if we're in a git repository
if ! is_git_repo; then
    print_warning "Not a git repository"
    print_info "Git hooks will be installed when you run 'git init'"
    exit 0
fi

# Make sure .githooks directory exists
if [ ! -d ".githooks" ]; then
    print_error ".githooks directory not found"
    exit 1
fi

# Make hooks executable
chmod +x .githooks/*

# Configure git to use .githooks directory
git config core.hooksPath .githooks

print_success "Git hooks installed"
echo ""
echo "Hooks configured:"
echo "  • pre-commit: Validates test immutability"
echo ""
echo "The pre-commit hook will:"
echo "  ✓ Check feature-requirements.json for test modifications"
echo "  ✓ Allow only 'passes' field changes"
echo "  ✓ Block commits that modify test steps/descriptions"
echo ""
echo "To bypass the hook (NOT RECOMMENDED):"
echo "  git commit --no-verify"
echo ""
