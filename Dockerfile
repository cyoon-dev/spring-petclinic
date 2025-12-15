# JRE on base image
FROM eclipse-temurin:17-jre-alpine

# Set working dir
WORKDIR /app

# -----------------------------------------------------------
# New Relic Agent Setup
# -----------------------------------------------------------
# 1. Install curl and unzip (Alpine uses apk, not apt-get)
RUN apk add --no-cache curl unzip

# 2. Download and unzip New Relic Java Agent
RUN mkdir -p /app/newrelic && \
    curl -L https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip -o /app/newrelic/newrelic-java.zip && \
    unzip /app/newrelic/newrelic-java.zip -d /app/newrelic && \
    rm /app/newrelic/newrelic-java.zip

# -----------------------------------------------------------
# Application Setup
# -----------------------------------------------------------
# Copy Jar file
COPY target/*.jar app.jar

# Expose application port
EXPOSE 8080

# -----------------------------------------------------------
# Execution
# -----------------------------------------------------------
# Execution commands (Modified to include -javaagent)
ENTRYPOINT ["java", "-javaagent:/app/newrelic/newrelic/newrelic.jar", "-jar", "app.jar"]