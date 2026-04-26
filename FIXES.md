# Fixes Documentation

## Fix 1: Hardcoded API URL in Frontend

- File: frontend/app.js  
- Line: 6  

### Issue
The API URL was hardcoded as "http://localhost:8000".

### Why it’s a problem
- Requires modifying source code whenever the API location changes  
- Reduces flexibility and portability across environments  

### Fix
Replaced the hardcoded API URL with an environment variable:

const API_URL = process.env.API_URL;

Created a `.env` file and added:

API_URL=http://localhost:8000


---

## Fix 2: Missing Environment Variable Loader

- File: frontend/app.js  
- Line: 1  

### Issue
Environment variables defined in the `.env` file were not being loaded.

### Why it’s a problem
- The application could not access configuration values from `.env`  
- Breaks environment-based configuration  

### Fix
Added dotenv configuration loader at the top of the file:

require('dotenv').config();


---

## Fix 3: Worker hardcoded Redis host

- File: worker/worker.py  
- Line: 6  

### Issue
The Redis connection was hardcoded to "localhost".

### Why it’s a problem
- Inside Docker, "localhost" refers to the container itself  
- Prevents communication with the Redis service  

### Fix
Replaced with environment variables:

r = redis.Redis(
    host=os.getenv("REDIS_HOST", "localhost"),
    port=int(os.getenv("REDIS_PORT", 6379))
)


---

## Fix 4: Missing health endpoint in API

- File: api/main.py  
- Line: Last line  

### Issue
The `/health` endpoint was missing.

### Why it’s a problem
- Docker healthcheck returned `404 Not Found`  
- API container was marked as unhealthy  
- Dependent services failed to start  

### Fix
Added a `/health` route:

@app.get("/health")
def health():
    return {"status": "ok"}


---

## Fix 5: Frontend port conflict

- File: docker-compose.yml  

### Issue
Port 3000 was already in use on the host machine.

### Why it’s a problem
- Prevented frontend container from starting  

### Fix
Stopped the existing process using port 3000 before running Docker Compose


---

## Fix 6: Missing dotenv dependency in frontend

- File: frontend/package.json  

### Issue
The dotenv module was used but not listed as a dependency.

### Why it’s a problem
- Application failed at runtime with "Cannot find module 'dotenv'"  

### Fix
Installed dotenv and added it to dependencies:

npm install dotenv


# Fixes and Improvements

## 1. Redis Connection Fix
- Updated Redis host from `localhost` to `redis` for container networking
- Enabled `decode_responses=True` for proper string handling

---

## 2. API Bug Fix
- Removed duplicate `FastAPI()` instance that was overriding routes
- Restored `/jobs` endpoints functionality

---

## 3. Frontend Fix
- Added missing `dotenv` dependency to `package.json`
- Rebuilt frontend container successfully

---

## 4. Port Conflict Fix
- Resolved port `3000 already in use` by stopping existing Node process

---

## 5. Lint Fixes (CI Pipeline)
- Fixed Python lint errors (flake8):
  - Removed unused imports
  - Fixed spacing (E302, E305)
  - Fixed newline issues (W292, W391)

- Fixed ESLint issues:
  - Added `eslint.config.js`
  - Converted config to CommonJS format

- Fixed Dockerfile lint issues (Hadolint):
  - Added `--no-install-recommends`
  - Cleaned apt cache
  - Pinned curl version

---

## 6. Environment Configuration Fix
- Cleaned `.env` file (removed invalid entries like `venv/`, `node_modules/`)
- Moved ignored files to `.gitignore`

---

## 7. Docker Fixes
- Added root `Dockerfile` for CI linting
- Ensured all containers build successfully
- Verified health checks

---

## 8. System Integration Success
- Successfully ran full stack using `docker-compose`
- Verified:
  - API `/health` endpoint
  - Job creation (`POST /jobs`)
  - Job processing via worker
  - Job status updates (`queued → completed`)

---

## ✅ Final Status
- All containers running healthy
- Full system working end-to-end
- CI lint stage passing