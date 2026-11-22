# AI Agents for ddk-coder

This project provides a Dockerized environment for PHP code quality tools, specifically focused on Drupal Coding Standards. AI agents interacting with this repository should understand the following roles and context.

## Agent Roles

### 🛠 Infrastructure Agent
- **Focus**: `Dockerfile` and environment setup.
- **Responsibilities**:
    - Update base Alpine images (`alpine:3.19.9` for PHP 8.1, `alpine:3.22.8` for PHP 8.2, `alpine:3.24.4` for PHP 8.3+).
    - Manage PHP extensions and system dependencies.
    - Optimize Docker image layers and size.
    - Ensure multi-platform compatibility (`amd64`, `arm64`).

### ⚙️ CI/CD & Workflow Agent
- **Focus**: GitHub Actions (`.github/workflows/docker.yml`).
- **Responsibilities**:
    - Maintain the build and publish pipeline.
    - Handle Docker Hub authentication and manifest creation.
    - Integrate security scanning (Trivy) and provenance (SBOM).
    - Manage build arguments and environment variables.

### 📦 Dependency Agent
- **Focus**: PHP tools and versions.
- **Responsibilities**:
    - Update default versions for `PHP_VER`, `COMPOSER_VER`, and `CODER_VER`.
    - Ensure compatibility between `drupal/coder` and PHP versions.
    - Monitor `composer global require` packages for security and updates.

### 📝 Documentation Agent
- **Focus**: `README.md` and `AGENTS.md`.
- **Responsibilities**:
    - Keep usage examples up to date with the latest tool features.
    - Document integration examples (Bitbucket, GrumPHP, etc.).
    - Maintain this agent guidance file.

## Technical Context for Agents

- **Base OS**: Alpine Linux (3.19.9 for PHP 8.1, 3.22.8 for PHP 8.2, 3.24.4 for PHP 8.3+).
- **PHP Stack**: Supports PHP 8.1, 8.2, 8.3, 8.4, and 8.5 (default), optimized with `memory_limit = -1`.
- **Primary Tools**:
    - `phpcs`: PHP CodeSniffer.
    - `phpcbf`: PHP Code Beautifier and Fixer.
    - `yaml-lint`: YAML file validation.
- **Key Files**:
    - `/opt/coder/phpcs.xml`: Default configuration path (suggested for volume mapping).
    - `/root/.composer`: Location of global composer tools inside the container.
- **Standards**: Inherits Drupal coding standards from `drupal/coder`.
