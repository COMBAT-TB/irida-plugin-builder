FROM ubuntu:20.04 as builder
LABEL org.opencontainers.image.authors="Peter van Heusden <pvh@sanbi.ac.za>"

ENV IRIDA_TAG=21.05
RUN apt update && DEBIAN_FRONTEND="noninteractive" apt install -y default-jdk-headless maven git
RUN git clone --depth 1 -b $IRIDA_TAG https://github.com/phac-nml/irida.git && cd irida/lib && bash install-libs.sh && cd ..
RUN cd irida && mvn clean install -Djetty.skip=true -DskipTests
RUN cd /root/.m2/repository && apt install -y wget && wget https://github.com/phac-nml/irida-wf-ga2xml/releases/download/v1.1.0/irida-wf-ga2xml-1.1.0-standalone.jar 

FROM alpine:latest 
RUN apk update && apk add openjdk11-jre-headless maven
COPY --from=builder /root/.m2 /root/
RUN mkdir /root/.m2 && mv /root/repository /root/.m2/
RUN mv /root/.m2/repository/irida-wf-ga2xml-1.1.0-standalone.jar /
# RUN apk add python3 libxml2 libxslt bzip2 \
#     && apk add --virtual .build-deps py3-pip gcc make libxml2-dev libxslt-dev python3-dev musl-dev bzip2-dev \
#     && pip install ephemeris 
# COPY insert_tool_file.sh /insert_tool_file.sh
# RUN chmod +x /insert_tool_file.sh
