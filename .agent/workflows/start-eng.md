---
description: Start the Eng module locally
---
1. Open the `smart-platform` project in Antigravity or navigate to its root directory in the terminal.
2. In the Spring Boot Dashboard, locate `EngApplication` and click ▶️ **Run** or 🐛 **Debug**.
3. Alternatively, run the following command in the terminal from the `smart-platform` root:
```bash
mvn spring-boot:run -pl zkjsplat-module-audit-eng/zkjsplat-module-audit-eng-biz -Dspring-boot.run.profiles=local
```
4. Check the logs in the **OUTPUT** panel or terminal to ensure the module has started successfully.
