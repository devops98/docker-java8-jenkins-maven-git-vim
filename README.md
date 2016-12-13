docker-java8-jenkins-maven-git-nano
===================================

This repository provides the Dockerfile that builds a continuous integration container from Ubuntu 16.04 LTS.

* Ubuntu 16.04 LTS
* Oracle Java 1.8.0_112-b15 64 bit
* Maven 3.3.9
* Jenkins 2.19.4
* git 2.7.4
* Vim 

Sets up a container with jenkins installed listening on port 8080.

Usage

To run the container with the same time zone as the host, do the following:

    sudo docker run -t -i -p 8080:8080 -v /etc/localtime:/etc/localtime:ro -P lw96/java8-jenkins-maven-git-vim

You can configure Jenkins continuous integration jobs at http://127.0.0.1:8080 .  

The Jenkins GitHub plugin needs to be installed by you if you use GitHub.

    MAVEN_HOME /opt/maven
    JAVA_HOME /opt/java-oracle/jdk/1.8.0_112
    JENKINS_HOME /jenkins
