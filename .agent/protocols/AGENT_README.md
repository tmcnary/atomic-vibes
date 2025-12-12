# Agent Development Guide: Atomic Example Project

## Welcome, Coding Agent

This document is your comprehensive guide to working on the example atomic implementation project. Read this FIRST on every session before taking any action.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Project Overview](#project-overview)
3. [The Boot-up Ritual](#the-boot-up-ritual)
4. [Development Workflow](#development-workflow)
5. [Key Principles](#key-principles)
6. [File Structure](#file-structure)
7. [Common Tasks](#common-tasks)
8. [Troubleshooting](#troubleshooting)

---

## Quick Start

### First Time Setup
```bash
# 1. Run the boot-up script
./scripts/boot-up.sh

# 2. Review your assignment
cat .agent/state/current-state.json

# 3. Check feature requirements
cat feature-requirements.json

# 4. Start working on ONE feature
./scripts/new-feature.sh FEATURE-ID "description"
```

### Every Session
```bash
# ALWAYS run this first
./scripts/boot-up.sh

# This will:
# - Show you the current project state
# - Verify all checks are passing
# - Display recent git history
# - Show next actions
```

---

## Project Overview

**This repository** is an illustrative, multi-surface product used to demonstrate the atomic implementation system across web, mobile, API, data, and automation features.

### What It Does
- Delivers a marketing-style landing page with docs and contact flows
- Implements core authentication flows (email/password + external provider placeholder)
- Demonstrates commerce-style cart and checkout patterns
- Showcases dashboards, health checks, and data visualizations
- Includes automation touchpoints like chatbots and digest emails

### Tech Stack
- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS (theme-neutral and easily re-skinned)
- **Routing**: React Router DOM v6
- **Icons**: Lucide React
- **Backend**: Not yet implemented (currently mock data)

### Current State
- Frontend scaffolding: COMPLETE
- UI components: COMPLETE
- Pages: COMPLETE
- API integration: NOT STARTED
- Testing: CONFIGURED (sample tests only)
- Backend: NOT STARTED

---

## The Boot-up Ritual

**CRITICAL**: Execute this ritual on EVERY session, without exception.

### Why?
- Context from previous sessions is not guaranteed
- Ensures you have the latest state
- Prevents duplicate work
- Catches breaking changes early
- Aligns you with project standards

### The Six Steps

#### 1. RE-GROUND (5 minutes)
Read these files in order:
```bash
# Core protocols
.agent/protocols/agent-protocol.md

# Domain knowledge
.agent/memory/domain.md

# Feature requirements
feature-requirements.json

# Current state
.agent/state/current-state.json
```

**Purpose**: Understand the rules, domain, requirements, and current state.

#### 2. READ MEMORY (2 minutes)
```bash
# Project context
.agent/memory/context.json

# Code patterns (if exists)
.agent/memory/patterns.md

# Latest run log
.agent/logs/latest.json
```

**Purpose**: Load context about technical decisions and recent work.

#### 3. RUN BASIC CHECKS (3 minutes)
```bash
./scripts/run-checks.sh
```

Or manually:
```bash
git status
npm run lint
npm run build
npm test  # if configured
```

**Purpose**: Verify the project is in a working state.

#### 4. TIE-IN TEST RESULTS (2 minutes)
```bash
# Run tests and check results
npm test

# Update state with results
./scripts/update-state.sh
```

**Purpose**: Connect test outcomes to feature progress.

#### 5. REVIEW GIT HISTORY (2 minutes)
```bash
git log --oneline -10
git status
git diff
```

**Purpose**: Understand recent changes and current branch state.

#### 6. PLAN NEXT ACTION (3 minutes)
- Review feature-requirements.json for failing features
- Check .agent/state/current-state.json for focus feature
- Select ONE feature to work on
- Verify no blockers prevent starting

**Purpose**: Choose the right thing to work on.

---

## Development Workflow

### Phase 1: Select Feature

1. Open `feature-requirements.json`
2. Find features with `"passes": false`
3. Prioritize by:
   - `"priority": "critical"` first
   - Then `"priority": "high"`
   - Then by category (navigation, auth, core features first)
4. Choose ONE feature
5. Read all steps for that feature

### Phase 2: Create Branch

```bash
./scripts/new-feature.sh FEATURE-ID "short-description"
# Example: ./scripts/new-feature.sh AUTH-001 "login-form"
```

This will:
- Create a feature branch
- Update current-state.json with focus feature
- Set up tracking

### Phase 3: Implement

1. **Read existing code** in the relevant area
2. **Understand patterns** before changing anything
3. **Implement the feature** following existing patterns
4. **Write atomic commits** for each logical change

```bash
# Commit format
git add [files]
git commit -m "[FEATURE-ID] Brief description

Detailed changes:
- What changed
- Why it changed

Tests: passing|failing|n/a
"
```

### Phase 4: Verify

Before marking complete, ensure ALL of these pass:

```bash
# Run all checks
./scripts/run-checks.sh

# Must pass:
# ✓ Linting
# ✓ Type checking
# ✓ Build
# ✓ Tests (if configured)

# Manual verification:
# ✓ All steps in feature-requirements.json work
# ✓ No regressions in other features
# ✓ Follows existing code patterns
```

### Phase 5: Document

Update these files:

1. **feature-requirements.json**
   ```json
   {
     "id": "FEATURE-ID",
     "passes": true  // Change false to true
   }
   ```

2. **.agent/state/current-state.json**
   ```bash
   ./scripts/update-state.sh
   ```

3. **.agent/logs/** (create new log entry)

### Phase 6: Create PR

```bash
./scripts/create-pr.sh "[FEATURE-ID] Feature description"
```

This will:
- Run pre-PR checks
- Push your branch
- Create PR with template (if gh CLI installed)
- OR provide PR body to copy manually

---

## Key Principles

### 1. Atomic Progress
- Work on ONE feature at a time
- Complete it fully before moving on
- No partial implementations

### 2. Observable State
- Every change is tracked
- Git commits show what changed
- State files reflect reality
- Documentation stays current

### 3. Test-Passing State
- NEVER leave the build broken
- NEVER commit failing lint
- ALWAYS verify before pushing
- End every session in a clean state

### 4. Don't Change Tests
- Tests in feature-requirements.json define success
- Only change `"passes"` field
- Never remove or modify test steps
- If requirements are wrong, flag for human review

### 5. Systems Thinking
When encountering errors:
- Describe the error completely
- Find the root cause, not the symptom
- Understand the system context
- Fix at the root, not with bandaids
- Document the learning

### 6. Follow Patterns
- Read existing code first
- Match the style you see
- Don't introduce new patterns without reason
- Consistency over cleverness

---

## File Structure

```
atomic-implementation/
├── .agent/                          # Agent memory and protocols
│   ├── memory/
│   │   ├── domain.md               # Domain knowledge
│   │   ├── context.json            # Project context & decisions
│   │   └── patterns.md             # Code patterns (created as needed)
│   ├── protocols/
│   │   ├── agent-protocol.md       # Boot-up ritual & procedures
│   │   └── pr-template.md          # PR template
│   ├── state/
│   │   └── current-state.json      # Current project state
│   └── logs/                        # Agent run logs
│       └── [timestamp].json
├── scripts/                         # Automation scripts
│   ├── boot-up.sh                  # Boot-up ritual script
│   ├── run-checks.sh               # Run all quality checks
│   ├── new-feature.sh              # Start new feature branch
│   ├── update-state.sh             # Update current-state.json
│   └── create-pr.sh                # Create pull request
├── src/                             # Application source
│   ├── App.tsx                     # Main app component
│   ├── index.tsx                   # Entry point
│   └── src/                        # Note: legacy structure
│       ├── components/
│       │   ├── ui/                 # Reusable UI components
│       │   ├── features/           # Business logic components
│       │   ├── layout/             # Layout components
│       │   └── effects/            # Visual effects
│       ├── pages/                  # Page components
│       ├── types/                  # TypeScript types
│       └── data/                   # Mock data (temporary)
├── feature-requirements.json        # THE source of truth for features
├── AGENT_README.md                 # This file
├── package.json
└── ...config files
```

### Key Files

#### feature-requirements.json
- **THE** source of truth for what needs to be built
- Contains all features with test steps
- Only modify `"passes"` field
- Never delete or change tests

#### .agent/state/current-state.json
- Live state of the project
- Updated frequently during work
- Shows current branch, focus, blockers
- Tracks agent runs

#### .agent/memory/context.json
- Technical decisions and rationale
- Architecture choices
- Conventions and standards
- Read-only during normal work

#### .agent/memory/domain.md
- Business domain knowledge
- What the app does and why
- Key concepts and terminology
- Read-only during normal work

---

## Common Tasks

### Start New Feature
```bash
./scripts/new-feature.sh AUTH-001 "login-form"
```

### Run All Checks
```bash
./scripts/run-checks.sh
```

### Update Project State
```bash
./scripts/update-state.sh
```

### Create Pull Request
```bash
./scripts/create-pr.sh "[AUTH-001] Add login form"
```

### Manual State Update
```bash
# Edit .agent/state/current-state.json
# Update lastUpdated, focusFeature, etc.
```

### Mark Feature Complete
```bash
# 1. Verify all tests pass
./scripts/run-checks.sh

# 2. Manual test per feature-requirements.json steps

# 3. Edit feature-requirements.json
# Find your feature by id
# Change "passes": false to "passes": true

# 4. Update state
./scripts/update-state.sh

# 5. Commit
git add feature-requirements.json .agent/state/current-state.json
git commit -m "[FEATURE-ID] Mark feature as complete"
```

### Handle Errors

1. **Describe completely**
   ```bash
   # Capture full error
   npm run build 2>&1 | tee error.log
   ```

2. **Analyze with systems thinking**
   - What is the root cause?
   - What are the dependencies?
   - What changed recently?

3. **Fix at the root**
   - Don't bandaid symptoms
   - Fix the actual problem

4. **Document the learning**
   ```bash
   # Add to .agent/memory/patterns.md
   echo "## Error Pattern: [description]" >> .agent/memory/patterns.md
   echo "Root cause: ..." >> .agent/memory/patterns.md
   echo "Fix: ..." >> .agent/memory/patterns.md
   ```

---

## Troubleshooting

### Build Failing
```bash
# Check what's wrong
npm run build

# Check TypeScript errors
npx tsc --noEmit

# Fix errors, then verify
./scripts/run-checks.sh
```

### Lint Failing
```bash
# See what's wrong
npm run lint

# Auto-fix if possible
npm run lint -- --fix

# Manual fix remaining issues
# Then verify
./scripts/run-checks.sh
```

### Git Conflicts
```bash
# Update from main
git fetch origin
git rebase origin/main

# Or merge
git merge origin/main

# Resolve conflicts
# Then verify build still works
./scripts/run-checks.sh
```

### Lost Context
```bash
# Re-run boot-up ritual
./scripts/boot-up.sh

# Read current state
cat .agent/state/current-state.json

# Check what feature you were on
git branch --show-current

# Review recent commits
git log --oneline -5
```

### Can't Find What to Work On
```bash
# Check current focus
cat .agent/state/current-state.json | grep focusFeature

# Or review failing features
cat feature-requirements.json | grep '"passes": false' -B 5

# Prioritize: critical > high > medium > low
```

---

## Success Criteria

Before ending ANY session, verify:

- [ ] Boot-up ritual was completed at start
- [ ] Worked on ONE feature only
- [ ] All checks pass (`./scripts/run-checks.sh`)
- [ ] Git commits are clean and descriptive
- [ ] `.agent/state/current-state.json` is updated
- [ ] `feature-requirements.json` updated if feature completed
- [ ] No uncommitted changes (unless documented why)
- [ ] Next actions are documented
- [ ] Run log created in `.agent/logs/`

---

## Quick Reference

### Most Important Files
1. `feature-requirements.json` - What to build
2. `.agent/state/current-state.json` - Where we are
3. `.agent/protocols/agent-protocol.md` - How to work
4. `.agent/memory/domain.md` - What the app does

### Most Important Scripts
1. `./scripts/boot-up.sh` - Start here ALWAYS
2. `./scripts/run-checks.sh` - Verify quality
3. `./scripts/new-feature.sh` - Start new work
4. `./scripts/create-pr.sh` - Finish work

### Most Important Commands
```bash
# Start of session
./scripts/boot-up.sh

# During work
./scripts/run-checks.sh
./scripts/update-state.sh

# End of session
./scripts/create-pr.sh "[ID] Description"
```

### Most Important Rules
1. Boot-up ritual EVERY session
2. ONE feature at a time
3. NEVER change tests
4. ALWAYS end with passing builds
5. Systems thinking for errors
6. Update state after changes

---

## Getting Help

### Where to Look
1. `.agent/memory/domain.md` - Business logic questions
2. `.agent/memory/context.json` - Technical decisions
3. `.agent/protocols/agent-protocol.md` - Process questions
4. `feature-requirements.json` - What needs to be built
5. Existing code - How things are done

### When to Flag for Human
- Tests seem incorrect
- Requirements are contradictory
- Architectural decision needed
- Multiple valid approaches
- Blocker can't be resolved

### How to Flag
Add to `.agent/state/current-state.json`:
```json
{
  "blockers": [
    {
      "description": "Clear description of issue",
      "reason": "Why it's blocking progress",
      "since": "2025-12-10T12:00:00Z",
      "priority": "high",
      "needsHuman": true,
      "question": "Specific question for human"
    }
  ]
}
```

---

## Remember

> "Progress needs to be atomic, observable, and testable. Pick one item, update shared state, increment, and end every run with a clean test-passing state."

Every run should leave the project better than you found it:
- More features passing
- Better documentation
- Clearer state
- No regressions

Good luck, and happy coding!

---

**Version**: 1.0.0
**Last Updated**: 2025-12-10
**Maintained By**: Agent Infrastructure
