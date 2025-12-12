#!/bin/bash
# create-pr.sh - Create a pull request with standard template
# Usage: ./atomic create-pr.sh "PR Title"
# Example: ./atomic create-pr.sh "[AUTH-001] Add login form"

set -e

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

if [ "$#" -ne 1 ]; then
    echo "Usage: ./.agent/scripts/create-pr.sh \"PR Title\""
    echo "Example: ./atomic create-pr.sh \"[AUTH-001] Add login form\""
    exit 1
fi

PR_TITLE=$1
CURRENT_BRANCH=$(get_current_branch)

# Check if there are uncommitted changes
if has_uncommitted_changes; then
    print_error "You have uncommitted changes. Please commit or stash them first."
    git status -s
    exit 1
fi

print_success "No uncommitted changes"

# Validate test immutability FIRST (before running other checks)
echo ""
echo "Validating test immutability..."
if ! ./.agent/scripts/validate-tests.sh; then
    echo ""
    print_error "Test validation failed. Cannot create PR."
    echo ""
    echo "Fix the violations and try again."
    exit 1
fi

# Run other checks
echo ""
echo "Running pre-PR checks..."
if ! ./.agent/scripts/run-checks.sh; then
    echo ""
    print_error "Checks failed. Please fix issues before creating PR."
    exit 1
fi

# Extract feature ID from branch name or PR title
FEATURE_ID=$(echo "$PR_TITLE" | grep -o '\[.*\]' | tr -d '[]' || echo "$CURRENT_BRANCH" | grep -o '^[^-]*' || echo "UNKNOWN")

# Get feature requirements
FEATURE_INFO=$(node -e "
const fs = require('fs');
const requirements = JSON.parse(fs.readFileSync('feature-requirements.json', 'utf8'));
const feature = requirements.features.find(f => f.id === '${FEATURE_ID}');
if (feature) {
  console.log('Feature: ' + feature.description);
  console.log('Category: ' + feature.category);
  console.log('Priority: ' + feature.priority);
} else {
  console.log('Feature not found in requirements');
}
" 2>/dev/null || echo "Could not load feature information")

# Create PR body
PR_BODY="## Summary
$FEATURE_INFO

## Changes
<!-- Describe the changes made in this PR -->

## Testing
<!-- Describe how this was tested -->
- [ ] All feature requirement steps verified
- [ ] Manual testing completed
- [ ] No regressions introduced

## Checklist
- [ ] Code follows project style guidelines
- [ ] Lint passes (\`npm run lint\`)
- [ ] Build passes (\`npm run build\`)
- [ ] Tests pass (if applicable)
- [ ] feature-requirements.json updated
- [ ] Documentation updated (if needed)

## Feature Status
Feature ID: ${FEATURE_ID}
Branch: ${CURRENT_BRANCH}
"

# Push branch if needed
echo "Pushing branch to remote..."
git push -u origin $CURRENT_BRANCH 2>/dev/null || git push origin $CURRENT_BRANCH

# Create PR (using gh CLI if available)
if command -v gh &> /dev/null; then
    echo "Creating pull request..."
    gh pr create --title "$PR_TITLE" --body "$PR_BODY"
    echo "✓ Pull request created successfully"
else
    echo ""
    echo "✓ Branch pushed to remote"
    echo ""
    echo "GitHub CLI (gh) not found. Please create PR manually with this information:"
    echo ""
    echo "Title: $PR_TITLE"
    echo ""
    echo "Body:"
    echo "$PR_BODY"
fi
