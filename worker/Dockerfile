# -------- Stage 1: Builder --------
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# -------- Stage 2: Runtime --------
FROM python:3.12-slim

WORKDIR /app

# Install pgrep
RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN adduser --disabled-password --no-create-home appuser

# Copy dependencies
COPY --from=builder /install /usr/local

# Copy code
COPY . .

# Permissions
RUN chown -R appuser:appuser /app

# Switch user
USER appuser

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
CMD pgrep -f worker.py || exit 1

# Start worker
CMD ["python", "worker.py"]