FILE = ./srcs/docker-compose.yml

all:
	@sudo mkdir -p /home/data_inception/DB /home/data_inception/wordpress_files
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
	sudo rm -rf /home/data_inception

logs:
	@$(eval CONTAINERS := $(filter-out $@,$(MAKECMDGOALS)))
	docker-compose -f $(FILE) logs --tail 50 --follow --timestamps $(CONTAINERS)

run:
	@$(eval CONTAINER := $(filter-out $@,$(MAKECMDGOALS)))
	docker exec -it $(CONTAINER) /bin/bash

status: ${FILE}
	@docker compose -f ${FILE} ps 
	@echo "---"
	@docker stats --no-stream ${SERVICES}

.PHONY: all re down clean
