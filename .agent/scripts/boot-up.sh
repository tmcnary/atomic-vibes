#!/bin/bash
# boot-up.sh - Atomic Vibes boot-up ritual
# Re-grounds agents in protocols and validates environment
# Usage: ./atomic boot-up

set -e

echo "========================================="
echo "⚛️  Atomic Vibes - Boot-up Ritual"
echo "========================================="
echo ""

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}1. RE-GROUND: Reading Core Protocols${NC}"
echo "   - agent-protocol.md"
echo "   - domain.md"
echo "   - feature-requirements.json"
echo "   - current-state.json"
echo ""

echo -e "${BLUE}2. READ MEMORY: Loading Context${NC}"
if [ -f ".agent/memory/context.json" ]; then
    echo -e "${GREEN}   ✓ context.json found${NC}"
else
    echo -e "${YELLOW}   ⚠ context.json not found${NC}"
fi
if [ -f ".agent/memory/patterns.md" ]; then
    echo -e "${GREEN}   ✓ patterns.md found${NC}"
else
    echo -e "${YELLOW}   ⚠ patterns.md not found (will be created as patterns emerge)${NC}"
fi
echo ""

echo -e "${BLUE}3. RUN BASIC CHECKS: Validating Environment${NC}"
echo ""

# Git status
echo "Git Status:"
git status -sb 2>/dev/null || echo "Not a git repository - needs initialization"
echo ""

# Dependencies
echo "Dependencies:"
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓ node_modules present${NC}"
else
    echo -e "${YELLOW}⚠ node_modules missing - run: npm install${NC}"
fi
echo ""

# Lint check
echo "Lint Check:"
if npm run lint &>/dev/null; then
    echo -e "${GREEN}✓ Linting passes${NC}"
else
    echo -e "${YELLOW}⚠ Linting issues detected${NC}"
fi
echo ""

# Build check
echo "Build Check:"
if npm run build &>/dev/null; then
    echo -e "${GREEN}✓ Build passes${NC}"
else
    echo -e "${YELLOW}⚠ Build has errors${NC}"
fi
echo ""

echo -e "${BLUE}4. TIE-IN TEST RESULTS${NC}"
if npm test &>/dev/null; then
    echo -e "${GREEN}✓ Tests passing${NC}"
elif npm test 2>&1 | grep -q "no test specified"; then
    echo -e "${YELLOW}⚠ No tests configured yet${NC}"
else
    echo -e "${YELLOW}⚠ Tests failing${NC}"
fi
echo ""

echo -e "${BLUE}5. REVIEW GIT HISTORY${NC}"
if git log --oneline -5 &>/dev/null; then
    echo "Recent commits:"
    git log --oneline -5 2>/dev/null
else
    echo "No git history yet"
fi
echo ""

echo -e "${BLUE}6. CURRENT STATE${NC}"
if [ -f ".agent/state/current-state.json" ]; then
    node -e "
    const fs = require('fs');
    const state = JSON.parse(fs.readFileSync('.agent/state/current-state.json', 'utf8'));
    console.log('Branch:', state.currentBranch || 'unknown');
    console.log('Focus Feature:', state.focusFeature || 'none');
    console.log('Build Status:', state.buildStatus || 'unknown');
    console.log('Lint Status:', state.lintStatus || 'unknown');
    if (state.blockers && state.blockers.length > 0) {
      console.log('Blockers:', state.blockers.length);
    }
    if (state.nextActions && state.nextActions.length > 0) {
      console.log('Next Actions:');
      state.nextActions.forEach((action, i) => console.log('  ' + (i+1) + '.', action));
    }
    "
else
    echo "No current state file - will be created"
fi
echo ""

echo "========================================="
echo -e "${GREEN}Boot-up Complete${NC}"
echo "========================================="
echo ""
echo "You are now ready to work. Remember:"
echo "- Work on ONE feature at a time"
echo "- Follow the protocols in .agent/protocols/"
echo "- Update state after each significant action"
echo "- End with clean test-passing state"
echo ""
