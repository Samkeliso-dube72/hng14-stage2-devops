# -------- Stage 1: Builder --------
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

# Install dependencies into isolated directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -------- Stage 2: Runtime --------
FROM python:3.12-slim

WORKDIR /app

# Install curl for healthcheck (fixed for hadolint)
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN adduser --disabled-password --no-create-home appuser

# Copy installed packages
COPY --from=builder /install /usr/local

# Copy application code
COPY . .

# Set permissions
RUN chown -R appuser:appuser /app

# Switch user
USER appuser

# Expose port
EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
CMD curl --fail http://localhost:8000/health || exit 1

# Start API
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]