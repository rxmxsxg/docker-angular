# Stage 1: Build Angular app
FROM node:18-alpine3.19 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build -- --configuration production

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy Angular build output (make sure folder name matches your app)
COPY --from=build /app/dist/my-app/browser /usr/share/nginx/html

# Optional: Custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
