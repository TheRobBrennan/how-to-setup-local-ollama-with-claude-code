---
trigger: always_on
---

# Documentation Standards

## README Maintenance

### Package.json Scripts

- When adding or modifying scripts in `package.json`:
  1. Update the README's "Available Scripts" section to reflect the changes
  2. Document the purpose of each script
  3. Group related scripts under appropriate headings (e.g., "Docker Management", "Testing")
  4. Include any important notes or warnings for potentially destructive commands

### Package.json Script Organization

- When organizing scripts in `package.json`:
  1. Always place `"start"` as the first script
  2. Always place `"test"` as the second script
  3. Alphabetize all remaining scripts after `"start"` and `"test"`
  4. This standard applies whenever alphabetization of scripts is requested

### Prerequisites

- List all required software and tools in the Prerequisites section
- Include version requirements where applicable
- Provide installation links for all dependencies

### Quick Start Guide

- Keep the quick start guide up-to-date with the current setup process
- Include all necessary steps to get started
- Use code blocks with proper syntax highlighting
- Add any environment variables or configuration needed

## Workflow Documentation

- Each workflow in the `workflows/examples/` directory should include:
  - A `README.md` explaining the workflow's purpose
  - Required setup steps
  - Example inputs/outputs
  - Any dependencies or prerequisites

## Pull Request Descriptions

- Always include complete references in PR descriptions:
  - Use actual script/feature names: "Added `claude:install` script" NOT "Added script"
  - Include file references with relative paths: "Updated [`README.md`](README.md)" NOT "Updated README"
  - Use relative file paths, NEVER full GitHub URLs
  - Example (correct): "Added `new-feature` to [`package.json`](package.json)"
  - Example (wrong): "Added feature to package.json" (missing backticks and link)

## Style Guidelines

- Use consistent heading levels
- Include blank lines around headings and lists
- Use backticks for file names, directory names, and commands
- Include descriptive alt text for images
- Keep line lengths under 100 characters where possible
