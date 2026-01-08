# Smart Platform Project Rules

## Document Conventions
- **Naming**: Use Chinese for file names, technical terms in English (e.g., Docker, Antigravity). Use hyphens for separation (e.g., `Docker开发模式-快速参考.md`).
- **Structure**: Markdown format, clear table of contents, language tags for code blocks, and emoji markers (✅ ❌ ⚠️ 💡).
- **Maintenance**: Keep documents updated with the environment; note dates/versions for updates.

## Shell Scripting
- Use `bash`.
- Add execute permissions (`chmod +x`).
- Include error handling and clear comments.

## Smart Platform Architecture
- **System**: Port 48081
- **Infra**: Port 48082
- **Eng**: Port 48090
- **Gateway**: Port 48080
- **Frontend**: Port 30000

## Eng Module Development (zkjsplat-module-audit-eng)
- **Execution**: Only start the `eng` module in Antigravity to save memory. Use Docker for dependencies.
- **Tools**: Use Spring Boot Dashboard for management and `mvn spring-boot:run` as fallback.
- **Logging**: Focus on `eng` logs in the OUTPUT panel. Use `DEBUG` for `eng-module` and `WARN` for others in `application-local.yml`.
- **Hot Reload**: Use Spring Boot DevTools and `java.autobuild.enabled: true` for automatic restarts on save.
- **Debugging**: Use Debug mode (🐛) for breakpoints and variable inspection.

## Safety & Best Practices
- ⚠️ Do not submit sensitive info (passwords, keys).
- ⚠️ Back up data before running cleanup scripts.
- ✅ Verify document format after edits.
- ✅ Ensure code examples are runnable.
