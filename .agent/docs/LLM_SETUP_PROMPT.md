# LLM Setup Prompt

Copy and paste this into Claude Code (or your preferred LLM) after running `./scripts/initialize.sh`:

---

## Prompt

```
I just installed the atomic implementation system in this project. Please set it up by analyzing the codebase and filling in all the template placeholders.

TASKS:

1. Fill in .agent/memory/context.json
   - Read package.json, README.md, and config files
   - Replace ALL [PLACEHOLDER] values with actual project details
   - Infer values from the codebase where needed
   - Keep the JSON structure intact

2. Update .agent/memory/domain.md
   - Analyze the codebase to understand what it does
   - Document the domain knowledge, features, and architecture
   - Replace the template content with actual information

3. Generate feature-requirements.json
   - Scan all pages, routes, and components
   - Create a comprehensive feature catalog
   - For each feature, create specific test steps
   - Set "passes": true for working features
   - Set "passes": false for incomplete/broken features
   - Include these categories:
     * web-navigation (routes, pages)
     * auth (if authentication exists)
     * core-features (main functionality)
     * ui-components (major reusable components)
     * api (if backend exists)
     * testing (test coverage)

4. Validate everything
   - Run ./scripts/boot-up.sh
   - Fix any issues found
   - Report results

GUIDELINES:
- Be thorough - read all relevant files
- Don't leave any [PLACEHOLDER] values
- Be honest about what "passes" vs what doesn't
- Follow the examples in the placeholders
- Keep atomic implementation principles

When done, report:
✓ Placeholders filled
✓ Features cataloged
✓ Boot-up validation results
✓ Any issues discovered
```

---

## Alternative: Step-by-Step Prompt

If the LLM needs more guidance, use this step-by-step version:

### Step 1: Context Analysis

```
Please analyze this codebase and fill in .agent/memory/context.json.

Read these files first:
- package.json (or equivalent)
- README.md
- Any config files (tsconfig.json, vite.config.ts, etc.)
- Source code to understand architecture

Then replace every [PLACEHOLDER] in .agent/memory/context.json with actual values. For example:
- [PROJECT_NAME] → get from package.json name field
- [FRONTEND_FRAMEWORK] → check package.json dependencies
- [THEME_DESCRIPTION] → analyze CSS/Tailwind config
- [CURRENT_STATE_MANAGEMENT] → look for Redux/Zustand/Context usage

Show me the filled context.json when done.
```

### Step 2: Domain Documentation

```
Now update .agent/memory/domain.md with actual domain knowledge about this project.

Analyze:
- What does this application do?
- Who is it for?
- What are the main features?
- What's the tech stack?
- What are the key domain concepts?

Replace the template content with comprehensive domain documentation.
```

### Step 3: Feature Catalog

```
Generate a comprehensive feature-requirements.json by analyzing the codebase.

For each route/page/major feature:
1. Create a feature entry with unique ID
2. Write specific test steps
3. Determine if it currently works (passes: true/false)

Scan:
- All routes and pages
- All major components
- Authentication flows (if any)
- API endpoints (if any)
- Mobile responsiveness
- Accessibility features

Create a thorough catalog - I want to know everything that exists and everything that's missing.
```

### Step 4: Validation

```
Run ./scripts/boot-up.sh and tell me the results.

If anything fails:
- Show me the error
- Explain what's wrong
- Fix it if possible

Report the final status of:
- Lint
- Type checking
- Build
- Tests
```

---

## What the LLM Should Produce

After running these prompts, you should have:

1. ✅ `.agent/memory/context.json` - Fully filled with no [PLACEHOLDER] remaining
2. ✅ `.agent/memory/domain.md` - Complete domain documentation
3. ✅ `feature-requirements.json` - Comprehensive feature catalog
4. ✅ `.agent/state/current-state.json` - Updated with actual build/lint/test status
5. ✅ Boot-up validation - All checks passing (or issues documented)

---

## Example Response

The LLM should respond with something like:

```
I've completed the setup of the atomic implementation system:

✓ Filled in .agent/memory/context.json
  - Replaced 47 placeholders with actual project details
  - Project: my-awesome-app (React 18 + TypeScript + Vite)
  - Styling: Tailwind CSS with dark theme
  - No backend currently (frontend only)

✓ Updated .agent/memory/domain.md
  - Documented this is a task management application
  - Described core features: projects, tasks, tags, search
  - Noted it's for individual/team productivity

✓ Generated feature-requirements.json
  - Cataloged 23 features across 6 categories
  - 15 features passing (implemented and working)
  - 8 features failing (incomplete or planned)
  - Categories: web-navigation, auth, tasks, projects, ui-components, testing

✓ Ran ./scripts/boot-up.sh
  - Lint: ✓ Passing
  - Type check: ✓ Passing
  - Build: ✓ Passing
  - Tests: ⚠ No tests configured yet (added as TESTING-001 feature)

Next steps:
1. Review feature-requirements.json and prioritize work
2. Start with failing "critical" priority features
3. Run ./scripts/new-feature.sh to begin work
```
