# backend/Dockerfile
FROM node:18-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
# If you have TS: RUN npm run build

FROM node:18-alpine
WORKDIR /usr/src/app
ENV NODE_ENV=production
COPY --from=builder /usr/src/app . 
RUN npm ci --only=production
EXPOSE 8080
CMD ["node", "server.js"]

