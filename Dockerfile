FROM docker.io/openjdk:17-jdk-slim4

COPY  ./target /Spring-Project

WORKDIR /Spring-Project

EXPOSE 8080

ENTRYPOINT ["sh", "-c" ,"java -jar *.jar"]
