#!/bin/bash
# llm-autofill.sh - Helper script to prepare files for LLM auto-fill
# This script identifies what needs to be filled in and provides instructions

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================="
echo -e "${BLUE}LLM Auto-Fill Helper${NC}"
echo "========================================="
echo ""

# Check if required files exist
MISSING_FILES=()
[ ! -f ".agent/memory/context.json" ] && MISSING_FILES+=("context.json")
[ ! -f ".agent/memory/domain.md" ] && MISSING_FILES+=("domain.md")

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "${RED}✗ Missing required files:${NC}"
    printf '%s\n' "${MISSING_FILES[@]}"
    echo ""
    echo "Run ./.agent/scripts/initialize.sh first to set up the template."
    exit 1
fi

# Count placeholders in context.json
PLACEHOLDER_COUNT=$(grep -o '\[.*\]' .agent/memory/context.json | wc -l | tr -d ' ')

echo -e "${BLUE}Analysis:${NC}"
echo ""
echo "Files to be filled:"
echo "  • .agent/memory/context.json ($PLACEHOLDER_COUNT placeholders)"
echo "  • .agent/memory/domain.md"
echo "  • feature-requirements.json"
echo ""

# Detect project info
echo -e "${BLUE}Detected Project Info:${NC}"
echo ""

if [ -f "package.json" ]; then
    PROJECT_NAME=$(node -p "require('./package.json').name" 2>/dev/null || echo "unknown")
    PROJECT_VERSION=$(node -p "require('./package.json').version" 2>/dev/null || echo "0.0.1")
    echo "  Name: $PROJECT_NAME"
    echo "  Version: $PROJECT_VERSION"
    echo "  Type: Node.js/JavaScript"
fi

if [ -d ".git" ]; then
    echo "  Git: Initialized"
    BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
    echo "  Branch: $BRANCH"
fi

echo ""
echo "========================================="
echo -e "${YELLOW}Instructions for LLM:${NC}"
echo "========================================="
echo ""

cat <<'EOF'
Please complete the following tasks to set up the atomic implementation system:

TASK 1: Fill in .agent/memory/context.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Read the following files to gather information:
  - package.json (or equivalent config files)
  - README.md (if exists)
  - Source code files to understand architecture
  - Configuration files (tsconfig.json, vite.config.ts, etc.)

Then replace ALL [PLACEHOLDER] values in .agent/memory/context.json with actual values:

1. Project section:
   - [PROJECT_NAME] from package.json
   - [PROJECT_DESCRIPTION] from README or by analyzing the code
   - [PROJECT_VERSION] from package.json
   - [INIT_DATE] as today's date

2. Tech stack section:
   - [FRONTEND_FRAMEWORK], [FRONTEND_VERSION] from package.json dependencies
   - [STYLING_FRAMEWORK], [STYLING_VERSION] from dependencies
   - [THEME_DESCRIPTION] by analyzing CSS/styling files
   - [HEADING_FONT], [BODY_FONT] from CSS/config files

3. Architecture section:
   - [ARCHITECTURE_TYPE] by analyzing project structure
   - [LAYER_*] by examining src/ directory organization

4. Design system section:
   - [PRIMARY_COLOR], [SECONDARY_COLOR] from theme/CSS files
   - [EFFECT_*] by analyzing components
   - [BRAND_VOICE] from README or marketing copy

5. Development decisions section:
   - [CURRENT_STATE_MANAGEMENT] by checking for Redux/Zustand/Context
   - [CURRENT_DATA_FETCHING] by checking for API calls
   - [CURRENT_TESTING] by checking test files and package.json scripts
   - [CURRENT_BACKEND] by analyzing the project

6. Code conventions section:
   - Fill based on observed patterns in the codebase

7. Quality standards section:
   - Check for .eslintrc, tsconfig.json settings
   - Verify what's in package.json scripts

TASK 2: Update .agent/memory/domain.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Replace the template content with actual domain knowledge:

1. Read the README.md and any documentation
2. Analyze the component names and page routes
3. Identify the core domain concepts (what is this app about?)
4. Describe:
   - What the application does
   - Who it's for
   - Key features and functionality
   - Tech stack specifics
   - Architecture patterns
   - Business rules
   - Technical constraints

TASK 3: Generate feature-requirements.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Analyze the codebase and create a comprehensive feature catalog:

1. For EXISTING features (already implemented):
   - Scan all pages/routes
   - Scan all major components
   - Create test steps for each feature
   - Set "passes": true for working features
   - Set "passes": false for features that might be broken

2. For MISSING features (TODO):
   - Check for TODO comments
   - Look for incomplete components
   - Identify stub implementations
   - Create features with "passes": false

3. Feature format:
   {
     "id": "CATEGORY-###",
     "category": "web-navigation|auth|api|mobile|etc",
     "priority": "critical|high|medium|low",
     "description": "Clear description",
     "steps": ["Step 1", "Step 2", ...],
     "passes": true/false
   }

4. Categories to check:
   - web-navigation (routes, pages)
   - auth (login, signup, password reset)
   - core-features (main functionality)
   - api (if backend exists)
   - ui-components (major reusable components)
   - mobile (responsive features)
   - accessibility (a11y features)
   - testing (test coverage)

TASK 4: Run validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
After filling in all files, run:
  ./.agent/scripts/boot-up.sh

This will validate:
  - All files are properly formatted
  - Build passes
  - Lint passes
  - Tests pass (if any)

TASK 5: Create initial state
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Run:
  ./.agent/scripts/update-state.sh

This updates .agent/state/current-state.json with actual build/lint/test status.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
IMPORTANT NOTES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Read files BEFORE editing - understand the codebase first
2. Keep the JSON structure intact in context.json
3. Replace ALL [PLACEHOLDER] values - don't leave any
4. Be thorough with feature-requirements.json - capture everything
5. Set realistic "passes" values - be honest about what works
6. Follow the examples in the placeholders for guidance
7. Maintain the atomic implementation principles

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

When complete, report:
  ✓ Number of placeholders filled in context.json
  ✓ Domain knowledge documented in domain.md
  ✓ Number of features cataloged in feature-requirements.json
  ✓ Boot-up script validation results
  ✓ Any blockers or issues discovered

EOF

echo ""
echo "========================================="
echo -e "${GREEN}Ready for LLM processing${NC}"
echo "========================================="
echo ""
echo "Copy the instructions above to your LLM or run in Claude Code."
echo ""
