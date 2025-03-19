ARG MSVC_NAME=msvc-usuarios

FROM openjdk:17-jdk-alpine AS builder

WORKDIR /app/msvc-usuarios

COPY ./.mvn ./.mvn
COPY mvnw .
COPY pom.xml .

RUN ./mvnw clean package -Dmaven.test.skip -Dmaven.main.skip -Dspring-boot.repackage.skip && rm -r ./target/

COPY ./src ./src

RUN ./mvnw clean package -DskipTests

FROM openjdk:17-jdk-alpine

ARG MSVC_NAME

WORKDIR /app

RUN mkdir "./logs"

ARG TARGET_FOLDER=/app/$MSVC_NAME/target

COPY --from=builder $TARGET_FOLDER/msvc-usuarios-0.0.1-SNAPSHOT.jar .

ARG PORT_APP=8001

ENV PORT=$PORT_APP

EXPOSE $PORT

ENTRYPOINT ["java", "-jar", "msvc-usuarios-0.0.1-SNAPSHOT.jar"]