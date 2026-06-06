# User documentation

## Services provided

| Service | Purpose | How to access |
|---------|---------|---------------|
| WordPress | Content management system | https://hassende.42.fr |
| MariaDB | Database backend | Internal (no direct access) |
| Adminer | Database admin panel | http://localhost:8080 |
| Redis | WordPress object cache | Internal (no direct access) |
| FTP | File access to WordPress files | ftp://localhost:21 |
| Static site | Personal showcase page | http://localhost:8081 |
| Mailpit | SMTP email catcher | UI: http://localhost:8025, SMTP: localhost:1025 |

## Starting and stopping

From the project root:

```sh
# Start everything
make

# Stop (containers stay, can resume)
make stop

# Resume
make start

# Full cleanup (removes containers, volumes, images)
make fclean
```

## Accessing the website

1. Ensure `hassende.42.fr` resolves to `127.0.0.1` in `/etc/hosts`
2. Open https://hassende.42.fr in a browser
3. The WordPress admin panel is at https://hassende.42.fr/wp-admin

## Credentials

All passwords are stored in Docker secrets inside `/run/secrets/` within each container. They are not exposed as environment variables.

### WordPress

| Role | Username | Password location |
|------|----------|-------------------|
| Administrator | hamzah_boss | `secrets/wp_admin_password.txt` |
| Author | regular_subscriber | `secrets/wp_user_password.txt` |

### MariaDB

| User | Purpose | Password location |
|------|---------|-------------------|
| hasendar | WordPress database user | `secrets/db_password.txt` |
| root | Database root | `secrets/db_root_password.txt` |

### FTP

| User | Password location |
|------|-------------------|
| ftp_user | `secrets/ftp_password.txt` |

## Checking service status

```sh
# List all running containers
docker ps

# Check logs for a specific service
docker compose -f srcs/docker-compose.yml logs <service>

# Check logs for all services
docker compose -f srcs/docker-compose.yml logs

# Quick health check
docker compose -f srcs/docker-compose.yml ps
```

Replace `<service>` with: `nginx`, `wordpress`, `mariadb`, `redis`, `adminer`, `static-site`, `ftp`, or `mailpit`.
