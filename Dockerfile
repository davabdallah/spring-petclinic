FROM jenkins/jenkins:jdk17-preview 

RUN mkdir /var/jenkins_home/Spring-Project

WORKDIR /var/jenkins_home/Spring-Project

COPY  . /Spring-Project

RUN  /Spring-Project/mvnw package

EXPOSE 8080

ENTRYPOINT [java -jar target/*.jar]
