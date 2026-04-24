# -------- Stage 1: Build --------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm install --only=production

# Copy source code
COPY . .

# -------- Stage 2: Runtime --------
FROM node:18-alpine

WORKDIR /app

# Install wget for healthcheck
RUN apk add --no-cache wget

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy app
COPY --from=builder /app /app

# Set permissions
RUN chown -R appuser:appgroup /app

# Switch user
USER appuser

# Expose port
EXPOSE 3000

# Health check (FIXED)
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
CMD wget --quiet --tries=1 --spider http://localhost:3000 || exit 1

# Start app
CMD ["npm", "start"]