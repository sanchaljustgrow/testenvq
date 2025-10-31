# Stage 1: Build Angular app
FROM node:20.19.0 AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci  # 'ci' is faster & more stable in CI/CD

COPY . .

RUN npm run build --configuration=production --output-path=dist/app

# Stage 2: Serve with Nginx
FROM nginx:1.25-alpine

COPY --from=build /app/dist/app /usr/share/nginx/html
COPY .env /usr/share/nginx/html/.env
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY src/assets/env.template.js /usr/share/nginx/html/assets/env.template.js

RUN chmod +x /docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
