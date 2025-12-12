# Agent Protocol: Boot-up Ritual & Operating Procedures

## CRITICAL: Read This First on Every Run

This document defines the **mandatory boot-up ritual** that every coding agent must follow on each run. This ensures consistency, prevents rework, and maintains project momentum.

---

## BOOT-UP RITUAL (Execute in Order)

### 1. RE-GROUND: Read Core Protocols
**Purpose**: Align with project standards before taking any action.

Execute these reads in order:
1. Read `.agent/protocols/agent-protocol.md` (this file)
2. Read `.agent/memory/domain.md` - Understand the domain
3. Read `feature-requirements.json` - Know what needs to be done
4. Read `.agent/state/current-state.json` - Understand where we are

**RULE**: Never skip this step. Context from previous sessions is not guaranteed.

### 2. READ MEMORY: Load Context
**Purpose**: Understand what has been done and what patterns to follow.

Read these files:
- `.agent/memory/context.json` - Project metadata, tech decisions
- `.agent/memory/patterns.md` - Coding patterns and conventions (if exists)
- `.agent/logs/latest.json` - Last agent run summary (if exists)

### 3. RUN BASIC CHECKS: Validate Environment
**Purpose**: Ensure the project is in a working state before making changes.

Execute:
```bash
# Check git status
git status

# Check if dependencies are installed
npm list --depth=0 || echo "Dependencies may need installation"

# Run linter
npm run lint || echo "Linting issues detected"

# Run build to check for errors
npm run build || echo "Build errors detected"
```

**Decision Point**:
- If checks fail, document issues in `.agent/state/current-state.json`
- Decide: Fix blocking issues first OR proceed with caution

### 4. TIE-IN TEST RESULTS: Update State
**Purpose**: Connect current state to feature requirements.

Execute:
```bash
# If tests exist, run them
npm test 2>/dev/null || echo "No tests configured yet"

# Update current-state.json with test results
# Update feature-requirements.json passes field for completed features
```

**Action**: Update `.agent/state/current-state.json` with:
- Passing/failing tests
- Build status
- Any blockers discovered

### 5. REVIEW GIT HISTORY: Understand Progress
**Purpose**: Know what has been done to avoid duplicate work.

Execute:
```bash
# View recent commits
git log --oneline -10

# Check current branch
git branch --show-current

# View uncommitted changes
git status
git diff
```

**Analysis**:
- What feature was last worked on?
- Are there uncommitted changes? Why?
- What branch are we on? Should we be?

### 6. PLAN NEXT ACTION: Atomic Progress
**Purpose**: Choose ONE specific task to advance the project.

Process:
1. Review feature-requirements.json for `"passes": false` features
2. Check `.agent/state/current-state.json` for current focus
3. Select ONE feature to work on (prefer high priority, blocked items)
4. Verify prerequisites are met for that feature

**RULE**: Only work on ONE feature at a time. Complete it fully before moving on.

---

## OPERATING PROCEDURES

### Feature Development Workflow

#### Phase 1: Branch Management
```bash
# Create feature branch with standard naming
git checkout -b feature/[FEATURE-ID]-[short-description]
# Example: git checkout -b feature/AUTH-001-login-form
```

**Branch Naming Convention**:
- `feature/[ID]-[description]` - New features
- `bugfix/[ID]-[description]` - Bug fixes
- `refactor/[ID]-[description]` - Refactoring
- `test/[ID]-[description]` - Adding tests

#### Phase 2: Implementation
1. **Write Code**: Implement the feature per requirements
2. **Follow Patterns**: Match existing code style and patterns
3. **Atomic Commits**: Commit logical chunks of work

```bash
# Commit often with descriptive messages
git add [specific files]
git commit -m "[FEATURE-ID] Brief description of change

Detailed explanation if needed.
- What changed
- Why it changed
"
```

#### Phase 3: Verification
Before marking a feature as complete:
1. **Lint**: `npm run lint` - Must pass
2. **Build**: `npm run build` - Must pass
3. **Test**: Run tests if they exist
4. **Manual Test**: Verify steps in feature-requirements.json

**RULE**: A feature is ONLY complete when ALL steps pass.

#### Phase 4: Update Documentation
Update these files:
1. **feature-requirements.json**: Change `"passes": false` to `"passes": true`
2. **.agent/state/current-state.json**: Update current status
3. **.agent/logs/[timestamp].json**: Create run summary

#### Phase 5: Create Pull Request
```bash
# Ensure all changes are committed
git status

# Push branch
git push -u origin [branch-name]

# Create PR with standard template
gh pr create --title "[FEATURE-ID] Feature description" --body "$(cat .agent/protocols/pr-template.md)"
```

---

## ERROR HANDLING: Systems Thinking Approach

When you encounter an error, use this process:

### 1. Describe the Error Completely
Document:
- Exact error message
- Stack trace (full, not truncated)
- File and line number
- What action triggered it
- Environment (dev, build, test)

### 2. Identify the Symptom vs. Root Cause
Ask:
- Is this the actual problem or a symptom?
- What is the chain of causation?
- Are there multiple contributing factors?

### 3. Map the System
Draw connections:
- What components interact?
- What is the data flow?
- Where are the boundaries?
- What assumptions exist?

### 4. Hypothesize Root Cause
Using systems thinking:
- What changed recently that could cause this?
- Are there circular dependencies?
- Is there a mismatch in expectations between components?
- What is the minimal reproducing case?

### 5. Fix at the Root
**RULE**: Fix the root cause, not the symptom.

Bad fixes:
- Adding try/catch without understanding the error
- Commenting out code that breaks
- Adding defensive checks for undefined without fixing the source

Good fixes:
- Correcting the data flow
- Fixing the type mismatch
- Properly initializing state
- Correcting the async handling

### 6. Verify the Fix
- Does the original error still occur?
- Did we introduce new errors?
- Does the fix make sense in the larger system?
- Is the fix maintainable?

### 7. Document the Learning
Update `.agent/memory/patterns.md` with:
- The error pattern
- The root cause
- The fix
- How to prevent in the future

---

## TEST PHILOSOPHY

### The Golden Rule
**NEVER CHANGE THE TESTS** (in feature-requirements.json)

Tests define success criteria. Changing tests to make them pass is self-deception.

### What You Can Do
1. Add NEW tests for new functionality
2. Fix bugs in test IMPLEMENTATION (if test is wrong)
3. Update `"passes"` field based on actual test results

### What You Cannot Do
1. Remove test steps
2. Change test descriptions to match current implementation
3. Mark tests as passing when they don't
4. Skip test steps

### If Requirements Are Wrong
If feature requirements are genuinely incorrect:
1. Document the issue in `.agent/state/current-state.json`
2. Flag for human review
3. Do NOT change the requirements without explicit approval

---

## PROGRESS STANDARDS

Every agent run must achieve:

### 1. Atomic Progress
- Complete ONE discrete unit of work
- No partial implementations
- Feature is either done or not started

### 2. Observable State
- Git commits show what changed
- `.agent/state/current-state.json` reflects reality
- feature-requirements.json passes fields are accurate

### 3. Test-Passing State
- `npm run lint` passes
- `npm run build` passes
- Tests pass (when they exist)
- No regressions introduced

### 4. Machine-Readable Documentation
- All state changes recorded in JSON
- Timestamps on all entries
- Clear, parseable format

---

## STATE MANAGEMENT

### .agent/state/current-state.json Structure
```json
{
  "lastUpdated": "ISO 8601 timestamp",
  "currentBranch": "branch-name",
  "focusFeature": "FEATURE-ID or null",
  "blockers": [
    {
      "description": "What is blocked",
      "reason": "Why it's blocked",
      "since": "ISO 8601 timestamp"
    }
  ],
  "lastCommit": "commit hash",
  "buildStatus": "passing|failing",
  "lintStatus": "passing|failing",
  "testStatus": "passing|failing|no-tests",
  "nextActions": [
    "What should be done next"
  ],
  "agentRuns": [
    {
      "timestamp": "ISO 8601",
      "agent": "agent-identifier",
      "action": "what was done",
      "outcome": "success|failure|partial"
    }
  ]
}
```

### Update Frequency
- **Start of run**: Read current state
- **After each significant action**: Update state
- **End of run**: Final state update with summary

---

## GIT STANDARDS

### Commit Message Format
```
[FEATURE-ID] Brief summary (50 chars max)

Detailed description of changes:
- What changed
- Why it changed
- Any breaking changes
- Related issues

Tests: [passing|failing|not-applicable]
```

### When to Commit
- After each logical unit of work
- Before switching tasks
- After fixing a bug
- Before creating a PR

### What Not to Commit
- `node_modules/`
- `.env` files
- Build artifacts (`dist/`, `build/`)
- IDE settings (`.vscode/`, `.idea/`)
- OS files (`.DS_Store`)
- Log files

### Branch Lifecycle
1. Create from main/develop
2. Work on ONE feature
3. Keep updated with main (rebase or merge)
4. Create PR when complete
5. Delete after merge

---

## SCRIPTS: Automation First

Use scripts for repetitive tasks. This:
- Saves tokens
- Ensures consistency
- Reduces errors
- Creates documentation

### Required Scripts
See `scripts/` directory for:
- `scripts/run-checks.sh` - Lint, build, test
- `scripts/new-feature.sh` - Start new feature branch
- `scripts/update-state.sh` - Update current-state.json
- `scripts/create-pr.sh` - Create standardized PR

**RULE**: If you do something twice, create a script.

---

## COMMUNICATION STANDARDS

### With Other Agents
- Use `.agent/state/current-state.json` as shared memory
- Leave clear `nextActions` for next agent
- Document blockers explicitly
- Don't assume context

### With Humans
- Flag decisions that need human input
- Explain trade-offs clearly
- Provide evidence for recommendations
- Ask questions when requirements are ambiguous

---

## SUCCESS CRITERIA FOR EACH RUN

Before ending a run, verify:

- [ ] Boot-up ritual was completed
- [ ] ONE feature was worked on (not multiple)
- [ ] All checks pass (lint, build, test)
- [ ] Git commits are clean and descriptive
- [ ] `.agent/state/current-state.json` is updated
- [ ] feature-requirements.json is updated if feature completed
- [ ] No uncommitted changes (unless explicitly documented why)
- [ ] Next actions are clearly documented
- [ ] Run log created in `.agent/logs/`

---

## EMERGENCY PROCEDURES

### If Build is Broken
1. **STOP** new development
2. Document the break in current-state.json
3. Focus on fixing the build
4. Use git bisect if needed to find breaking commit
5. Do not mark any features as passing until build is fixed

### If Tests Are Failing
1. Document which tests are failing
2. Determine if it's a regression or expected
3. Fix regressions immediately
4. For expected failures, document why

### If You're Lost
1. Re-run boot-up ritual
2. Read `.agent/memory/domain.md` again
3. Check git log to understand recent work
4. Review current-state.json for context
5. Pick smallest possible next action

---

## REMEMBER

- **Consistency over cleverness**: Follow patterns that exist
- **Quality over speed**: Do it right, not fast
- **Documentation over memory**: Write it down
- **Tests over assumptions**: Verify, don't assume
- **Atomic over batch**: One thing at a time
- **Root cause over symptoms**: Fix the real problem

Every run should leave the project in a better, clearer state than you found it.
