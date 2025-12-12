# ⚛️ Atomic Vibes

**An atomic vibe-coding harness for AI agents.**

Atomic Vibes keeps your agents consistent and on-task through atomic changes and systemic workflows. Small, focused changes. Clear state management. Robust quality checks. Built for AI-assisted development.

**Self-Contained & Non-Intrusive**: The harness lives entirely in `.agent/` with one wrapper script at root. Runtime artifacts are gitignored—only essential files committed. Your project stays clean, your agents stay focused.

## ✨ Features

- 🤖 **Agent-First Design**: Built for AI-assisted development with mandatory boot-up rituals
- 📊 **Observable State**: Track exactly where your project is at all times
- ⚛️ **Atomic Progress**: Work on ONE feature at a time, complete it fully
- ✅ **Quality Gates**: Automated lint, type check, build, and test validation
- 📝 **Feature Catalog**: Machine-readable feature requirements with test steps
- 🔄 **Workflow Automation**: Scripts for common tasks (new feature, PR creation, state updates)

## 🚀 Quick Install

### One-Line Install

Install Atomic Vibes into any project:

```bash
curl -fsSL https://raw.githubusercontent.com/tmcnary/atomic-vibes/main/.agent/scripts/initialize.sh | bash
```

Then configure with an LLM:

```bash
./atomic llm-setup
# Copy the output and give to Claude Code or your LLM
```

### Manual Install

```bash
# Clone the repo
git clone https://github.com/tmcnary/atomic-vibes.git .atomic-vibes-tmp

# Run installer from the cloned directory
cd .atomic-vibes-tmp && ./atomic init && cd .. && rm -rf .atomic-vibes-tmp

# Configure
./atomic llm-setup
```

📖 **Full installation guide**: See [.agent/docs/INSTALL.md](.agent/docs/INSTALL.md)

## 🎯 Quick Start

After installation:

1. **Run boot-up ritual** (do this EVERY session):
   ```bash
   ./atomic boot-up
   ```

2. **Review what needs to be built**:
   ```bash
   cat feature-requirements.json
   ```

3. **Start working on a feature**:
   ```bash
   ./atomic new-feature FEATURE-ID "description"
   # Example: ./atomic new-feature AUTH-001 "add-login-form"
   ```

4. **Run quality checks**:
   ```bash
   ./atomic checks
   ```

5. **Create a pull request**:
   ```bash
   ./atomic create-pr "[FEATURE-ID] Description"
   ```

## 📁 Structure

### What Gets Committed
- **`atomic`**: Simple wrapper script (one file at project root)
- **`.agent/scripts/`**: All automation scripts (self-contained)
- **`.agent/protocols/`**: Agent instructions and operating procedures
- **`.agent/docs/`**: System documentation and guides
- **`feature-requirements.json`**: Source of truth for features and tests

### Not Committed (Runtime Artifacts)
- **`.agent/state/`**: Live project state (gitignored)
- **`.agent/logs/`**: Agent run history (gitignored)
- **`.agent/memory/`**: Runtime context (gitignored)

**The system is fully self-contained in `.agent/`** - just one wrapper script (`atomic`) at the root for convenience. No conflicts with your existing `scripts/` directory!

## Key Commands

Use the `atomic` wrapper for all commands:

-   **`./atomic boot-up`**: Performs initial checks, dependency validation, linting, building, and testing. Displays current agent state.
-   **`./atomic new-feature <ID> "<desc>"`**: Creates a new feature branch and updates state.
    *   Example: `./atomic new-feature AUTH-001 "Implement user login"`
-   **`./atomic checks`**: Executes linting, type checking, building, and testing before commits/PRs.
-   **`./atomic update-state`**: Manually updates state with latest branch, build, lint, and test statuses.
-   **`./atomic create-pr "<title>"`**: Creates a pull request with pre-PR checks and feature extraction.
    *   Example: `./atomic create-pr "[AUTH-001] Implement user login form"`

**Direct script access**: Scripts are in `.agent/scripts/` if needed.

## Observability

The `.agent/state/current-state.json` file is central to the observability of the development process. It tracks:

-   `lastUpdated`: Timestamp of the last state update.
-   `currentBranch`: The currently active Git branch.
-   `focusFeature`: The ID of the feature currently being worked on.
-   `blockers`: Any identified impediments.
-   `buildStatus`: Status of the last build (passing/failing).
-   `lintStatus`: Status of the last linting run (passing/failing).
-   `testStatus`: Status of the last test run (passing/failing/no-tests).
-   `nextActions`: A list of recommended next steps for the agent.
-   `agentRuns`: A history of agent runs and their outcomes.

## 🤖 LLM-Powered Setup

After installation, let an LLM analyze your codebase and configure everything:

```bash
./atomic llm-setup
```

This generates instructions for Claude Code (or any LLM) to:
- ✅ Fill in all placeholders in `.agent/memory/context.json`
- ✅ Document domain knowledge in `.agent/memory/domain.md`
- ✅ Generate comprehensive `feature-requirements.json` from your code
- ✅ Validate everything with boot-up checks

Copy the output and give it to your LLM, or see [.agent/docs/LLM_SETUP_PROMPT.md](.agent/docs/LLM_SETUP_PROMPT.md) for ready-to-use prompts.

## 🎓 Documentation

- **[.agent/docs/INSTALL.md](.agent/docs/INSTALL.md)**: Complete installation guide
- **[.agent/protocols/CLAUDE.md](.agent/protocols/CLAUDE.md)**: Quick reference for Claude Code
- **[.agent/protocols/AGENT_README.md](.agent/protocols/AGENT_README.md)**: 600+ line comprehensive guide for AI agents
- **[.agent/docs/LLM_SETUP_PROMPT.md](.agent/docs/LLM_SETUP_PROMPT.md)**: Ready-to-use LLM setup prompts
- **`.agent/protocols/agent-protocol.md`**: Operating procedures and standards
- **`.agent/docs/`**: Additional system documentation

## 🔄 The Atomic Workflow

This system enforces a strict workflow:

1. **Boot-up Ritual** (mandatory every session)
   - Re-grounds in protocols and domain knowledge
   - Validates environment (git, lint, build, test)
   - Shows current state and next actions

2. **Atomic Feature Development**
   - Work on ONE feature at a time
   - Create feature branch
   - Implement following existing patterns
   - Run quality checks (must pass)
   - Update state and feature catalog
   - Create PR

3. **Core Principles**
   - ⚛️ Atomic progress (complete one thing fully)
   - 📊 Observable state (track everything)
   - ✅ Test-passing state (never break the build)
   - 🚫 Never change tests (only implementation)
   - 🔍 Systems thinking (fix root causes)
   - 📝 Follow patterns (consistency over cleverness)

## 🛠️ Customization

### For Your Project

- Modify `package.json` for your dependencies and scripts
- Adjust scripts in `scripts/` for your tooling
- Update `feature-requirements.json` with your features
- Edit `.agent/memory/context.json` with your tech stack
- Document domain in `.agent/memory/domain.md`

### Extending the System

- Add custom scripts to `.agent/scripts/`
- Modify protocols in `.agent/protocols/agent-protocol.md`
- Add patterns to `.agent/memory/patterns.md`
- Customize git commit formats
- Adjust quality gates in `.agent/scripts/run-checks.sh`
- Add new commands to the `atomic` wrapper

## 🎯 Use Cases

This template is perfect for:

- **AI-Assisted Development**: Built for AI agents (Claude, GPT, etc.)
- **Strict Quality Controls**: Automated checks before every commit
- **Multi-Agent Workflows**: Shared state for team collaboration
- **Observable Development**: Always know exactly where you are
- **Atomic Delivery**: Ship small, complete features continuously

## 📊 What Makes This Different

1. **Agent-First Design**: Assumes AI agents will do the work
2. **Mandatory Rituals**: Boot-up ritual ensures consistency
3. **Observable State**: `.agent/state/current-state.json` shows everything
4. **Immutable Tests**: Tests define success, implementation adapts
5. **Systems Thinking**: Focus on root causes, not symptoms
6. **Complete Automation**: Scripts for every repetitive task

## 🚧 Example Project Included

The template includes a sample React + TypeScript + Vite project to demonstrate the system:

- **Tech Stack**: React 18, TypeScript, Vite, Tailwind CSS, Vitest
- **Status**: Frontend scaffold complete, no backend yet
- **Purpose**: Shows how to structure a real project with atomic implementation

You can either build on this scaffold or install the system into your own project.

## 🤝 Contributing

Contributions welcome! This template is designed to be:

- **Technology Agnostic**: Works with any stack
- **Extensible**: Add your own scripts and protocols
- **Customizable**: Adapt to your workflow

## 📝 License

[Your License Here]

---

**Ready to get started?** Run the installer and let an LLM configure everything:

```bash
# Install Atomic Vibes
curl -fsSL https://raw.githubusercontent.com/tmcnary/atomic-vibes/main/.agent/scripts/initialize.sh | bash

# Configure with LLM
./atomic llm-setup

# Start working
./atomic boot-up
```

⚛️ Welcome to Atomic Vibes!