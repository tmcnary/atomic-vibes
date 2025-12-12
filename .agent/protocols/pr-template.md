# Pull Request Template

## Feature ID
<!-- e.g., AUTH-001, ROUTE-003, etc. -->

## Summary
<!-- Brief description of what this PR accomplishes -->

## Feature Requirements
<!-- Copy relevant information from feature-requirements.json -->
- **Category**:
- **Priority**:
- **Description**:

## Changes Made
<!-- Detailed list of changes -->
-
-
-

## Testing Performed
<!-- Describe how you verified this works -->

### Feature Requirement Steps
<!-- Check off each step from feature-requirements.json -->
- [ ] Step 1: ...
- [ ] Step 2: ...
- [ ] Step 3: ...
- [ ] Step 4: ...
- [ ] Step 5: ...

### Manual Testing
- [ ] Tested in development environment
- [ ] Verified no regressions in related features
- [ ] Tested responsive design (mobile, tablet, desktop)
- [ ] Tested edge cases

### Automated Checks
- [ ] `npm run lint` passes
- [ ] `npm run build` passes
- [ ] `npm test` passes (if applicable)
- [ ] TypeScript compilation succeeds

## Screenshots / Demo
<!-- If applicable, add screenshots or GIF demos of the feature -->

## Breaking Changes
<!-- List any breaking changes or migration notes -->
- None

OR

- Breaking change description
- Migration steps

## Dependencies
<!-- Any new dependencies added? -->
- None

OR

- Package name: version (reason for adding)

## Checklist

### Code Quality
- [ ] Code follows project style guidelines
- [ ] Code matches existing patterns in the codebase
- [ ] No console.logs or debugging code left in
- [ ] No commented-out code blocks
- [ ] Variable and function names are clear and descriptive
- [ ] Complex logic has explanatory comments
- [ ] No unnecessary complexity introduced

### Documentation
- [ ] `feature-requirements.json` updated (passes: true)
- [ ] `.agent/state/current-state.json` updated
- [ ] `.agent/logs/` run log created
- [ ] Inline code comments added where needed
- [ ] README.md updated (if user-facing changes)

### Testing
- [ ] All feature requirement steps verified
- [ ] Edge cases tested
- [ ] Error states tested
- [ ] Loading states tested (if applicable)
- [ ] No regressions introduced

### Git
- [ ] Commits are atomic and well-described
- [ ] Commit messages follow format: `[FEATURE-ID] Description`
- [ ] No merge commits (rebased if needed)
- [ ] Branch is up to date with main/develop

### Security
- [ ] No secrets or API keys committed
- [ ] User input is validated
- [ ] No XSS vulnerabilities introduced
- [ ] No SQL injection risks (if backend changes)
- [ ] Authentication/authorization checked (if applicable)

### Performance
- [ ] No obvious performance issues introduced
- [ ] Images are optimized (if added)
- [ ] No unnecessary re-renders (React specific)
- [ ] Async operations handled properly

## Related Issues
<!-- Link to any related issues or PRs -->
- Closes #
- Related to #

## Rollback Plan
<!-- How to rollback if this causes issues in production -->
- Simple revert: Yes / No
- If no, explain steps needed to rollback

## Deployment Notes
<!-- Anything special needed for deployment? -->
- None

OR

- Environment variables needed: ...
- Database migrations needed: ...
- Manual steps after deployment: ...

## Reviewer Notes
<!-- Anything specific you want reviewers to focus on? -->

## Post-Merge Actions
<!-- Things to do after merge -->
- [ ] Delete feature branch
- [ ] Update project documentation (if needed)
- [ ] Notify team (if breaking changes)

---

**Agent Run**: [timestamp]
**Build Status**: Passing ✓
**Test Status**: [Passing / No tests / N/A]
**Ready for Review**: Yes / No
