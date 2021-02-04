FROM ubuntu:20.04 as builder
MAINTAINER Peter van Heusden <pvh@sanbi.ac.za>

ENV IRIDA_TAG=21.01
RUN apt update && apt install -y default-jdk-headless maven git
RUN git clone --depth 1 -b $IRIDA_TAG https://github.com/phac-nml/irida.git && cd irida/lib && bash install-libs.sh && cd ..
RUN cd irida && mvn clean install -Djetty.skip=true -DskipTests
RUN cd /root/.m2/repository && apt install -y wget && wget https://github.com/phac-nml/irida-wf-ga2xml/releases/download/v1.1.0/irida-wf-ga2xml-1.1.0-standalone.jar 

FROM alpine:latest
RUN apk update && apk add openjdk11-jre-headless maven
COPY --from=builder /root/.m2 /root/
RUN mkdir /root/.m2 && mv /root/repository /root/.m2/
RUN mv /root/.m2/repository/irida-wf-ga2xml-1.1.0-standalone.jar /
