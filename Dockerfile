FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        libdigest-sha-perl \
        ca-certificates && \
    mkdir  -p /opt/jdk && \
    cd /opt/jdk/ && \
    wget https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz && \
    wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz.sha256 && \
    shasum --algorithm 256 jdk-17_linux-x64_bin.tar.gz.sha256 && \
    tar -xvzf openjdk-17.0.2_linux-x64_bin.tar.gz && \
    update-alternatives --install /usr/bin/java java /opt/jdk/jdk-17.0.2/bin/java 100

ENV JAVA_HOME /opt/jdk/jdk-17.0.2

ENV JRE_HOME /opt/jdk/jdk-17.0.2/jre


RUN groupadd -g 1000 elasticsearch && \
    useradd elasticsearch -u 1000 -g 1000

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends  \
        software-properties-common \
        gnupg && \
    apt-key adv --keyserver pgp.mit.edu --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 && \
    add-apt-repository -y "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" --keyserver https://pgp.mit.edu/ && \
    apt-get update && \
    apt-get install -y --no-install-recommends  \
        elasticsearch

WORKDIR /usr/share/elasticsearch

RUN set -ex &&  \
    for path in data logs config config/scripts; do \
      mkdir -p "$path"; \
      chown -R elasticsearch:elasticsearch "$path"; \
    done

COPY logging.yml /usr/share/elasticsearch/config/

COPY elasticsearch.yml /usr/share/elasticsearch/config/

USER elasticsearch

ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200 9300