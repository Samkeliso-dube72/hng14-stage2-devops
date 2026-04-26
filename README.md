# HNG Stage 2 DevOps Project

## Overview
This project is a containerized microservices application consisting of:

- **Frontend** (Node.js)
- **API** (FastAPI)
- **Worker** (Python)
- **Redis** (Message Broker)

### Objectives
- Fix bugs in the provided application
- Containerize all services using best practices
- Implement a full CI/CD pipeline
- Ensure the system is production-ready and resilient

---

## Prerequisites

Ensure you have the following installed:

- Docker
- Docker Compose (v2+)
- Git

---

## Getting Started

### 1. Clone Your Fork

```bash
git clone https://github.com/chukwukelu2023/hng14-stage2-devops
cd hng14-stage2-devops
```

---

### 2. Set Up Environment Variables

Create a `.env` file in the root directory:

```bash
touch .env
```

Add the following:

```env
# API Configuration
API_HOST=0.0.0.0
API_PORT=8000

# Frontend Configuration
API_URL=http://api:8000

# Redis Configuration
REDIS_HOST=redis
REDIS_PORT=6379

# Worker Configuration
WORKER_CONCURRENCY=1
```

---

### 3. Start the Application

```bash
docker compose up -d --build
```

---

### 4. Verify Containers

```bash
docker ps
```

Expected running services:

- frontend (port 3000)
- api (port 8000)
- worker
- redis (internal only)

All containers should show **healthy** status.

---

## Testing the Application

### Check API Health

```bash
curl http://localhost:8000/health
```

Expected response:

```json
{"status":"ok"}
```

---

### Create a Job

```bash
curl -X POST http://localhost:8000/jobs
```

---

### Check Job Status

```bash
curl http://localhost:8000/jobs/<job_id>
```

Expected flow:

```
queued → completed
```

---

### Access Frontend

Open in browser:

```
http://localhost:3000
```

---

## Docker Setup

- Each service has its own **Dockerfile**
- Uses **multi-stage builds**
- Runs as **non-root user**
- Includes **HEALTHCHECK**
- Services communicate via a **shared Docker network**
- Redis is **not exposed externally**
- Uses **environment variables only** (no hardcoding)
- CPU and memory limits configured in `docker-compose.yml`

---

## CI/CD Pipeline

Pipeline stages (in order):

```
lint → test → build → security → integration → deploy
```

### Lint
- flake8 (Python)
- eslint (JavaScript)
- hadolint (Dockerfiles)

### Test
- pytest with Redis mocked
- Coverage report generated and uploaded

### Build
- Docker images built and tagged (`latest` + git SHA)
- Pushed to local registry

### Security
- Trivy scan
- Fails on CRITICAL vulnerabilities
- SARIF report uploaded

### Integration
- Full stack runs inside CI
- Job submitted and verified end-to-end

### Deploy
- Runs only on `main`
- Rolling update strategy
- Health check validation (60s timeout)
- Rollback on failure

---

## Environment Example File

Create `.env.example`:

```env
API_HOST=0.0.0.0
API_PORT=8000
API_URL=http://api:8000
REDIS_HOST=redis
REDIS_PORT=6379
WORKER_CONCURRENCY=1
```

---

## Fixes Documentation

All identified bugs and fixes are documented in:

```
FIXES.md
```

Each entry includes:
- File name
- Line number
- Issue description
- Fix applied

---

## Final Status

- All services running successfully
- API responding correctly
- Jobs processed end-to-end
- Redis communication working
- Containers healthy
- CI/CD pipeline passing all stages

---

## Notes

- `.env` is NOT committed (as required)
- `.env.example` is provided for reference
- No secrets are hardcoded anywhere
- Project is fully reproducible on a clean machine