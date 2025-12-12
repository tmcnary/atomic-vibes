#!/bin/bash
# run-log.sh - Create agent run log
# Usage: ./atomic run-log.sh "Summary of what was done"

set -e

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

if [ "$#" -lt 1 ]; then
    echo "Usage: ./.agent/scripts/run-log.sh \"Summary of work completed\""
    echo "Example: ./atomic run-log.sh \"Completed SUPABASE-003 profiles table\""
    exit 1
fi

SUMMARY="$1"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
FILENAME=".agent/logs/$(date -u +"%Y%m%d-%H%M%S").json"

# Ensure logs directory exists
mkdir -p .agent/logs

echo "Creating run log..."
echo ""

# Get current branch and commit
CURRENT_BRANCH=$(get_current_branch)
LAST_COMMIT=$(git log -1 --format="%H" 2>/dev/null || echo "unknown")
LAST_COMMIT_MSG=$(git log -1 --format="%s" 2>/dev/null || echo "unknown")

# Get test status
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

# Get build status
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

# Get lint status
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

# Get commit count
COMMIT_COUNT=$(git log --oneline --since="24 hours ago" | wc -l | tr -d ' ')

# Get files changed
FILES_CHANGED=$(git diff --name-only HEAD~${COMMIT_COUNT}..HEAD 2>/dev/null | wc -l | tr -d ' ')

# Create run log
cat > "$FILENAME" << EOF
{
  "timestamp": "$TIMESTAMP",
  "agent": "coding-agent",
  "summary": "$SUMMARY",
  "branch": "$CURRENT_BRANCH",
  "lastCommit": {
    "hash": "$LAST_COMMIT",
    "message": "$LAST_COMMIT_MSG"
  },
  "status": {
    "build": "$BUILD_STATUS",
    "lint": "$LINT_STATUS",
    "tests": "$TEST_STATUS"
  },
  "metrics": {
    "commitsToday": $COMMIT_COUNT,
    "filesChanged": $FILES_CHANGED
  },
  "actions": [],
  "decisions": [],
  "blockers": [],
  "nextSteps": []
}
EOF

# Update latest.json symlink
rm -f .agent/logs/latest.json
cp "$FILENAME" .agent/logs/latest.json

echo ""
print_success "Run log created: $FILENAME"
print_success "Latest log updated: .agent/logs/latest.json"
echo ""
print_info "To add more details, edit the file and populate:"
echo "  - actions: What was done"
echo "  - decisions: Why certain choices were made"
echo "  - blockers: What's preventing progress"
echo "  - nextSteps: What should happen next"
