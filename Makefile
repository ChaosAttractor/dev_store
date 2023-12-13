SHELL = /bin/sh
docker_bin := $(shell command -v docker 2> /dev/null)
docker_compose_bin := $(shell command -v docker-compose 2> /dev/null)
profiles=

.DEFAULT_GOAL := help

help: ## Просмотр всех команд
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "\n  Пример использования:\n  make init"

# --- [ Init ]  --------------------------------------------------------------------------------------------------------

init: init-repositories init-microservices right-folders up ## Инициализация проекта

init-repositories: ## Клонирование репозиториев и env
	mkdir -p services \
	&& mkdir -p postgres \
	&& mkdir -p postgres/pg \
	&& mkdir -p postgres/db_backups \
	&& sh ./scripts/cp-env.sh \
	&& sh ./scripts/git-clone.sh

init-microservices:  ## Инициализация микросервисов
	cd services/svc_store/ && make init

right-folders: ## Выдача прав на папки с сервисами для корректного запуска dev режима
	sudo chown -R $(USER):$(USER) services/ \
	&& sudo chown -R $(USER):$(USER) postgres/ \
	&& sudo chown -R $(USER):$(USER) services/svc_truck/app/ \

# --- [ Containers ]  --------------------------------------------------------------------------------------------------

build: ## Сборка docker контейнеров приложения
	$(docker_compose_bin) build

up: ## Сборка и поднятие docker контейнеров
	$(docker_compose_bin) -f docker-compose.yml up --remove-orphans

down: ## Удаление docker контейнеров
	$(docker_compose_bin) down

stop: ## Остановка docker контейнеров
	@$(docker_bin) ps -aq | xargs $(docker_bin) stop

# --- [ Web Client ]  --------------------------------------------------------------------------------------------------

npm-web-client: ## Установка npm зависимостей для Web клиента
	cd repositories/ui_store/client && npm i

dev-web-client: ## Запуск dev режима Web клиента
	cd repositories/ui_store/client && npm run dev
