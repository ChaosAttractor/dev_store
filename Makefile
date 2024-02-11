SHELL = /bin/sh
docker_bin := $(shell command -v docker 2> /dev/null)

.DEFAULT_GOAL := help

help: ## Просмотр всех команд
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "\n  Пример использования:\n  make init"

# --- [ Init ]  --------------------------------------------------------------------------------------------------------

init: init-repositories init-microservices right-folders up ## Инициализация проекта

init-repositories: ## Клонирование репозиториев и env
	sudo chown -R $(USER):$(USER) ../dev_store \
    && mkdir -p keycloak || true\
	&& mkdir -p services || true\
	&& mkdir -p postgres || true\
	&& mkdir -p postgres/pg || true\
	&& mkdir -p postgres/db_backups || true\
	&& sudo chown -R $(USER):$(USER) keycloak/ \
	&& sh ./scripts/copy-env.sh \
	&& sh ./scripts/git-clone.sh

init-microservices:  ## Инициализация микросервисов
	cd services/svc_store/ && make init

right-folders: ## Выдача прав на папки с сервисами для корректного запуска dev режима
	sudo chown -R $(USER):$(USER) services/ \
	&& sudo chown -R $(USER):$(USER) postgres/ \
	&& sudo chown -R $(USER):$(USER) keycloak/ \
	&& sudo chown -R $(USER):$(USER) services/svc_store/app/ \

# --- [ Containers ]  --------------------------------------------------------------------------------------------------

build: ## Сборка docker контейнеров приложения
	$(docker_bin) compose build

up: ## Сборка и поднятие docker контейнеров
	$(docker_bin) compose -f docker-compose.yml up --remove-orphans

down: ## Удаление docker контейнеров
	$(docker_bin) compose down

stop: ## Остановка docker контейнеров
	@$(docker_bin) ps -aq | xargs $(docker_bin) stop

# --- [ Web Client ]  --------------------------------------------------------------------------------------------------

npm-front: ## Установка npm зависимостей для Web клиента
	cd services/ui_store/ && npm i

dev-front: ## Запуск dev режима Web клиента
	cd services/ui_store/ && npm run dev
