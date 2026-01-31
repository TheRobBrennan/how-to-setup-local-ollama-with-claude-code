# Testing and Development Setup

## Testing GitHub Actions Locally

We recommend using [act](https://github.com/nektos/act) to test GitHub Actions workflows locally before pushing changes if you are developing on a Mac.

The application does not have to be running in Docker to test the workflows, but Docker Desktop must be running for the act tests to run and spin up the necessary containers.

### Prerequisites for macOS

- Homebrew
- Docker Desktop (must be running)

```sh
# Install act using Homebrew
brew install act

# Verify installation
act --version # Should show 0.2.76 or higher
```

### Running Tests

The following test scripts are available from the root of the repository:

1. `npm test` - Run all tests and GitHub workflows
2. `npm run test:workflows` - Only test GitHub workflows

### What the Tests Do

The test scripts validate the GitHub Actions workflows in this repository:

- **PR Title Check**: Validates PR titles against conventional commit format
- **Version Bump**: Tests the automatic version bumping workflow
- **GHCR Cleanup**: Tests the GitHub Container Registry cleanup workflow

### Expected Test Results

- Some tests may show git authentication errors when run locally (this is expected)
- Full workflow functionality can only be tested in the GitHub Actions environment
