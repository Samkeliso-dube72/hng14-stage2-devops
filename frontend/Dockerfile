# =========================
# STAGE 1 — BUILDER
# =========================
FROM node:18-alpine AS builder

WORKDIR /app

# Copy only dependency files first
COPY package*.json ./

# Install ONLY production dependencies
RUN npm ci --omit=dev

# Copy rest of source code
COPY . .


# =========================
# STAGE 2 — RUNTIME
# =========================
FROM node:18-alpine

WORKDIR /app

# Install wget for healthcheck
RUN apk add --no-cache wget

# Create non-root user
RUN addgroup -S app && adduser -S app -G app

# Copy ONLY what is needed from builder
COPY --from=builder /app /app

# Set permissions
RUN chown -R app:app /app

# Switch to non-root
USER app

# Expose port
EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
CMD wget --quiet --tries=1 --spider http://localhost:3000 || exit 1

# Start app
CMD ["npm", "start"]