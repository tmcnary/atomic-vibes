#!/bin/bash
# compliance.sh - Interactive workflow guide for agents
# Usage: ./atomic compliance.sh

set -e

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║              🤖 AGENT WORKFLOW HELPER 🤖                         ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Check current state
CURRENT_BRANCH=$(git branch --show-current)
UNCOMMITTED=$(git status -s | wc -l | tr -d ' ')

echo "📊 Current Status:"
echo "  Branch: $CURRENT_BRANCH"
echo "  Uncommitted changes: $UNCOMMITTED"
echo ""

# Main menu
echo "What would you like to do?"
echo ""
echo "1) Start new feature"
echo "2) Continue working on current feature"
echo "3) Complete feature and create PR"
echo "4) Run checks (lint, build, test)"
echo "5) Update project state"
echo "6) Create run log"
echo "7) View feature requirements"
echo "8) Check protocol compliance"
echo "9) Exit"
echo ""
read -p "Select option (1-9): " choice

case $choice in
    1)
        echo ""
        echo "🆕 Starting New Feature"
        echo "─────────────────────────"
        read -p "Enter FEATURE-ID (e.g., SUPABASE-004): " feature_id
        read -p "Enter short description (e.g., routes-table): " description
        
        if [ -n "$feature_id" ] && [ -n "$description" ]; then
            ./.agent/scripts/new-feature.sh "$feature_id" "$description"
        else
            echo "❌ Error: Feature ID and description are required"
            exit 1
        fi
        ;;
    2)
        echo ""
        echo "💻 Continuing Work"
        echo "─────────────────────"
        echo "Current branch: $CURRENT_BRANCH"
        echo ""
        echo "Tips:"
        echo "  - Make atomic commits (git commit -m \"[ID] message\")"
        echo "  - Run ./.agent/scripts/run-checks.sh before committing"
        echo "  - Update feature-requirements.json when steps complete"
        ;;
    3)
        echo ""
        echo "✅ Completing Feature"
        echo "─────────────────────"
        
        if [ "$UNCOMMITTED" -gt 0 ]; then
            echo "❌ Error: You have uncommitted changes"
            git status -s
            exit 1
        fi
        
        echo "Running final checks..."
        if ./.agent/scripts/run-checks.sh; then
            echo ""
            read -p "Enter PR title (e.g., [FEATURE-ID] Description): " pr_title
            ./.agent/scripts/create-pr.sh "$pr_title"
        else
            echo "❌ Checks failed. Fix issues before creating PR."
            exit 1
        fi
        ;;
    4)
        echo ""
        echo "🔍 Running Checks"
        echo "─────────────────────"
        ./.agent/scripts/run-checks.sh
        ;;
    5)
        echo ""
        echo "📝 Updating State"
        echo "─────────────────────"
        ./.agent/scripts/update-state.sh
        ;;
    6)
        echo ""
        echo "📋 Creating Run Log"
        echo "─────────────────────"
        read -p "Enter summary of work completed: " summary
        ./.agent/scripts/run-log.sh "$summary"
        ;;
    7)
        echo ""
        echo "📖 Feature Requirements"
        echo "─────────────────────"
        echo ""
        if command -v jq &>/dev/null; then
            echo "Features with passes: false"
            jq '.features[] | select(.passes == false) | "\(.id): \(.description) [\(.priority)]"' feature-requirements.json -r | head -20
        else
            echo "Install jq for better viewing: brew install jq"
            echo "Or view feature-requirements.json manually"
        fi
        ;;
    8)
        echo ""
        echo "✓ Protocol Compliance Check"
        echo "─────────────────────────────"
        echo ""
        
        # Check if on feature branch
        if [ "$CURRENT_BRANCH" == "main" ] || [ "$CURRENT_BRANCH" == "develop" ]; then
            echo "❌ Working directly on $CURRENT_BRANCH (should use feature branch)"
        else
            echo "✅ On feature branch: $CURRENT_BRANCH"
        fi
        
        # Check for run logs
        LOG_COUNT=$(ls -1 .agent/logs/*.json 2>/dev/null | wc -l | tr -d ' ')
        if [ "$LOG_COUNT" -gt 0 ]; then
            echo "✅ Run logs exist ($LOG_COUNT logs)"
        else
            echo "⚠️  No run logs found in .agent/logs/"
        fi
        
        # Check for PRs
        if command -v gh &>/dev/null; then
            PR_COUNT=$(gh pr list --state all --limit 100 | wc -l | tr -d ' ')
            echo "✅ PRs created: $PR_COUNT"
        else
            echo "ℹ️  Install gh CLI to check PR status"
        fi
        
        # Check uncommitted work
        if [ "$UNCOMMITTED" -eq 0 ]; then
            echo "✅ No uncommitted changes"
        else
            echo "⚠️  Uncommitted changes: $UNCOMMITTED files"
        fi
        ;;
    9)
        echo ""
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid option"
        exit 1
        ;;
esac

echo ""
echo "✅ Done!"
