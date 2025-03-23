# DEVELOPMENT Stage Building Artifact
#----------------------------------

# Import docker image with maven installed
FROM maven:3.8.3-openjdk-17 as builder 

# Add labels to the image to filter out if we have multiple application running
LABEL app=bankapp

# Set working directory
WORKDIR /src

# Copy source code from local to container
COPY . /src

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

# PRODUCTION Stage  
#----------------------------------
# Import small size java image
FROM openjdk:17-alpine as deployer

# Copy build from stage 1 (builder)
COPY --from=builder /src/target/*.jar /src/target/bankapp.jar

# Expose application port 
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/src/target/bankapp.jar"]
