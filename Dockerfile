FROM node:18-alpine

# Install OpenSSL and build tools for native modules
RUN apk add --no-cache openssl openssl-dev python3 make g++

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies (rebuild native modules)
RUN pnpm install --force

# Rebuild bcrypt for Alpine
RUN pnpm rebuild bcrypt

# Copy source
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Build
RUN pnpm run build

# Create config directory
RUN mkdir -p /app/config

EXPOSE 3000

CMD ["node", "./scripts/start.js", "start"]
