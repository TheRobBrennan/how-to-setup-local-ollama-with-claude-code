# Contributing to Starting Point

Thank you for considering a contribution! This project uses signed commits and conventional commit messages. Please follow the guidelines below when opening pull requests.

## Setting Up GPG Commit Signing

1. **Create or Import a Key**
   - Generate a new GPG key or import an existing one. GitHub provides a [quick start guide](https://docs.github.com/authentication/managing-commit-signature-verification/generating-a-new-gpg-key) if you need help.
2. **Configure Git to Use Your Key**

   ```bash
   git config --global user.signingkey YOUR_KEY_ID
   git config --global commit.gpgsign true
   ```

3. **Publish the Public Key to GitHub**
   - Upload your public key under **Settings → SSH and GPG keys** so that commits appear as "Verified".

All commits pushed to this repository must be GPG signed. Use `git commit -S` if automatic signing is disabled.

## Development Workflow

1. **Fork and Branch**
   - Create a feature branch off `main` for your work.
2. **Follow Conventional Commits**
   - Use the format `type(scope): message` for commit titles and PR titles.
   - Examples: `feat(ui): add login form`, `fix(api): handle 500 error`.
   - Breaking changes: Add `!` after the type (e.g., `feat!: breaking change`) for major version bumps
3. **Run Tests**
   - Execute `npm test` before opening a pull request. Tests rely on [act](https://github.com/nektos/act) and Docker.
   - Only basic workflow tests are included in this template.
4. **Open a Pull Request**
   - Fill out the provided PR template.
   - Ensure your commits are signed and all checks pass.
   - Follow PR description guidelines below.

## Pull Request Description Guidelines

### Required Sections
All PR descriptions must include:
- `# Description` - Brief explanation of changes
- `version: <type>` - Semantic versioning type (feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert)

### File References
When referencing files in the PR description:
- **Use relative paths**: `[file.md](path/to/file.md)` or `[README.md](README.md)`
- **Never use full GitHub URLs**: Avoid `[file.md](https://github.com/user/repo/blob/branch/file.md)`
- **Example**:
  ```markdown
  - Updated [`README.md`](README.md) with new instructions
  - Added [`docs/guide.md`](docs/guide.md) with comprehensive documentation
  ```

### Forbidden Content
PR descriptions must NOT include:
- Testing sections or checkboxes (`## Testing`, `[ ]`, `[x]`)
- Local testing output or act command results
- Workflow testing references
- Debug output or logs
- Any content related to local development testing

### Example PR Description
```markdown
# Description

Add comprehensive documentation for new feature.

## Type of Change

version: docs     # Documentation changes

## Changes Made

- Updated [`README.md`](README.md) with setup instructions
- Created [`docs/guide.md`](docs/guide.md) with detailed examples
- Fixed formatting in existing documentation
```

## Repository Configuration

For repository maintainers, ensure these GitHub Actions settings are configured:

1. **Workflow Permissions** (Settings → Actions → General):

   ```md
   Workflow permissions:
   ☑️ Read and write permissions
   ☑️ Allow GitHub Actions to create and approve pull requests
   ```

2. **Fork Pull Request Workflows**:

   ```md
   Run workflows from fork pull requests:
   ⚠️ Configure based on your security requirements
   ```

3. **Access**:

   ```md
   Repository Access:
   ○ Not accessible (recommended for private repos)
   ○ Accessible from repositories owned by your organization
   ```

We appreciate all issues and PRs! For more details on local workflow testing see [`.github/docs/TESTING.md`](.github/docs/TESTING.md).
