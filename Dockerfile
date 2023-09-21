FROM mediasol/openjdk17-slim-jprofiler:latest

COPY  ./target /Spring-Project

WORKDIR /Spring-Project

EXPOSE 8080

ENTRYPOINT ["sh", "-c" ,"java -jar *.jar"]
