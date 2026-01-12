# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -q -e -B -DskipTests dependency:go-offline

COPY src ./src
RUN mvn -q -e -B -DskipTests package

# ===== Run stage =====
FROM eclipse-temurin:17-jre
WORKDIR /app

# Use non-root user for better practice (optional)
RUN useradd -ms /bin/bash spring
USER spring

COPY --from=build /app/target/docker-spring-boot-practice-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
