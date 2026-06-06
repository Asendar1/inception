*This project has been created as part of the 42 curriculum by hassende.*

## Description

Inception is a system administration project that virtualizes multiple Docker images inside a virtual machine. The goal is to set up a small infrastructure composed of several services, each running in its own Docker container, orchestrated with Docker Compose.

The stack includes:
- **NGINX** — TLSv1.3 reverse proxy (port 443)
- **WordPress + PHP-FPM** — CMS with Redis cache support
- **MariaDB** — relational database
- **Redis** — object cache for WordPress
- **Adminer** — database management GUI
- **FTP** — file access to WordPress files (vsftpd)
- **Static site** — personal showcase page (darkhttpd)
- **Mailpit** — SMTP email catcher for WordPress

## Instructions

### Prerequisites

- Linux / WSL2 virtual machine
- Docker and Docker Compose (v2) installed
- Sudo access for creating data directories
- Add your domain to `/etc/hosts`:
  ```
  127.0.0.1 hassende.42.fr
  ```

### Build and run

```sh
make          # setup → build → up
make build    # build images only
make up       # start containers
make stop     # stop containers
make clean    # stop and remove containers
make fclean   # stop, remove containers + volumes + images
make re       # full rebuild
```

### Access

| Service | URL |
|---------|-----|
| WordPress | https://hassende.42.fr |
| Adminer | http://localhost:8080 |
| Static site | http://localhost:8081 |
| Mailpit UI | http://localhost:8025 |
| Mailpit SMTP | localhost:1025 |

### Host data directories

```
/home/asendar1/data/mariadb    — database files
/home/asendar1/data/wordpress  — WordPress files
```

## Resources

### Documentation

- [Docker docs](https://docs.docker.com/)
- [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)
- [NGINX docs](https://nginx.org/en/docs/)
- [WordPress docs](https://wordpress.org/documentation/)
- [MariaDB docs](https://mariadb.com/kb/en/)
- [vsftpd](https://security.appspot.com/vsftpd.html)
- [Mailpit](https://github.com/axllent/mailpit)
- [42 subject PDF](./inception.pdf)

### AI usage

AI was used to:
- Draft Dockerfiles and entrypoint scripts
- Generate configuration files (nginx.conf, www.conf, vsftpd.conf)
- Write the static site HTML/CSS
- Structure and write documentation
- Refactor from environment variables to Docker secrets

## Project description

### Directory structure

```
.
├── Makefile
├── secrets/                      # Docker secrets (passwords)
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   ├── wp_user_password.txt
│   └── ftp_password.txt
├── srcs/
│   ├── .env                      # Non-sensitive env vars
│   ├── docker-compose.yml
│   └── subject/
│       ├── mariadb/              # MariaDB Dockerfile + config
│       ├── nginx/                # NGINX Dockerfile + SSL + config
│       ├── wp/                   # WP Dockerfile + PHP-FPM config
│       └── bonus/
│           ├── adminer/
│           ├── redis/
│           ├── static-site/
│           ├── ftp/
│           └── mailpit/
```

### Virtual Machines vs Docker

| Aspect | Virtual Machine | Docker |
|--------|----------------|--------|
| OS | Full guest OS per VM | Shares host kernel |
| Startup | Minutes | Seconds |
| Size | GBs per VM | MBs per image |
| Isolation | Hardware-level | Process-level |

Docker is lighter and faster, making it ideal for microservices. VMs provide stronger isolation for multi-tenant scenarios.

### Secrets vs Environment Variables

Environment variables are visible via `docker inspect`, logs, and `/proc`. Docker secrets are mounted as files at `/run/secrets/<name>` and are only accessible inside the container that explicitly requests them. Secrets are also not exposed through the Docker API.

### Docker Network vs Host Network

Docker Network creates an isolated virtual network where containers communicate by service name. Host network binds containers directly to the host's network stack — faster but removes isolation and can cause port conflicts.

### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker, stored in `/var/lib/docker/volumes/`, and portable across hosts. Bind mounts map a host directory directly into the container. Volumes are preferred for production because they are easier to back up, migrate, and manage via Docker CLI.
