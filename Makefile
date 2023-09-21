FILE = ./srcs/docker-compose.yml

all:
	@docker compose -f $(FILE) up -d --build

up:
	@docker compose -f $(FILE) up -d

down:
	@docker compose -f $(FILE) stop

re: clean all

clean:
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	sudo rm -rf ~/data/DB ~/data/wordpress_files
	@mkdir -p ~/data/DB ~/data/wordpress_files
#docker network rm $$(docker network ls -q);\

logs:
	@$(eval CONTAINERS := $(filter-out $@,$(MAKECMDGOALS)))
	docker-compose -f $(FILE) logs --tail 50 --follow --timestamps $(CONTAINERS)

run:
	@$(eval CONTAINER := $(filter-out $@,$(MAKECMDGOALS)))
	docker exec -it $(CONTAINER) /bin/bash

.PHONY: all re down clean