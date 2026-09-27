# Session 53 — Java and Maven Pipeline

This lab builds a Java/Maven GitLab CI/CD pipeline that runs unit tests, publishes JUnit test reports, caches Maven dependencies, packages the application, and stores the generated JAR as an artifact.

## Topics

- Maven Lifecycle
- mvn test
- mvn package
- Maven Cache
- JAR Artifact
- Test Report

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: dev-shell
- Java: OpenJDK 17
- Build tool: Maven
- Test framework: JUnit 5

## Pipeline Flow

~~~text
Maven Test
    |
    v
Test Report
    |
    v
Package
    |
    v
JAR Artifact
~~~

The test stage is the quality gate. If the Maven tests fail, the package stage does not run. The package job uses -DskipTests because the dedicated test job has already validated the tests.

## Project Structure

~~~text
.
├── .gitlab-ci.yml
├── pom.xml
├── src
│   ├── main
│   │   └── java
│   │       └── com
│   │           └── example
│   │               ├── App.java
│   │               └── Calculator.java
│   └── test
│       └── java
│           └── com
│               └── example
│                   └── CalculatorTest.java
└── DevOps_Java_Maven_Pipeline_Session_53_Commands_CheatSheet.txt
~~~

## Maven Cache

The pipeline redirects the Maven local repository into the project workspace:

~~~text
$CI_PROJECT_DIR/.m2/repository
~~~

GitLab caches .m2/repository/ with a cache key based on pom.xml.

## Test Report

Maven Surefire generates JUnit XML reports under:

~~~text
target/surefire-reports/
~~~

GitLab publishes TEST-*.xml as a JUnit report and keeps the report directory as an artifact even when the test job fails.

## JAR Artifact

The package job creates a JAR under target/ and stores target/*.jar as a GitLab artifact for one week.

## Files

- .gitlab-ci.yml — Maven test/package pipeline, cache, JUnit report, and JAR artifact configuration
- pom.xml — Maven project configuration with Java 17 and JUnit 5
- src/main/java/com/example/App.java — sample Java entry class
- src/main/java/com/example/Calculator.java — sample class used by the tests
- src/test/java/com/example/CalculatorTest.java — JUnit unit tests
- DevOps_Java_Maven_Pipeline_Session_53_Commands_CheatSheet.txt — commands used in this lesson with beginner-friendly English explanations
