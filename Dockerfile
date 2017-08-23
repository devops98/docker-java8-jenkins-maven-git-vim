# Ubuntu 16.04 LTS
# Oracle Java 1.8.0_144 64 bit
# Maven 3.3.9
# Jenkins 2.60.3
# docker 1.13.1
# docker-compose 1.16.0-rc1
# git latest
# Vim

# extend the most recent long term support Ubuntu version
FROM ubuntu:16.04

MAINTAINER Liwei (http://wayearn.com, lw96@live.com)

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# update dpkg repositories
RUN apt-get update 

# install wget 
RUN apt-get install -y wget 

# ENV MAVEN_HOME /opt/maven
ENV MAVEN_NAME apache-maven-3.3.9
ENV MAVEN_HOME /opt/maven/

# get maven 3.3.9
RUN wget --no-verbose -O /tmp/$MAVEN_NAME.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    # install maven
    && mkdir /opt/maven \
    && tar -zxf /tmp/$MAVEN_NAME.tar.gz -C /opt/maven --strip-components=1 \
    && ln -s /opt/maven/bin/mvn /usr/local/bin \
    && rm -f /tmp/$MAVEN_NAME.tar.gz

# install git
RUN apt-get install -y git

RUN apt-get install -y  \
        ca-certificates \
		curl \
		openssl

# ENV Docker
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.13.1
ENV DOCKER_SHA256 97892375e756fd29a304bd8cd9ffb256c2e7c8fd759e12a55a6336e15100ad75

# docker
RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

# docker-compose 
RUN curl -L https://github.com/docker/compose/releases/download/1.16.0-rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \ 
    && chmod +x /usr/local/bin/docker-compose

# install nano
RUN apt-get install -y vim

# remove download archive files
RUN apt-get clean

# set shell variables for java installation 
ENV java_version 1.8.0_144
ENV filename jdk-8u144-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u144-b01/$filename
ENV JAVA_HOME /opt/java/jdk$java_version
ENV PATH $JAVA_HOME/bin:$PATH

# download java, accepting the license agreement
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  -O /tmp/$filename $downloadlink \
    # unpack java
    && mkdir /opt/java \
    && tar -zxf /tmp/$filename -C /opt/java/  \ 
    # configure symbolic links for the java and javac executables
    && update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 \
    && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000  

# copy jenkins war file to the container
ADD http://mirrors.jenkins.io/war-stable/2.60.3/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins



# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080

VOLUME $JAVA_HOME $MAVEN_HOME $JENKINS_HOME

CMD [""]


