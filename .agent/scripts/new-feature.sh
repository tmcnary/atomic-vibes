#!/bin/bash
# new-feature.sh - Create a new feature branch and set up tracking
# Usage: ./atomic new-feature.sh FEATURE-ID "description"
# Example: ./atomic new-feature.sh AUTH-001 "login-form"

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: ./.agent/scripts/new-feature.sh FEATURE-ID \"description\""
    echo "Example: ./atomic new-feature.sh AUTH-001 \"login-form\""
    exit 1
fi

FEATURE_ID=$1
DESCRIPTION=$2
BRANCH_NAME="feature/${FEATURE_ID}-${DESCRIPTION}"

echo "Creating new feature branch: $BRANCH_NAME"

# Ensure we're on main/develop and up to date
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
echo "Updating $MAIN_BRANCH..."
git checkout $MAIN_BRANCH 2>/dev/null || git checkout -b $MAIN_BRANCH
git pull origin $MAIN_BRANCH 2>/dev/null || echo "No remote configured yet"

# Create feature branch
git checkout -b $BRANCH_NAME

# Update current state
node -e "
const fs = require('fs');
const path = '.agent/state/current-state.json';
let state = {};
try {
  state = JSON.parse(fs.readFileSync(path, 'utf8'));
} catch(e) {
  state = {
    lastUpdated: new Date().toISOString(),
    currentBranch: '',
    focusFeature: null,
    blockers: [],
    buildStatus: 'unknown',
    lintStatus: 'unknown',
    testStatus: 'no-tests',
    nextActions: [],
    agentRuns: []
  };
}
state.lastUpdated = new Date().toISOString();
state.currentBranch = '${BRANCH_NAME}';
state.focusFeature = '${FEATURE_ID}';
state.nextActions = ['Implement feature ${FEATURE_ID}'];
fs.writeFileSync(path, JSON.stringify(state, null, 2));
console.log('Updated current-state.json');
"

echo ""
echo "✓ Feature branch created: $BRANCH_NAME"
echo "✓ Current state updated"
echo ""
echo "Next steps:"
echo "1. Review feature requirements in feature-requirements.json (${FEATURE_ID})"
echo "2. Implement the feature"
echo "3. Run ./.agent/scripts/run-checks.sh before committing"
echo "4. Commit changes with: git commit -m \"[${FEATURE_ID}] Your message\""
