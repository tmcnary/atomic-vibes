#!/bin/bash
# run-checks.sh - Run all code quality checks
# Usage: ./atomic run-checks.sh

set -e

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

echo "========================================="
echo "Running Code Quality Checks"
echo "========================================="
echo ""

# Track overall status and individual check results
CHECKS_PASSED=true
LINT_STATUS="unknown"
BUILD_STATUS="unknown"
TEST_STATUS="unknown"

echo "0. Validating test immutability..."
if ./.agent/scripts/validate-tests.sh; then
    echo ""
else
    echo ""
    print_error "Test validation failed - aborting checks"
    exit 1
fi

echo "1. Linting..."
if npm run lint; then
    echo -e "${GREEN}✓ Linting passed${NC}"
    LINT_STATUS="passing"
else
    echo -e "${RED}✗ Linting failed${NC}"
    LINT_STATUS="failing"
    CHECKS_PASSED=false
fi
echo ""

echo "2. Type checking..."
if npx tsc --noEmit; then
    echo -e "${GREEN}✓ Type checking passed${NC}"
else
    echo -e "${RED}✗ Type checking failed${NC}"
    CHECKS_PASSED=false
fi
echo ""

echo "3. Building..."
if npm run build; then
    echo -e "${GREEN}✓ Build passed${NC}"
    BUILD_STATUS="passing"
else
    echo -e "${RED}✗ Build failed${NC}"
    BUILD_STATUS="failing"
    CHECKS_PASSED=false
fi
echo ""

echo "4. Testing..."
if npm test 2>/dev/null; then
    echo -e "${GREEN}✓ Tests passed${NC}"
    TEST_STATUS="passing"
elif npm test 2>&1 | grep -q "no test specified"; then
    echo -e "${YELLOW}⚠ No tests configured${NC}"
    TEST_STATUS="no-tests"
else
    echo -e "${YELLOW}⚠ Tests failed${NC}"
    TEST_STATUS="failing"
fi
echo ""

echo "========================================="
if [ "$CHECKS_PASSED" = true ]; then
    echo -e "${GREEN}All checks passed!${NC}"
else
    echo -e "${RED}Some checks failed. Please fix before committing.${NC}"
fi
echo ""

# Update state with check results (avoid duplicate execution)
echo "Updating project state with check results..."
./.agent/scripts/update-state.sh "$BUILD_STATUS" "$LINT_STATUS" "$TEST_STATUS"

echo ""
if [ "$CHECKS_PASSED" = true ]; then
    exit 0
else
    exit 1
fi
