# Developer documentation

## Environment setup

### Prerequisites

- Linux VM or WSL2 (required by subject)
- Docker Engine 24+ and Docker Compose v2
- `sudo` access
- OpenSSL (for host-level verification)
- `curl`, `mysql-client` (optional, for testing)

### Hosts file

```sh
echo "127.0.0.1 hassende.42.fr" | sudo tee -a /etc/hosts
```

### Secrets

Create the secrets directory with password files:

```sh
mkdir -p secrets
# Each file contains the secret value (one line, no trailing newline needed)
echo "my_password" > secrets/db_password.txt
```

The project includes example secrets. In production, regenerate all passwords.

## Building and launching

### Quick start

```sh
make
```

This runs `make setup` (creates host data dirs), `make build` (builds images), and `make up` (starts containers).

### Step by step

```sh
# 1. Create host data directories
make setup

# 2. Build all Docker images
make build

# 3. Start containers in detached mode
make up

# 4. Verify
docker compose -f srcs/docker-compose.yml ps
```

### Makefile targets

| Target | Action |
|--------|--------|
| `all` | setup → build → up |
| `setup` | Create `/home/asendar1/data/{mariadb,wordpress}` |
| `build` | Build all images via docker-compose |
| `up` | Start containers in detached mode |
| `stop` | Stop containers without removing them |
| `start` | Restart stopped containers |
| `clean` | Stop and remove containers + network |
| `fclean` | Clean + remove all volumes/images + host data |
| `re` | fclean → all |

## Managing containers and volumes

### Container management

```sh
# Enter a running container
docker exec -it <container_name> sh

# View logs
docker compose -f srcs/docker-compose.yml logs -f <service>

# Rebuild a single service
docker compose -f srcs/docker-compose.yml build <service>

# Restart a single service
docker compose -f srcs/docker-compose.yml up -d --no-deps <service>
```

Container names: `nginx`, `wordpress`, `mariadb`, `redis`, `adminer`, `static-site`, `ftp`, `mailpit`

### Volume management

```sh
# List volumes
docker volume ls

# Inspect a volume
docker volume inspect mariadb_data
docker volume inspect wordpress_data

# Remove all unused volumes
docker volume prune
```

## Data persistence

### Host storage

```
/home/asendar1/data/mariadb/     — MariaDB data files
/home/asendar1/data/wordpress/   — WordPress uploads, plugins, themes
```

These directories are created by `make setup` and are mapped into containers via Docker named volumes with a local driver.

### Inside containers

| Service | Mount path |
|---------|-----------|
| mariadb | `/var/lib/mysql` |
| wordpress | `/var/www/wordpress` |
| nginx | `/var/www/wordpress` (read-only for serving) |
| ftp | `/var/www/wordpress` (read-write for file management) |

### Secrets

Stored in `secrets/` at the project root (gitignored). Each secret file maps to `/run/secrets/<name>` inside the relevant container.
