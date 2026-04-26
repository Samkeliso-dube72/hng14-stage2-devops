# hng14-stage2-devops
# HNG Stage 2 DevOps Project

## Overview
This project is a containerized microservices application made up of:

- Frontend (Node.js)
- API (FastAPI)
- Worker (Python)
- Redis (message broker)

The goal was to fix issues in the provided application, containerize all services, and implement a CI/CD pipeline.

---

## Prerequisites

- Docker
- Docker Compose
- Git

---

## Setup Instructions

### 1. Clone the Repository

```
git clone https://github.com/chukwukelu2023/hng14-stage2-devops.git 

cd hng14-stage2-devops
```

---

### 2. Create Environment File

Create a `.env` file in the root directory:

API_URL=http://localhost:8000  
REDIS_HOST=redis  
REDIS_PORT=6379  

---

### 3. Start the Application

docker compose up -d --build

---

### 4. Verify Containers

docker ps  

Expected services:
- frontend (port 3000)
- api (port 8000)
- worker
- redis

All containers should be **healthy**.

---

## Testing the Application

### Check API Health

curl http://localhost:8000/health  

Expected:
{"status":"ok"}

---

### Create a Job

curl -X POST http://localhost:8000/jobs  

---

### Check Job Status

curl http://localhost:8000/jobs/<job_id>  

Expected flow:
queued → completed

---

### Open Frontend

http://localhost:3000

---

## Docker Setup

- Each service has its own Dockerfile
- Services communicate via Docker network
- Redis is not exposed externally
- Health checks are configured for all services

---

## CI/CD Pipeline

Pipeline stages:

lint → test → build → security → integration → deploy

- Lint: flake8, eslint, hadolint
- Test: pytest with coverage
- Build: Docker images
- Security: Trivy scan
- Integration: full system test
- Deploy: rolling update simulation

---

## Fixes

All identified issues and fixes are documented in:

FIXES.md

---

## Final Status

- All services running successfully
- API working correctly
- Jobs processed end-to-end
- CI/CD pipeline passing all stages
