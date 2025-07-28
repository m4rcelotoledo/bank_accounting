# Makefile Documentation

## Overview

This Makefile provides a comprehensive set of commands for managing the Bank Accounting API project. It replaces the individual shell scripts with a unified, cross-platform solution.

## Quick Start

```bash
# Show all available commands
make help

# Setup development environment
make setup

# Start the server
make server

# Run tests
make test
```

## Available Commands

### Development Commands

| Command | Description |
|---------|-------------|
| `make setup` | Initialize the development environment |
| `make server` | Start the Rails server |
| `make console` | Open Rails console |
| `make shell` | Open shell in running container |

### Testing Commands

| Command | Description |
|---------|-------------|
| `make test` | Run all tests |
| `make test-file FILE=path` | Run specific test file |
| `make coverage` | Run tests with coverage report |

### Quality Commands

| Command | Description |
|---------|-------------|
| `make lint` | Run RuboCop code analysis |
| `make security` | Run security checks |
| `make quality` | Run all quality checks |

### Docker Commands

| Command | Description |
|---------|-------------|
| `make build` | Build Docker images |
| `make stop` | Stop all containers |
| `make clean` | Clean containers and volumes |
| `make reset` | Clean and setup environment |
| `make logs` | Show application logs |
| `make status` | Show container status |

### Database Commands

| Command | Description |
|---------|-------------|
| `make db-setup` | Setup database |
| `make db-reset` | Reset database |
| `make db-seed` | Seed database |

### Bundle Commands

| Command | Description |
|---------|-------------|
| `make bundle-install` | Install gems |
| `make bundle-update` | Update gems |

### Utility Commands

| Command | Description |
|---------|-------------|
| `make maintenance` | Run maintenance tasks |
| `make production-check` | Run production checks |
| `make dev` | Setup and start server |
| `make quick-test` | Run lint and tests |

## Examples

### Running Specific Tests

```bash
# Run a specific test file
make test-file FILE=spec/requests/accounts_spec.rb

# Run a specific test line
make test-file FILE=spec/requests/accounts_spec.rb:25
```

### Development Workflow

```bash
# Complete development setup
make dev

# Quick quality check
make quick-test

# Full quality check
make quality
```

### Docker Management

```bash
# Clean environment
make clean

# Reset everything
make reset

# Check container status
make status
```

## Migration from Scripts

The Makefile replaces the following scripts:

| Old Script | New Makefile Command |
|------------|---------------------|
| `script/setup` | `make setup` |
| `script/server` | `make server` |
| `script/console` | `make console` |
| `script/test` | `make test` |
| `script/pre_commit` | `make quality` |
| `script/clean` | `make clean` |
| `script/reset` | `make reset` |

## Benefits

1. **Cross-platform compatibility** - Works on Linux, macOS, and Windows
2. **Unified interface** - All commands in one place
3. **Better documentation** - Self-documenting with `make help`
4. **Consistent behavior** - Standardized command execution
5. **Easy to extend** - Simple to add new commands

## Troubleshooting

### Common Issues

1. **Permission denied**: Ensure the Makefile has execute permissions
2. **Command not found**: Make sure `make` is installed on your system
3. **Docker not running**: Start Docker before running container commands

### Getting Help

```bash
# Show all available commands
make help

# Show specific command help
make -n <command>
```

## Contributing

When adding new commands to the Makefile:

1. Add the command to the appropriate section
2. Update the help text
3. Test the command thoroughly
4. Update this documentation
