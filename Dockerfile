FROM node:18

WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies with npm (not pnpm)
RUN npm install --legacy-peer-deps

# Copy source
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Build
RUN npm run build

# Create config directory
RUN mkdir -p /app/config

EXPOSE 3000

CMD ["node", "./scripts/start.js", "start", "--keys", "steven"]
