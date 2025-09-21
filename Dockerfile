FROM nginx:alpine
COPY site/ /usr/share/nginx/html/
HEALTHCHECK CMD wget -qO- http://localhost/ || exit 1
EXPOSE 80
