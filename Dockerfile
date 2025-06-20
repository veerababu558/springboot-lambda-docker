# ---------- Stage 1: Build ----------
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ---------- Stage 2: Lambda ----------
FROM public.ecr.aws/lambda/java:17
COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar ${LAMBDA_TASK_ROOT}/app.jar
CMD ["com.example.demo.StreamLambdaHandler"]
