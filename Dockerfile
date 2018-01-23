FROM node:9.4.0-stretch


ENV PYTHON_PIP_VERSION 9.0.1
ENV AWS_CLI_VERSION 1.14.7
ENV CLOUD_SDK_VERSION 182.0.0
ENV WATCHMAN_VERSION 4.9.0
ENV DOCKER_VERSION 17.09.0~ce-0~debian
ENV DOCKER_COMPOSE_VERSION 1.17.0
ENV PATH /google-cloud-sdk/bin:$PATH
ENV GOOGLE_APPLICATION_CREDENTIALS /gcp-key.json

RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https gnupg2 software-properties-common python-dev python3-dev; \
    # Pip AND pip3
    wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
    python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION"; \
    python3 get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION"; \
    pip --version; \
    pip3 --version; \
    find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py; \
    # AWS CLI
    pip install awscli==${AWS_CLI_VERSION}; \
    aws --version; \
    # Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -; \
    apt-key fingerprint 0EBFCD88; \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable edge"; \
    apt-get update && apt-get install -y --no-install-recommends docker-ce=$DOCKER_VERSION; \
    docker --version; \
    # Docker Compose
    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; \
    chmod +x /usr/local/bin/docker-compose; \
    docker-compose --version; \
