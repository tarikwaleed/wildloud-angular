# Stage 1: Build the Angular application
FROM node:18.17.1-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm install -g @angular/cli
RUN ng build

# Stage 2: Create the final nginx stage
FROM nginx:stable
COPY --from=builder /app/dist/application/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d
# Expose the port on which NGINX listens (optional)
EXPOSE 80

# The CMD in the final stage should be nginx, not npm
CMD ["nginx", "-g", "daemon off;"]