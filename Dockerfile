FROM docker.io/library/openjdk:17-jdk-slim

COPY  ./target /Spring-Project

WORKDIR /Spring-Project

EXPOSE 8080

ENTRYPOINT ["sh", "-c" ,"java -jar *.jar"]
