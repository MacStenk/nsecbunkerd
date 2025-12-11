FROM node:18-alpine

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source
COPY . .

# Build
RUN pnpm run build

# Run prisma migrations
RUN npx prisma generate

# Create config directory
RUN mkdir -p /app/config

EXPOSE 3000

CMD ["node", "dist/index.js"]
