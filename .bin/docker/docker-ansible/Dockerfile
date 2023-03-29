FROM ubuntu

ENV ANSIBLE_HOST_KEY_CHECKING False

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get install -y vim && \
    apt-get install -y sshpass && \
    apt-get install -y ansible

RUN mkdir /app
WORKDIR /app
CMD /bin/bash
