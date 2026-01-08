# Security Policy

## Security Guidelines

To ensure the safety and integrity of the project, please follow these core security rules:

1.  **No Sensitive Information**: Never commit passwords, API keys, private tokens, or any other sensitive credentials to the repository. Use environment variables (e.g., `.env` files, which should be ignored by Git) instead.
2.  **Backup Before Cleanup**: Before running any cleanup scripts (like `conservative_cleanup.sh` or `custom_cleanup.sh`), ensure you have a full backup of all important data.
3.  **Validate Scripts**: Always review the contents of Shell scripts before execution, especially those requiring `sudo` or affecting system files.
4.  **Local Development**: For microservice development, prioritize local execution of the module you are working on and use Docker for dependencies to isolate the environment.

## Reporting a Vulnerability

If you discover a security vulnerability within this project, please do not open a public issue. Instead, report it through the appropriate private channel or contact the project maintainer directly.

## Rules & Best Practices

- Use `bash` for all scripts.
- Ensure all automated tasks follow the project rules defined in [.gemini/rules/project_rules.md](file:///Users/freeman/Documents/00-Project/claude_code/.gemini/rules/project_rules.md).
- Regularly check for outdated dependencies and documentation.
