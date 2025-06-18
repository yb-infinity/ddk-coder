# Docker Image with Code Quality Tools

### (phpcs, phpcbf, yaml-lint) based on drupal/coder project

[![Docker Image CI](https://github.com/yb-infinity/ddk-coder/actions/workflows/docker.yml/badge.svg)](https://github.com/yb-infinity/ddk-coder/actions/workflows/docker.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/drakemazzy/ddk-coder.svg)](https://hub.docker.com/r/drakemazzy/ddk-coder)
[![Docker Image Size](https://img.shields.io/docker/image-size/drakemazzy/ddk-coder/latest)](https://hub.docker.com/r/drakemazzy/ddk-coder)
[![Docker Stars](https://img.shields.io/docker/stars/drakemazzy/ddk-coder.svg)](https://hub.docker.com/r/drakemazzy/ddk-coder)
[![License: GPL-2.0-or-later](https://img.shields.io/badge/License-GPL%20v2+-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0-standalone.html)

This project provides a Docker image that includes:
- [PHP 8](https://www.php.net/) (distributed under the [PHP License](https://www.php.net/license/))
- [Composer](https://getcomposer.org/) (licensed under [MIT](https://github.com/composer/composer/blob/main/LICENSE))
- [pfrenssen/coder](https://github.com/pfrenssen/coder) (GPL-2.0-or-later)
- [dealerdirect/phpcodesniffer-composer-installer](https://github.com/Dealerdirect/phpcodesniffer-composer-installer) (BSD-2-Clause)
- [sirbrillig/phpcs-variable-analysis](https://github.com/sirbrillig/phpcs-variable-analysis) (MIT)
- [slevomat/coding-standard](https://github.com/slevomat/coding-standard) (MIT)
- [squizlabs/php_codesniffer](https://github.com/squizlabs/PHP_CodeSniffer) (BSD-3-Clause)
- [symfony/yaml](https://github.com/symfony/yaml) (MIT)

## Usage

### Pull the Image

```bash
docker pull drakemazzy/ddk-coder:latest
```

### Running Code Quality Checks

Basic usage:
```bash
docker run --rm -v $(pwd):/tmp drakemazzy/ddk-coder:latest phpcs /tmp
```

With custom configuration:
```bash
docker run --rm -v $(pwd):/tmp -v $(pwd)/phpcs.xml:/opt/coder/phpcs.xml drakemazzy/ddk-coder:latest phpcs /tmp
```

### Available Commands

- PHP CodeSniffer:
  ```bash
  docker run --rm drakemazzy/ddk-coder:latest phpcs --version
  docker run --rm drakemazzy/ddk-coder:latest phpcbf --version
  ```

### Integration Examples

#### Bitbucket Pipelines

Add this to your `bitbucket-pipelines.yml`:

```yaml
pipelines:
  default:
    - step:
        image: drakemazzy/ddk-coder:latest
        name: Code Quality
        script:
          - phpcs --standard=/opt/coder/phpcs.xml ./src
```

With custom configuration:

```yaml
pipelines:
  default:
    - step:
        image: drakemazzy/ddk-coder:latest
        name: Code Quality
        artifacts:
          - phpcs.xml
        script:
          - cp ./build/phpcs.xml /opt/coder/phpcs.xml
          - phpcs ./src
```

#### GrumPHP Integration

1. Install GrumPHP in your project:
```bash
composer require --dev phpro/grumphp
```

2. Configure GrumPHP (`grumphp.yml`):
```yaml
grumphp:
  tasks:
    phpcs:
      standard: /opt/coder/phpcs.xml
      triggered_by: [php]
      whitelist_patterns:
        - /^src\/(.*)/
        - /^tests\/(.*)/
  docker:
    image: drakemazzy/ddk-coder:latest
    workdir: /tmp
    volumes:
      - ${PWD}:/tmp
```

3. Run GrumPHP:
```bash
docker run --rm -v $(pwd):/tmp drakemazzy/ddk-coder:latest vendor/bin/grumphp run
```

#### Pre-commit Hook with GrumPHP

Add to your `.git/hooks/pre-commit`:

```bash
#!/bin/sh
docker run --rm -v $(pwd):/tmp drakemazzy/ddk-coder:latest vendor/bin/grumphp git:pre-commit
```

Make the hook executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Build Arguments

The image supports the following build arguments:

| Argument     | Description      | Default     |
| ------------ | ---------------- | ----------- |
| PHP_VER      | PHP version      | 84          |
| COMPOSER_VER | Composer version | 2.8.9       |
| CODER_VER    | Coder version    | 8.3.30      |
| BUILD_VER    | Build version    | git SHA     |
| BUILD_DATE   | Build date       | Current UTC |

## Multi-Platform Support

The image is available for the following platforms:
- linux/amd64
- linux/arm64

## Security Features

This image includes:
- SBOM (Software Bill of Materials)
- Build provenance
- Trivy security scanning

## Development

### Prerequisites

- Docker
- Docker Buildx
- GitHub Actions Runner (for CI/CD)

### Local Build

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t drakemazzy/ddk-coder:latest .
```

## License

This project is released under the **GNU General Public License v2.0** (as provided by GitHub), with the "or (at your option) any later version" clause, because `pfrenssen/coder` is licensed under GPL-2.0-or-later.

In short:

> This program is free software; you can redistribute it and/or modify
> it under the terms of the GNU General Public License version 2
> (or at your option) any later version.

For more details, see the [LICENSE](./LICENSE) file in this repository or the [official GPL v2 text](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any problems or have suggestions, please open an issue in the GitHub repository.
