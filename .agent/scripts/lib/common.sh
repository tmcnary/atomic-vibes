#!/bin/bash
# common.sh - Shared utilities for all scripts
# Source this file: source scripts/lib/common.sh

# Colors (used across multiple scripts)
export BLUE='\033[0;34m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color

# Print colored message
print_status() {
    local color=$1
    local symbol=$2
    local message=$3
    echo -e "${color}${symbol} ${message}${NC}"
}

print_error() {
    print_status "$RED" "✗" "$1"
}

print_success() {
    print_status "$GREEN" "✓" "$1"
}

print_warning() {
    print_status "$YELLOW" "⚠" "$1"
}

print_info() {
    print_status "$BLUE" "ℹ" "$1"
}

# Run a check and capture output, show only on failure
run_check() {
    local check_name=$1
    local check_cmd=$2
    local show_output=${3:-false}  # Optional: show output even on success
    local temp_output=$(mktemp)

    if eval "$check_cmd" > "$temp_output" 2>&1; then
        print_success "$check_name passed"
        if [ "$show_output" = "true" ]; then
            cat "$temp_output"
        fi
        rm "$temp_output"
        return 0
    else
        print_error "$check_name failed"
        echo ""
        cat "$temp_output"
        echo ""
        rm "$temp_output"
        return 1
    fi
}

# Get current git branch
get_current_branch() {
    git branch --show-current 2>/dev/null || echo "unknown"
}

# Get last commit hash
get_last_commit() {
    git rev-parse --short HEAD 2>/dev/null || echo "none"
}

# Check if file exists
require_file() {
    local file=$1
    local description=$2

    if [ ! -f "$file" ]; then
        print_error "$description not found: $file"
        return 1
    fi
    return 0
}

# Update a single field in current-state.json
update_state_field() {
    local field=$1
    local value=$2

    require_file ".agent/state/current-state.json" "State file" || return 1

    node -e "
    const fs = require('fs');
    let state = {};
    try {
        state = JSON.parse(fs.readFileSync('.agent/state/current-state.json', 'utf8'));
    } catch(e) {
        console.error('Error reading state file:', e.message);
        process.exit(1);
    }
    state['$field'] = '$value';
    state.lastUpdated = new Date().toISOString();
    try {
        fs.writeFileSync('.agent/state/current-state.json', JSON.stringify(state, null, 2));
    } catch(e) {
        console.error('Error writing state file:', e.message);
        process.exit(1);
    }
    " 2>/dev/null
}

# Update multiple fields in current-state.json
update_state_fields() {
    require_file ".agent/state/current-state.json" "State file" || return 1

    local updates=""
    for pair in "$@"; do
        local field="${pair%%:*}"
        local value="${pair#*:}"
        updates="${updates}state['$field'] = '$value'; "
    done

    node -e "
    const fs = require('fs');
    let state = {};
    try {
        state = JSON.parse(fs.readFileSync('.agent/state/current-state.json', 'utf8'));
    } catch(e) {
        console.error('Error reading state file:', e.message);
        process.exit(1);
    }
    $updates
    state.lastUpdated = new Date().toISOString();
    try {
        fs.writeFileSync('.agent/state/current-state.json', JSON.stringify(state, null, 2));
    } catch(e) {
        console.error('Error writing state file:', e.message);
        process.exit(1);
    }
    " 2>/dev/null
}

# Get a field from current-state.json
get_state_field() {
    local field=$1

    require_file ".agent/state/current-state.json" "State file" || return 1

    node -e "
    const fs = require('fs');
    try {
        const state = JSON.parse(fs.readFileSync('.agent/state/current-state.json', 'utf8'));
        console.log(state['$field'] || '');
    } catch(e) {
        console.error('Error reading state:', e.message);
        process.exit(1);
    }
    " 2>/dev/null
}

# Validate JSON file syntax
validate_json() {
    local file=$1

    if ! node -e "JSON.parse(require('fs').readFileSync('$file', 'utf8'))" 2>/dev/null; then
        print_error "Invalid JSON in $file"
        return 1
    fi
    return 0
}

# Check if we're in a git repository
is_git_repo() {
    git rev-parse --git-dir > /dev/null 2>&1
}

# Check if there are uncommitted changes
has_uncommitted_changes() {
    if ! is_git_repo; then
        return 1
    fi
    [ -n "$(git status -s)" ]
}

# Get count of uncommitted files
uncommitted_count() {
    if ! is_git_repo; then
        echo "0"
        return
    fi
    git status -s | wc -l | tr -d ' '
}

# Export functions for use in other scripts
export -f print_status
export -f print_error
export -f print_success
export -f print_warning
export -f print_info
export -f run_check
export -f get_current_branch
export -f get_last_commit
export -f require_file
export -f update_state_field
export -f update_state_fields
export -f get_state_field
export -f validate_json
export -f is_git_repo
export -f has_uncommitted_changes
export -f uncommitted_count
