FILE		= ./srcs/docker-compose.yml
SERVICES	= mariadb nginx wordpress

start: ${FILE}
	@docker compose -f ${FILE} start

clean:
	docker rm -f $$(docker ps -a -q)
	docker rmi -f $$(docker images -a -q)

stop:	${FILE}
	docker compose -f ${FILE} stop

status:	${FILE}
	@docker compose -f ${FILE} ps 
	@echo "---"
	@docker stats --no-stream ${SERVICES}

logs:
	@$(eval CONTAINERS := $(filter-out $@,$(MAKECMDGOALS)))
	@docker compose -f ${FILE} logs --tail 50 --follow --timestamps ${CONTAINERS} 

run:
	@$(eval CONTAINER := $(filter-out $@,$(MAKECMDGOALS)))
	@docker exec -it ${CONTAINER} /bin/bash 