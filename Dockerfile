# ---- Stage 1: Build ----
# Use a JDK image to build the application
FROM eclipse-temurin:17-jdk-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and POM file
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Download dependencies (this caches a layer)
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code
COPY src/ src/

# Package the application, skipping tests (we run them in the CI pipeline)
RUN ./mvnw package -DskipTests


# ---- Stage 2: Runtime ----
# Use a smaller JRE-only image for the final container
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar /app/app.jar

# Expose the port the application runs on
EXPOSE 8080

# Set the entrypoint to run the JAR
ENTRYPOINT ["java", "-jar", "/app/app.jar"]