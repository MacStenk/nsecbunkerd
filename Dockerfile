FROM node:18

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --force

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
