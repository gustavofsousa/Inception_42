FILE = ./srcs/docker-compose.yml

start:
	docker-compose -f $(FILE) start

up: $(FILE)
	docker-compose -f $(FILE) up -d

create: $(FILE)
	docker-compose -f $(FILE) build

images:
	docker images

remove:
	docker-compose -f $(FILE) down --remove-orphans
	docker volume rm -f srcs_DB srcs_wordpress_files

stop:
	docker-compose -f $(FILE) stop

status:
	docker-compose -f $(FILE) ps
	@echo "---"
	docker stats --no-stream $(SERVICES)

logs:
	@$(eval CONTAINERS := $(filter-out $@,$(MAKECMDGOALS)))
	docker-compose -f $(FILE) logs --tail 50 --follow --timestamps $(CONTAINERS)

run:
	@$(eval CONTAINER := $(filter-out $@,$(MAKECMDGOALS)))
	docker exec -it $(CONTAINER) /bin/bash

clean:
	docker rmi -f $$(docker images -a -q)

restart: remove clean up