# Ubuntu 16.04 LTS
# Oracle Java 1.8.0_112-b15 64 bit
# Maven 3.3.9
# Jenkins 2.19.4
# git 2.7.4
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
ENV MAVEN_HOME /opt/apache-maven-3.3.9

# get maven 3.3.9
RUN wget --no-verbose -O /tmp/apache-maven-3.3.9.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz \
    # install maven
    && tar xzf /tmp/apache-maven-3.3.9.tar.gz -C /opt/ \
    && cp /opt/apache-maven-3.3.9/bin/* /usr/local/bin/ \
    && rm -f /tmp/apache-maven-3.3.9.tar.gz


# install git
RUN apt-get install -y git

# install nano
RUN apt-get install -y vim

# remove download archive files
RUN apt-get clean

# set shell variables for java installation
ENV java_version 1.8.0_112
ENV filename jdk-8u112-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u112-b15/$filename
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
ADD http://mirrors.jenkins.io/war-stable/2.19.4/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

# configure the container to run jenkins, mapping container port 8080 to that host port
ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080

VOLUME $JAVA_HOME $MAVEN_HOME $JENKINS_HOME

CMD [""]


