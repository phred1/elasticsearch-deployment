From docker.elastic.co/elasticsearch/elasticsearch:7.6.1

RUN yum update -y && yum install wget -y
RUN yum install net-tools -y
RUN yum install -y \
       java-11-openjdk \
       java-11-openjdk-devel 

RUN wget http://download-keycdn.ej-technologies.com/jprofiler/jprofiler_linux_11_1.tar.gz -P /tmp/ &&\
 tar -xzf /tmp/jprofiler_linux_11_1.tar.gz -C /usr/local &&\
 rm /tmp/jprofiler_linux_11_1.tar.gz

ENV JPAGENT_PATH="-agentpath:/usr/local/jprofiler11.1/bin/linux-x64/libjprofilerti.so=nowait"
ENV JAVA_HOME /etc/alternatives/jre
USER elasticsearch
EXPOSE 8849
