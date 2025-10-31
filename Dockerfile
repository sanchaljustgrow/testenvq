# ---------- Stage 1: Build Angular App ----------
FROM node:20 AS build

WORKDIR /app

# Copy dependency files and install
COPY package*.json ./
RUN npm install

# Copy all source code
COPY . .

# Copy .env file explicitly (optional if it's already in the context)
COPY .env .env

# Build Angular app for production
RUN npm run build --configuration=production --output-path=dist/TestEnv

# ---------- Stage 2: Nginx Server ----------
FROM nginx:1.25-alpine

# Copy the build output to NGINX’s html directory
COPY --from=build /app/dist/TestEnv /usr/share/nginx/html

# Copy .env file (if you want it available at runtime)
COPY --from=build /app/.env /usr/share/nginx/html/.env

# Optional: Add a custom NGINX configuration
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
