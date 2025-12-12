#!/bin/bash
# validate-tests.sh - Ensure feature-requirements.json tests haven't been modified
# Usage: ./atomic validate-tests.sh
#
# This enforces the atomic implementation principle:
#   "NEVER CHANGE TESTS - only implementation"
#
# Only the "passes" field should change in feature-requirements.json
# All other modifications (steps, description, etc.) are violations

set -e

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo ""
echo "🔍 Validating Test Immutability"
echo "================================"
echo ""

# Check if feature-requirements.json exists
if [ ! -f "feature-requirements.json" ]; then
    print_warning "feature-requirements.json not found - skipping validation"
    exit 0
fi

# Validate JSON syntax first
if ! validate_json "feature-requirements.json"; then
    print_error "feature-requirements.json has invalid JSON syntax"
    exit 1
fi

print_success "JSON syntax valid"

# If not a git repo, can't validate against history
if ! is_git_repo; then
    print_warning "Not a git repository - cannot validate against history"
    print_info "Test immutability will be enforced once git is initialized"
    exit 0
fi

# Check if file is tracked by git
if ! git ls-files --error-unmatch feature-requirements.json &>/dev/null; then
    print_warning "feature-requirements.json not yet tracked by git"
    print_info "Test immutability will be enforced after first commit"
    exit 0
fi

# Get the diff for feature-requirements.json
DIFF_OUTPUT=$(git diff HEAD feature-requirements.json 2>/dev/null || echo "")

# If no changes, we're good
if [ -z "$DIFF_OUTPUT" ]; then
    print_success "No changes to feature-requirements.json"
    exit 0
fi

# Check for staged changes too
STAGED_DIFF=$(git diff --staged feature-requirements.json 2>/dev/null || echo "")
if [ -n "$STAGED_DIFF" ]; then
    DIFF_OUTPUT="$DIFF_OUTPUT
$STAGED_DIFF"
fi

# Analyze the diff for violations
# We look for added (+) or removed (-) lines that contain test-related fields
# EXCEPT for the "passes" field which is allowed to change

VIOLATIONS=""

# Function to check if a line is a violation
check_line_for_violation() {
    local line="$1"

    # Skip if it's just the "passes" field
    if echo "$line" | grep -q '"passes"'; then
        return 0
    fi

    # Check for modifications to protected fields
    if echo "$line" | grep -qE '"(steps|description|category|priority|id)"'; then
        return 1
    fi

    # Check for modifications within the steps array
    if echo "$line" | grep -qE '^\+.*".*".*,' && echo "$DIFF_OUTPUT" | grep -B5 "$line" | grep -q '"steps"'; then
        return 1
    fi

    return 0
}

# Parse diff for violations
while IFS= read -r line; do
    # Only check added or removed lines (not context)
    if [[ $line =~ ^[+-] ]] && [[ ! $line =~ ^[\+\-]{3} ]]; then
        if ! check_line_for_violation "$line"; then
            VIOLATIONS="${VIOLATIONS}${line}\n"
        fi
    fi
done <<< "$DIFF_OUTPUT"

# If violations found, show detailed error
if [ -n "$VIOLATIONS" ]; then
    echo ""
    print_error "TEST MODIFICATION DETECTED"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "You have modified test definitions in feature-requirements.json"
    echo ""
    echo "This violates the atomic implementation principle:"
    echo "  ${RED}\"NEVER CHANGE TESTS - only implementation\"${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Detected violations:"
    echo ""
    echo -e "$VIOLATIONS" | head -20
    echo ""
    if [ $(echo -e "$VIOLATIONS" | wc -l) -gt 20 ]; then
        echo "... and more (showing first 20 lines)"
        echo ""
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "What you CAN do:"
    echo "  ${GREEN}✓${NC} Change ${GREEN}\"passes\": false${NC} to ${GREEN}\"passes\": true${NC}"
    echo "  ${GREEN}✓${NC} Add NEW features with new IDs"
    echo ""
    echo "What you CANNOT do:"
    echo "  ${RED}✗${NC} Modify test ${RED}steps${NC}"
    echo "  ${RED}✗${NC} Change test ${RED}descriptions${NC}"
    echo "  ${RED}✗${NC} Remove test ${RED}criteria${NC}"
    echo "  ${RED}✗${NC} Edit ${RED}categories${NC} or ${RED}priorities${NC}"
    echo "  ${RED}✗${NC} Change feature ${RED}IDs${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "If the test requirements are genuinely WRONG:"
    echo ""
    echo "  1. Document the issue in .agent/state/current-state.json:"
    echo ""
    echo "     ${YELLOW}\"blockers\": [{${NC}"
    echo "       ${YELLOW}\"description\": \"Test requirements incorrect for FEATURE-ID\",${NC}"
    echo "       ${YELLOW}\"reason\": \"Explain why the test is wrong\",${NC}"
    echo "       ${YELLOW}\"needsHuman\": true${NC}"
    echo "     ${YELLOW}]${NC}"
    echo ""
    echo "  2. Flag for human review"
    echo "  3. Do NOT modify the test yourself"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    exit 1
fi

# Passed validation
print_success "Test immutability validated"
echo "  All changes are to 'passes' field only"
echo ""

exit 0
