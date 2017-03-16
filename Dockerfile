FROM centos

ENV ZK_HOSTS=localhost:2181 \
	ZK_PORT=2181 \
	ZK_PORT2=2888 \
	ZK_PORT3=3888 \
	KAFKA_PORT=9092 \
	KAFKA_VERSION=0.10.2.0 \
	KAFKA_DELETE_TOPIC_ENABLE=true \
	KAFKA_LOG_RETENTION_HOURS=1 \
    KAFKA_NUM_PARTITIONS=2 \
    KAFKA_DELETE_RETENTION_MS=1000 \
	SCALA_VERSION=2.12 \
	KM_PORT=9000 \
	KM_VERSION=1.3.3.4 \
	JAVA_VERSION=1.8.0
    
RUN yum -y install java-${JAVA_VERSION}-openjdk-headless tar wget unzip &&\
	cd /tmp &&\
	mkdir -p /opt/kafka/manager &&\
	curl -s http://apache.mesi.com.ar/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar -xz --strip-components=1 -C /opt/kafka &&\
	wget https://raw.githubusercontent.com/JuanyongZhang/kafkanetes/master/dist/kafka-manager-${KM_VERSION}.zip &&\
	unzip -d ./ ./kafka-manager-${KM_VERSION}.zip &&\
	mv ./kafka-manager-${KM_VERSION}/* /opt/kafka/manager/ &&\
	rm -fr ./kafka-manager-${KM_VERSION}* &&\
	yum clean all
	
COPY zookeeper-server-start-multiple.sh /opt/kafka/bin/
COPY start-kafka-manager.sh /opt/kafka/bin/

RUN chmod -R a=u /opt/kafka
WORKDIR /opt/kafka
VOLUME /tmp/kafka-logs /tmp/zookeeper
EXPOSE ${ZK_PORT} ${ZK_PORT2} ${ZK_PORT3} ${KAFKA_PORT} ${KM_PORT}

