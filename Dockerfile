# ===========================
# Stage 1: Build Angular app
# ===========================
FROM node:20.19.0 AS build

# Define build-time argument (for CI/CD if needed)
ARG NG_APP_URL
ENV NG_APP_URL=${NG_APP_URL}

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build --configuration=production --output-path=dist/app

# ===========================
# Stage 2: Serve with Nginx
# ===========================
FROM nginx:1.25-alpine

# Copy runtime env template file (placed in the app root)
COPY src/runtime-env.js /usr/share/nginx/html/runtime-env.js

# Copy built Angular files
COPY --from=build /app/dist/app /usr/share/nginx/html/

# Replace env placeholder at container startup
CMD ["/bin/sh", "-c", "envsubst '$NG_APP_URL' < /usr/share/nginx/html/runtime-env.js > /usr/share/nginx/html/assets/runtime-env.js && exec nginx -g 'daemon off;'"]

EXPOSE 80
