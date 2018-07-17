FROM ubuntu

RUN apt-get update
RUN apt-get -y install curl

COPY load.sh .
ENTRYPOINT ./load.sh