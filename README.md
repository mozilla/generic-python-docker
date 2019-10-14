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
1. `README.md`
2. Change the `python_application` directory to the name of your application
3. The `hello-world` step in `Makefile`. You can simply remove it and use `make run COMMAND="python-application hello-world"`
   (replaced with what your app is called) instead
4. `application.py` (including the correponding runner in `__main__.py`,
   as well as the test in `tests/test_application.py`, and that test file's name)
5. `APP_NAME` in `Dockerfile` (line 4)
6. `setup.py` file (Start at line 17)
7. The directory for linting in `.circleci/config.yml` (line 60)


## Setup for Deployment

This deploys using Dockerhub and CircleCI. To enable deployment:

1. Enable the project in circleci
2. Add the `DOCKER_USER`, `DOCKER_PASS`, and `DOCKERHUB_REPO` environment variables
   in the circleci UI (under `settings` -> `Environment Variables`)

**NOTE**: When running on Mozilla infrastructure, dataops can set these for your project. [Create a bug here](https://bugzilla.mozilla.org/enter_bug.cgi?component=Operations&product=Data%20Platform%20and%20Tools)

## Running GCP Jobs

Figuring out access credentials is hard. To test out GCP work, [you'll need to have a test project.](https://github.com/whd/gcp-quickstart)

Once you have one, create a new service account:
1. Create a new service account in the [BQ Console](console.cloud.bigquery.com/)
2. Give it access to the tools you need: e.g. BigQuery, GCS, Dataflow
3. Create a JSON key for that service account
4. Set that key locally as `GCLOUD_SERVICE_ACCOUNT`
5. Run your job using `make run ...`, which will automatically use that service account

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
