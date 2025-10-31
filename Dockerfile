# Stage 1: Build Angular app
FROM node:20.19.0 AS build

WORKDIR /app
COPY package*.json ./
RUN npm install  # safer if package-lock.json missing

COPY . .
RUN npm run build --configuration=production --output-path=dist/app

# Stage 2: Serve with Nginx
FROM nginx:1.25-alpine

# Copy built Angular files to Nginx HTML directory
COPY --from=build /app/dist/app /usr/share/nginx/html

# Copy .env file to Nginx HTML directory
COPY .env /usr/share/nginx/html/.env

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
