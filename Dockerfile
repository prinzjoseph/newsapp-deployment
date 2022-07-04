FROM maven:3.8.5-jdk-11 AS packer
COPY ./spring-boot-jsp/ /app/
WORKDIR /app/
RUN mvn package

FROM openjdk:8-jre-alpine
LABEL maintainer="prinzjoseph"
WORKDIR /root
COPY --from=packer /app/target/news-v1.0.2.jar /root/
EXPOSE 8090
CMD [ "java", "-Xms128m", "-Xmx256m", "-jar", "-Dserver.port=8090", "news-v1.0.2.jar" ]


