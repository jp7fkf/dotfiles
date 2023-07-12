#FROM ubuntu
#
#ENV ANSIBLE_HOST_KEY_CHECKING False
#
#RUN apt-get update && \
#    apt-get install -y software-properties-common && \
#    apt-get install -y vim && \
#    apt-get install -y sshpass && \
#    apt-get install -y ansible
#
#RUN mkdir /app
#WORKDIR /app
#CMD /bin/bash
#
#
FROM python:3
USER root

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

RUN apt-get install -y vim less
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools

RUN python -m pip install pytest requests pyyaml
