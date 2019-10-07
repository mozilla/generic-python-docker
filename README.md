[![CircleCI](https://circleci.com/gh/fbertsch/generic-python-docker.svg?style=svg)](https://circleci.com/gh/fbertsch/generic-python-docker)

# Generic Dockerized Python Application

This repository is meant to be a sample application. You can:
- Use pieces of this in existing projects
- Clone and edit for a new project

The goal is to remove boilerplate that goes along with dockerizing
a python application. At Mozilla, we expect these will largely
be run in GKE using Airflow.

## Cloning and Replacing

If you're going to clone this and start a new project, here's the parts you need to replace:
1. This `README.md`
2. The `hello-world` step in `Makefile`. You can simply remove it and use `make run COMMAND="python-application hello-world"`
   (replaced with what your app is called) instead
3. The `application.py` file (including the correponding runner in `__main__.py`,
   as well as the test in `tests/test_application.py`, and that test file's name)
4. The `APP_NAME` in `Dockerfile` (line 4)
5. The `setup.py` file (Start at line 17)

## Development and Testing

While iterating on development, we recommend using virtualenv
to run the tests locally.

### Run tests locally

Install requirements locally:
```
python3 -m virtualenv venv
source venv/bin/activate
make install-requirements
```

Run tests locally:
```
pytest tests/
```

### Run tests in docker

You can run the tests just as CI does by building the container
and running the tests.

```
make clean && make build
make test
```
