# Nginx Docker scratch

This repo contain files for docker scratch container, which you can use as an example in your own project.


## Tools

For this proyect are require the follows tools:

- Docker 20+
- Git

## Steps

Clone the repo.
```bash
git clone https://github.com/mwlopez/nginx-docker-scratch.git
```

Execute docker build as follow

```bash
docker build -t nginx-scratch:0.0.1 .
```

Test the image
```bash
docker run -ti -p 80:80 nginx-scratch:0.0.1
```
