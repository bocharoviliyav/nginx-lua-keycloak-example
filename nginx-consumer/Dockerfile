FROM  openjdk:16-jdk-slim

COPY target/Application.jar /usr/src
WORKDIR /usr/src
CMD ["java", "-jar", "Application.jar"]
EXPOSE 8082