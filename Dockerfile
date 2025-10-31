# Stage 1: Build the Angular app
FROM node:18 AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all source files including .env
COPY . .

# Build the Angular app for production
RUN npm run build --configuration=production --output-path=dist/app

# Stage 2: Serve with Nginx
FROM nginx:1.25-alpine

# Copy built Angular app from build stage
COPY --from=build /app/dist/app /usr/share/nginx/html

# Copy Nginx configuration (optional if you have one)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy .env file into the container (optional, for runtime scripts or debugging)
COPY .env /usr/share/nginx/html/.env

# Optionally copy a runtime env loader script if your Angular app supports it
# e.g. load environment variables dynamically at runtime
# COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

# Expose Nginx default port
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
