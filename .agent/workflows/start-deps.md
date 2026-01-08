---
description: Start dependency services via Docker
---
// turbo-all
1. Navigate to the `smart-platform` project root directory.
2. Start the dependency services (System, Infra, Gateway) using Docker Compose:
```bash
docker-compose up -d system-service infra-service gateway-service
```
3. Verify that the services are running correctly:
```bash
docker-compose ps
```
4. If needed, view logs for a specific service:
```bash
docker-compose logs -f system-service
```
