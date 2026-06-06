# Variables
NAME          = inception
COMPOSE_FILE  = srcs/docker-compose.yml
DATA_DIR      = /home/asendar1/data

all: setup build up

setup:
	@echo "Configuring persistent host storage layer directories..."
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress

build:
	@echo "Building the multi-container"
	@docker compose -f $(COMPOSE_FILE) build

up:
	@echo "Launching the multi-container"
	@docker compose -f $(COMPOSE_FILE) up -d

stop:
	@echo "Suspending active containers"
	@docker compose -f $(COMPOSE_FILE) stop

start:
	@echo "Resuming suspended containers"
	@docker compose -f $(COMPOSE_FILE) start

clean:
	@echo "Removing all containers and networks defined in the compose file..."
	@docker compose -f $(COMPOSE_FILE) down

fclean: clean
	@echo "Cleaning volumes"
	@docker system prune -a --volumes -f
	@sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all setup build up stop start clean fclean re
