# Variables
DOCKER_COMPOSE = docker compose
SRC_DIR = ./srcs

# Targets
all: build up

build:
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml build

up:
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml up -d

down:
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml down

clean: down
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml rm -f
	$(DOCKER_COMPOSE) -f $(SRC_DIR)/docker-compose.yml down --volumes

re: clean all
