# Stage 1: Build
FROM node:24-slim AS builder    # use current LTS instead of node:16-slim
WORKDIR /app

COPY package*.json ./
RUN npm install                  # or: npm ci

COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:24-slim AS final
WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev       # only production deps (npm v7+)

# Copy only the build output from the builder stage
COPY --from=builder /app/build ./build

EXPOSE 3000
CMD ["npm", "start"]

