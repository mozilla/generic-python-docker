.PHONY: help clean clean-pyc clean-build list test coverage release

help:
	@echo "  clean-build -          Remove build artifacts"
	@echo "  clean-pyc -            Remove Python file artifacts"
	@echo "  lint -                 Check style with flake8"
	@echo "  test -                 Run tests quickly with the default Python"
	@echo "  install-requirements - install the requirements for development"
	@echo "  build                  Builds the docker images for the docker-compose setup"
	@echo "  docker-rm              Stops and removes all docker containers"
	@echo "  run                    Run a command. Can run scripts, e.g. make run COMMAND=\"./scripts/schema_generator.sh\""
	@echo "  shell                  Opens a Bash shell"

clean: clean-build clean-pyc docker-rm

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

lint:
	flake8 .

test:
	docker-compose run app test

install-requirements:
	pip install -r requirements/requirements.txt
	pip install -r requirements/test_requirements.txt

build:
	docker-compose build

docker-rm: stop
	docker-compose rm -f

shell:
	docker-compose run --entrypoint "/bin/bash" app

run:
	docker-compose run -e GCLOUD_SERVICE_KEY app $(COMMAND)

stop:
	docker-compose down
	docker-compose stop

hello-world:
	docker-compose run app python-application hello-world
