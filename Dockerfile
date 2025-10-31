# Stage 1: Build the Angular app
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application source code
COPY . .

# Copy the environment file (for example, .env)
# Make sure .env is in your project root
COPY .env .env

# Build the Angular app in production mode
RUN npm run build --configuration production

# Stage 2: Serve the app with NGINX
FROM nginx:alpine

# Copy built Angular app to NGINX’s html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom NGINX configuration (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the environment file (if needed for runtime)
# If you plan to use the .env at runtime via JS injection, keep it here
COPY --from=build /app/.env /usr/share/nginx/html/.env

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
