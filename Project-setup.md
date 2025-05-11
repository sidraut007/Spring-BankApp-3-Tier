# 🛠 Spring BankApp CI/CD Pipeline Setup (Jenkins + SonarQube + Nexus)

This guide explains how to set up a full DevOps CI/CD pipeline using **Jenkins**, **SonarQube**, and **Nexus** with Docker. It automates build, test, code quality analysis, artifact upload, Docker image build, and deployment.

---

## 🚀 Project Prerequisites

- Docker & Docker Compose installed
- GitHub repository access
- DockerHub account
- Java/Maven project (like Spring Boot)
- Jenkins, SonarQube, Nexus Docker images
- Basic knowledge of CI/CD tools

---

## 📦 Step-by-Step Setup

### 1. 🔧 Clone the Repository

```bash
git clone https://github.com/sidraut007/Spring-BankApp-3-Tier.git
cd Spring-BankApp-3-Tier

```
---

### 2. 🐳 Start the Infrastructure with Docker Compose

```bash
cd Spring-BankApp-3-Tier/Project_Infra

docker-compose up -d

```

- This will:

    Run Jenkins at http://localhost:8080

    Run SonarQube at http://localhost:9000

    Run Nexus at http://localhost:8081

---

### 3. 👷 Configure Jenkins

- Install suggested plugins, then install:

    pipeline-stage-view
    Maven
    SonarQube Scanner
    Docker Pipeline
    Nexus Artifact Uploader

- Configure global tools under Manage Jenkins → Global Tool Configuration:
    - Maven, Sonar-Scanner, 

- Add required credentials:

    GitHub (Personal Access Token)
    DockerHub (username/password)
    SonarQube token
    Nexus user credentials #in global maven setting

---

### 4. ⚙️ Add Jenkins Pipeline Job

- Add your Jenkinsfile in the root of the repo.
- Set SCM to Git, using your repository URL.

---

### 5. 🧪 Configure SonarQube
- Login to SonarQube as admin/admin

- Configure a webhook under:
        Project Settings → General → Webhooks
    
    ```
    http://jenkins:8080/sonar-webhook/
    ```

- Test Webhook from Sonar Container
    ```
    docker exec -it <sonar-container-name> curl -I http://jenkins:8080/sonar-webhook/
    ```

---

### 6. 📦 Nexus Repository Setup
- Login to Nexus at http://localhost:8081 as admin.
- Create a Maven hosted repository (e.g., maven-releases).
- Add this to your pom.xml:

``bash

    <distributionManagement>
    <repository>
        <id>nexus</id>
        <url>http://nexus:8081/repository/maven-releases/</url>
    </repository>
    </distributionManagement>

    <distributionManagement>
    <repository>
        <id>nexus</id>
        <url>http://nexus:8081/repository/maven-snapshots/</url>
    </repository>
    </distributionManagement>

```

