FROM python:3
MAINTAINER Frank Bertsch <frank@mozilla.com>

# Guidelines here: https://github.com/mozilla-services/Dockerflow/blob/master/docs/building-container.md
ARG USER_ID="10001"
ARG GROUP_ID="app"
ARG HOME="/app"

ENV HOME=${HOME}
RUN groupadd --gid ${USER_ID} ${GROUP_ID} && \
    useradd --create-home --uid ${USER_ID} --gid ${GROUP_ID} --home-dir /app ${GROUP_ID}

# List packages here
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        file        \
        gcc         \
        libwww-perl && \
    apt-get autoremove -y && \
    apt-get clean

# Upgrade pip
RUN pip install --upgrade pip

WORKDIR ${HOME}

ADD requirements requirements/
RUN pip install -r requirements/requirements.txt
RUN pip install -r requirements/test_requirements.txt

ADD . ${HOME}/python-application

RUN pip install -e ${HOME}/python-application

# Drop root and change ownership of the application folder to the user
RUN chown -R ${USER_ID}:${GROUP_ID} ${HOME}
USER ${USER_ID}

ENTRYPOINT ["/app/python-application/bin/entrypoint"]
