host a static website with Docker and build/run the image.

![Build](https://github.com/atulkamble/docker-basic-website/actions/workflows/docker-publish.yml/badge.svg)


# 1) Project structure

```
basic-website/
├─ Dockerfile
├─ .dockerignore
└─ site/
   └─ index.html
```

# 2) Files

**Dockerfile**

```dockerfile
# Use a tiny, production-ready web server
FROM nginx:alpine

# Copy your static site into Nginx's default web root
COPY site/ /usr/share/nginx/html/

# (Optional) Health check
HEALTHCHECK CMD wget -qO- http://localhost/ || exit 1

# Nginx listens on 80
EXPOSE 80

# Default nginx start command is already defined in base image
```

**.dockerignore**

```
.git
.gitignore
README.md
*.log
node_modules
dist
```

**site/index.html**

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>My Docker Website</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
      body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial; margin: 2rem; }
      .card { max-width: 720px; margin: auto; padding: 2rem; border: 1px solid #e5e7eb; border-radius: 12px; }
      h1 { margin-top: 0; }
      code { background: #f3f4f6; padding: 2px 6px; border-radius: 6px; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>🚀 Deployed with Docker + Nginx (Alpine)</h1>
      <p>If you can see this page, your containerized website is running.</p>
      <p>Try building the image with:<br><code>docker build -t mysite:1.0 .</code></p>
    </div>
  </body>
</html>
```

# 3) Build the image

```bash
cd basic-website
docker build -t mysite:1.0 .
```

# 4) Run the container

```bash
# Map host port 8080 -> container port 80
docker run -d --name mysite -p 8080:80 mysite:1.0

# Open in browser
# http://localhost:8080
```

# 5) Stop & clean up

```bash
docker ps
docker logs mysite --tail 100
docker stop mysite && docker rm mysite
```

# (Optional) docker-compose

If you prefer `docker-compose`, add this file at the project root:

**docker-compose.yml**

```yaml
services:
  web:
    image: mysite:1.0
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    container_name: mysite
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost/"]
      interval: 10s
      timeout: 2s
      retries: 3
      start_period: 5s
```

Run:

```bash
docker compose up -d --build
docker compose logs -f
```

# (Optional) Push to Docker Hub

```bash
# login
docker login

# tag with your Docker Hub username
docker tag mysite:1.0 atuljkamble/mysite:1.0

# push
docker push atuljkamble/mysite:1.0
```

That’s it—super light, production-safe (nginx\:alpine)
