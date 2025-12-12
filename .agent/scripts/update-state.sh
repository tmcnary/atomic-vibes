#!/bin/bash
# update-state.sh - Update .agent/state/current-state.json with current project state
# Usage: ./atomic update-state.sh [BUILD_STATUS] [LINT_STATUS] [TEST_STATUS]
#
# If status arguments are provided, they will be used directly (avoiding duplicate check execution).
# If not provided, checks will be run to determine status.

set -e

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo "Updating project state..."
echo ""

# Get current branch
CURRENT_BRANCH=$(get_current_branch)

# Get last commit
LAST_COMMIT=$(get_last_commit)

# Use provided status values or run checks
if [ "$#" -ge 3 ]; then
    # Status values provided as arguments (from run-checks.sh)
    BUILD_STATUS="$1"
    LINT_STATUS="$2"
    TEST_STATUS="$3"

    print_info "Using provided check results"
    echo "  Build: $BUILD_STATUS"
    echo "  Lint: $LINT_STATUS"
    echo "  Tests: $TEST_STATUS"
    echo ""
else
    # No arguments provided, run checks
    print_info "Running checks to determine status..."
    echo ""

    # Check build status
    BUILD_STATUS="unknown"
    echo "Checking build status..."
    TEMP_BUILD=$(mktemp)
    if npm run build > "$TEMP_BUILD" 2>&1; then
        BUILD_STATUS="passing"
        print_success "Build passed"
    else
        BUILD_STATUS="failing"
        print_error "Build failed"
        echo ""
        echo "Build errors:"
        cat "$TEMP_BUILD"
        echo ""
    fi
    rm -f "$TEMP_BUILD"

    # Check lint status
    LINT_STATUS="unknown"
    echo "Checking lint status..."
    TEMP_LINT=$(mktemp)
    if npm run lint > "$TEMP_LINT" 2>&1; then
        LINT_STATUS="passing"
        print_success "Lint passed"
    else
        LINT_STATUS="failing"
        print_error "Lint failed"
        echo ""
        echo "Lint errors:"
        cat "$TEMP_LINT"
        echo ""
    fi
    rm -f "$TEMP_LINT"

    # Check test status
    TEST_STATUS="no-tests"
    echo "Checking test status..."
    TEMP_TEST=$(mktemp)
    if npm test > "$TEMP_TEST" 2>&1; then
        TEST_STATUS="passing"
        print_success "Tests passed"
    elif grep -q "no test specified" "$TEMP_TEST"; then
        TEST_STATUS="no-tests"
        print_warning "No tests configured"
    else
        TEST_STATUS="failing"
        print_error "Tests failed"
        echo ""
        echo "Test errors:"
        cat "$TEMP_TEST"
        echo ""
    fi
    rm -f "$TEMP_TEST"
fi

# Update JSON file
node -e "
const fs = require('fs');
const path = '.agent/state/current-state.json';
let state = {};
try {
  state = JSON.parse(fs.readFileSync(path, 'utf8'));
} catch(e) {
  state = {
    focusFeature: null,
    blockers: [],
    nextActions: [],
    agentRuns: []
  };
}

state.lastUpdated = new Date().toISOString();
state.currentBranch = '${CURRENT_BRANCH}';
state.lastCommit = '${LAST_COMMIT}';
state.buildStatus = '${BUILD_STATUS}';
state.lintStatus = '${LINT_STATUS}';
state.testStatus = '${TEST_STATUS}';

fs.writeFileSync(path, JSON.stringify(state, null, 2));
console.log('State updated successfully');
"

echo ""
print_success "Project state updated"
echo "  Branch: $CURRENT_BRANCH"
echo "  Build: $BUILD_STATUS"
echo "  Lint: $LINT_STATUS"
echo "  Tests: $TEST_STATUS"
