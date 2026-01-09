# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Build the WAR file (skipping tests to speed up deployment)
RUN mvn clean package -DskipTests

# Stage 2: Run the application on Tomcat
FROM tomcat:9.0-jdk17-temurin
# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the built WAR file from the build stage
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]