# Stage 1: Build Angular app
FROM node:20.19.0 AS build

ARG NG_APP_URL
ENV NG_APP_URL=${NG_APP_URL}

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build --configuration=production --output-path=dist/TestEnv

# Stage 2: Serve with Nginx
FROM nginx:1.25-alpine

# Copy runtime env template
COPY src/runtime-env.js /usr/share/nginx/html/runtime-env.js

# Copy built Angular files from correct folder
COPY --from=build /app/dist/TestEnv /usr/share/nginx/html

# Replace environment variable placeholder at runtime
CMD ["/bin/sh", "-c", "envsubst '$NG_APP_URL' < /usr/share/nginx/html/runtime-env.js > /usr/share/nginx/html/assets/runtime-env.js && exec nginx -g 'daemon off;'"]

EXPOSE 80
