FROM centos

ENV ZK_HOSTS=localhost:2181 \
	ZK_PORT=2181 \
	ZK_PORT2=2888 \
	ZK_PORT3=3888 \
	KAFKA_PORT=9092 \
	KM_PORT=9000 \
	KAFKA_VERSION=0.10.2.0 \
	SCALA_VERSION=2.12 \
    KM_VERSION=1.3.3.4

RUN mkdir -p /opt/kafka/manager \
  && cd /opt/kafka \
  && yum -y install java-1.8.0-openjdk-headless tar \
  && curl -s http://apache.mesi.com.ar/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar -xz --strip-components=1 \
  && wget https://github.com/yahoo/kafka-manager/archive/${KM_VERSION}.tar.gz \
  && tar xzf ${KM_VERSION}.tar.gz --strip-components=1 -C ./manager \
  && rm -rf ${KM_VERSION}.tar.gz
  && yum clean all
  
COPY zookeeper-server-start-multiple.sh /opt/kafka/bin/
COPY start-kafka-manager.sh /opt/kafka/bin/

RUN chmod -R a=u /opt/kafka
WORKDIR /opt/kafka
VOLUME /tmp/kafka-logs /tmp/zookeeper
EXPOSE ${ZK_PORT} ${ZK_PORT2} ${ZK_PORT3} ${KAFKA_PORT} ${KM_PORT}

