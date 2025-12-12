# Installation Guide: Atomic Implementation System

This guide shows you how to install the atomic implementation system into a new or existing project.

## Quick Start (One-Liner)

Once this repo is on GitHub, you can install with:

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/atomic-implementation/main/scripts/initialize.sh | bash
```

Then let an LLM auto-fill everything:

```bash
./scripts/llm-autofill.sh
```

Copy the instructions and give them to Claude Code or your preferred LLM.

---

## Installation Methods

### Method 1: Remote Installation (Recommended)

Install directly from GitHub into any project:

```bash
# Navigate to your project
cd /path/to/your/project

# Run the installer
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/atomic-implementation/main/scripts/initialize.sh | bash

# Auto-fill with LLM (see instructions below)
./scripts/llm-autofill.sh
```

### Method 2: Clone and Copy

Clone this repo, then copy into your project:

```bash
# Clone the template
git clone https://github.com/YOUR_USERNAME/atomic-implementation.git

# Navigate to your project
cd /path/to/your/project

# Run initialize from the template
/path/to/atomic-implementation/scripts/initialize.sh
```

### Method 3: Use as Template (New Projects)

Click "Use this template" on GitHub, then:

```bash
# Clone your new repo
git clone https://github.com/YOUR_USERNAME/your-new-project.git
cd your-new-project

# The system is already installed, just need to customize it
./scripts/llm-autofill.sh
```

---

## Post-Installation: LLM Auto-Fill

After installation, you have two options to complete setup:

### Option A: LLM Auto-Fill (Recommended)

Run the helper script:

```bash
./scripts/llm-autofill.sh
```

This displays instructions. Copy them and give to Claude Code (or any LLM) with this prompt:

```
I just installed the atomic implementation system. Please follow the
instructions in the output above to:

1. Analyze this codebase
2. Fill in all placeholders in .agent/memory/context.json
3. Update .agent/memory/domain.md with actual domain knowledge
4. Generate comprehensive feature-requirements.json
5. Run ./scripts/boot-up.sh to validate

Be thorough - scan all files to understand the architecture, features,
and patterns.
```

The LLM will:
- ✓ Replace all `[PLACEHOLDER]` values in `context.json`
- ✓ Document domain knowledge in `domain.md`
- ✓ Generate feature catalog in `feature-requirements.json`
- ✓ Validate everything with boot-up script

### Option B: Manual Fill

Edit these files manually:

1. **`.agent/memory/context.json`**
   - Search for all `[PLACEHOLDER]` text
   - Replace with actual project values
   - Use the examples in the placeholders as guidance

2. **`.agent/memory/domain.md`**
   - Describe what your application does
   - Document business domain concepts
   - Explain architecture and tech stack

3. **`feature-requirements.json`**
   - List all features (existing and planned)
   - Add test steps for each feature
   - Mark `"passes": true` for working features
   - Mark `"passes": false` for incomplete/broken features

---

## Validation

After setup (LLM or manual), validate everything works:

```bash
# Run the boot-up ritual
./scripts/boot-up.sh
```

This checks:
- ✓ All files are properly formatted JSON
- ✓ Dependencies installed
- ✓ Lint passes
- ✓ Build passes
- ✓ Tests pass (if any)

If all checks pass, you're ready to go! 🎉

---

## What Gets Installed

The installation creates this structure:

```
your-project/
├── .agent/                          # Agent infrastructure
│   ├── memory/
│   │   ├── context.json            # Project metadata (with placeholders)
│   │   ├── domain.md               # Domain knowledge template
│   │   └── patterns.md             # (created as needed)
│   ├── protocols/
│   │   ├── agent-protocol.md       # Operating procedures
│   │   └── pr-template.md          # PR template
│   ├── state/
│   │   └── current-state.json      # Live project state
│   └── logs/                        # Agent run logs
├── scripts/                         # Automation scripts
│   ├── boot-up.sh                  # Boot-up ritual (run this first!)
│   ├── run-checks.sh               # Quality checks
│   ├── new-feature.sh              # Create feature branch
│   ├── update-state.sh             # Update state
│   ├── create-pr.sh                # Create PR
│   ├── initialize.sh               # This installer
│   └── llm-autofill.sh             # LLM helper
├── feature-requirements.json        # Feature catalog (template)
├── AGENT_README.md                 # Complete guide for agents
├── CLAUDE.md                       # Quick reference for Claude Code
└── .gitignore                      # Updated with .agent/logs/
```

---

## First Steps After Installation

1. **Run boot-up ritual**
   ```bash
   ./scripts/boot-up.sh
   ```

2. **Read the documentation**
   - `CLAUDE.md` - Quick reference
   - `AGENT_README.md` - Complete guide
   - `.agent/protocols/agent-protocol.md` - Operating procedures

3. **Review the state**
   ```bash
   cat .agent/state/current-state.json
   ```

4. **Start working on features**
   ```bash
   # Pick a feature from feature-requirements.json
   ./scripts/new-feature.sh FEATURE-ID "description"

   # Example:
   ./scripts/new-feature.sh AUTH-001 "add-login-form"
   ```

---

## Integration with Existing Projects

The system is designed to coexist with existing workflows:

### Existing Git Repo
- ✓ Preserves your git history
- ✓ Adds to existing `.gitignore`
- ✓ Creates feature branches from current branch

### Existing Scripts
- ✓ Doesn't overwrite `package.json` scripts
- ✓ Scripts in `scripts/` don't conflict with existing scripts
- ✓ Can run alongside existing CI/CD

### Existing Tests
- ✓ Works with existing test suites
- ✓ Adds atomic testing workflow on top
- ✓ `feature-requirements.json` can reference existing tests

---

## Troubleshooting

### "Permission denied" when running scripts

```bash
chmod +x scripts/*.sh
```

### "Command not found: git"

Install git first:
- macOS: `brew install git`
- Ubuntu: `sudo apt-get install git`
- Windows: Download from git-scm.com

### "Failed to clone template repository"

Either:
1. Download manually from GitHub and extract
2. Set custom repo URL: `export ATOMIC_TEMPLATE_REPO=https://your-repo-url.git`
3. Clone locally and use Method 2

### LLM can't fill placeholders

Make sure the LLM has:
- Access to read all project files
- Ability to edit files
- Context about the atomic implementation system
- Instructions from `./scripts/llm-autofill.sh`

### Boot-up script fails

Common issues:
- Missing dependencies: Run `npm install` (or equivalent)
- Lint errors: Fix with `npm run lint -- --fix`
- Build errors: Check `npm run build` output
- Invalid JSON: Validate `.agent/memory/context.json`

---

## Uninstall

To remove the atomic implementation system:

```bash
# Remove directories
rm -rf .agent/ scripts/

# Remove files
rm -f AGENT_README.md CLAUDE.md feature-requirements.json

# Clean up .gitignore
# (manually remove "# Atomic Implementation System" section)
```

---

## Customization

### Change Script Locations

Edit paths in:
- `.agent/protocols/agent-protocol.md`
- `CLAUDE.md`
- `AGENT_README.md`

### Add Custom Scripts

Add new scripts to `scripts/`:
- Name them descriptively
- Make executable: `chmod +x scripts/your-script.sh`
- Document in `CLAUDE.md` and `AGENT_README.md`

### Modify Protocols

Edit `.agent/protocols/agent-protocol.md` to customize:
- Boot-up ritual steps
- Quality standards
- Git commit formats
- Branch naming conventions

---

## Getting Help

- **Documentation**: See `AGENT_README.md` for complete guide
- **Issues**: Report bugs on GitHub Issues
- **Questions**: Check existing Issues or create new one

---

## Next Steps

After installation and setup:

1. ✓ Review `CLAUDE.md` for quick reference
2. ✓ Read `AGENT_README.md` to understand the workflow
3. ✓ Check `feature-requirements.json` for what needs to be built
4. ✓ Run `./scripts/boot-up.sh` at start of every session
5. ✓ Work on ONE feature at a time
6. ✓ Keep the build passing
7. ✓ Update state after changes

Welcome to atomic implementation! 🚀
