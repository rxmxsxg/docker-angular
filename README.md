# docker-angular

angular deployment in docker

docker run -it <your-image-id>
docker build -t your-app .
docker images
docker build -t your-app:your-tag .
docker rm <container-id>
docker rmi <container-id>
docker kill <your-container-id>
==========================================
docker images

REPOSITORY TAG IMAGE ID CREATED SIZE
hello-world latest d1165f221234 2 weeks ago 13.3kB

docker rmi hello-world / docker rmi d1165f221234

Force Delete
docker rmi -f hello-world

1. Remove a specific container
   docker rm ba8dadfb0011

2. Remove all stopped containers at once
   docker container prune

Remove Image too
docker rmi hello-world

Remove the container that's using the image
docker rm 543995f3100d

Then remove the image
docker rmi 74cc54e27dc4

Let’s debug inside the container:
Run the container with a shell:
docker run -it angular17-app sh
ls -l /usr/share/nginx/html

Check Nginx logs
docker logs <container_id>
=======================================================

# Stage 1: Build Angular App

FROM node:18-alpine as build

WORKDIR /app

COPY package\*.json ./
RUN npm install

COPY . .
RUN npm run build -- --configuration production

# Stage 2: Serve app with Nginx

FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/\*

# 🧠 Adjusted copy path here

COPY --from=build /app/dist/my-app/browser /usr/share/nginx/html

# Optional: Custom Nginx config for routing

# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

==================================================================
currently running Docker containers
docker ps

to see all containers, including stopped ones:
docker ps -a

To stop a running container:
docker stop <container_id_or_name>

To remove a container:
docker rm <container_id_or_name>

================================================================

# Stage 1: Build Angular app

FROM node:18-alpine3.19 AS build

WORKDIR /app

COPY package\*.json ./
RUN npm install

COPY . .
RUN npm run build -- --configuration production

# Stage 2: Serve with Nginx

FROM nginx:stable-alpine

# Remove default nginx static files

RUN rm -rf /usr/share/nginx/html/\*

# Copy Angular build output (make sure folder name matches your app)

COPY --from=build /app/dist/my-app/browser /usr/share/nginx/html

# Optional: Custom nginx config for SPA routing

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]

server {
listen 80;
server_name localhost;

root /usr/share/nginx/html;
index index.html;

location / {
try_files $uri $uri/ /index.html;
}

error_page 404 /index.html;
}
===================================================================
docker build -t angular17-app .
docker run -d -p 8080:80 angular17-app
