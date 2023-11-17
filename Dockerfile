FROM nginx:latest
RUN echo "Hello Kubernetes" > /usr/share/nginx/html/index.html
