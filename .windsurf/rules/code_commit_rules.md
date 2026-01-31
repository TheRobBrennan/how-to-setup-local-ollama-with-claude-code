---
trigger: always_on
---

# Code Commit Rules

These rules define strict policies for code commits and version control operations that MUST be followed by all AI assistants, LLMs, and automated tooling.

<commit_policy>

## CRITICAL: No Automatic Commits

- **NEVER** automatically commit code changes without explicit user approval
- **NEVER** run `git add`, `git commit`, `git push`, or any git commands that modify version control without being explicitly asked
- **NEVER** assume the user wants changes committed just because they've been implemented
- **ALWAYS** wait for explicit user instruction before committing any changes

## Explicit Approval Required

The user must explicitly request commits using phrases such as:
- "Commit these changes"
- "Create a commit with..."
- "Stage and commit..."
- "Push these changes"
- "Make a commit"

Simply implementing code changes does NOT imply permission to commit them.

## Pre-Commit Verification

Before committing (when explicitly requested), you MUST:
1. Verify all changes work as expected
2. Ensure tests pass (if applicable)
3. Review the changes with the user
4. Confirm the commit message follows project conventions
5. Wait for final user approval

## What You CAN Do Without Approval

You may perform these actions without explicit approval:
- Create and edit files
- Implement code changes
- Run tests and verification commands
- Create branches (following project branch naming conventions)
- Read git status and logs

## What You CANNOT Do Without Approval

You must NEVER perform these actions without explicit user request:
- `git add` (staging changes)
- `git commit` (creating commits)
- `git push` (pushing to remote)
- `git merge` (merging branches)
- `git rebase` (rebasing commits)
- `git reset` (resetting commits)
- `git revert` (reverting commits)
- `git cherry-pick` (cherry-picking commits)
- Any other git command that modifies version control history

</commit_policy>

<commit_message_standards>

## When Commits Are Requested

If the user explicitly requests a commit, follow these standards:

1. **Use Semantic Commit Messages**:
   - Follow the project's semantic versioning conventions
   - Use appropriate prefixes: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, `build:`, `ci:`, `chore:`, `revert:`
   - Use `feat!:` for breaking changes

2. **Commit Message Format**:
   ```
   <type>: <subject>
   
   <body (optional)>
   
   <footer (optional)>
   ```

3. **Sign Commits**:
   - Use `git commit -S` to sign commits with GPG when available
   - Follow the project's commit signing requirements

</commit_message_standards>

<workflow_integration>

## Integration with Other Tools

These rules apply to ALL tools and integrations:
- GitHub Copilot
- Windsurf Cascade
- Any AI coding assistants
- Automated scripts and workflows
- CI/CD pipelines (unless explicitly configured)

## User Autonomy

The user maintains complete control over:
- When code is committed
- What commit messages are used
- When code is pushed to remote repositories
- All version control operations

</workflow_integration>
