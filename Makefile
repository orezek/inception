# Variables
DOCKER_COMPOSE = docker compose
DOCKER_STACK = docker stack
SRC_DIR = ./srcs
STACK_NAME = app_stack
VERSION = v1.0

USER_NAME = orezek
DATA_DIR = data
MYSQL_DATA = mysql_data
WP_DATA = wp_data

# Targets
all: build up

build:
	@mkdir -p ~/USER_NAME/DATA_DIR/MYSQL_DATA
	@mkdir -p ~/USER_NAME/DATA_DIR/WP_DATA
	@echo "Building Docker images..."
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml --env-file srcs/.env build


up:
	@echo "Starting containers up"
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml --env-file srcs/.env up

down:
	@echo "Stoping and removing containers..."
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml down

clean: down
	@echo "Cleaning up dangling resources..."
	docker system prune -af --volumes

fclean: clean
	@echo "Cleaning up all resources"
	@CONTAINERS=$$(docker ps -qa); if [ -n "$$CONTAINERS" ]; then docker stop $$CONTAINERS; fi
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/orezek/data/mysql_data/*
	@sudo rm -rf ~/orezek/data/wp_data/*
	@sudo rm -rf ~/orezek

re: clean all

# For validating docker compose yaml file
validate:
	@echo "Validating the docker-compose.yml configuration..."
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml config

