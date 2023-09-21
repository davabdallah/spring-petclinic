FROM jenkins/jenkins:jdk17-preview 

RUN mkdir /var/jenkins_home/Spring-Project

WORKDIR /var/jenkins_home/Spring-Project

COPY  . .

RUN ./mvnw clean package -DskipTests
RUN ./mvnw spring-boot:build-image

EXPOSE 8080

ENTRYPOINT [java -jar target/*.jar]
