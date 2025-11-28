# Stage 1: build
FROM node:18-alpine AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build   # simple build, no --prod

# Stage 2: serve with nginx
FROM nginx:stable-alpine
COPY --from=build /usr/src/app/dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

