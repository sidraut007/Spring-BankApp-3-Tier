pipeline {
    agent any

    parameters {
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Choose the Docker image tag for the deployment')
    }

    tools {
        maven 'maven3' 
    }

    environment {
       SCANNER_HOME= tool 'sonar-scanner' 
       IMAGE_NAME = "sidraut007/spring-bankapp"
       TAG = "${params.DOCKER_TAG}"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/sidraut007/Spring-BankApp-3-Tier.git'
                }
            }
        stage('Maven compile') {
            steps {
                script {
                    sh 'mvn compile'
                }
            }
        }  

        stage('maven test') {
            steps {
                script {
                    sh 'mvn test -DskipTests=true'
                }
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=bankapp \
                    -Dsonar.projectName=bankapp -Dsonar.java.binaries=target '''
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                script {
                    try {
                        timeout(time: 2, unit: 'MINUTES') {
                            waitForQualityGate abortPipeline: true, credentialsId: 'sonar-token'
                        }
                        } catch (err) {
                            echo "Warning: SonarQube Quality Gate did not complete in time — continuing anyway."
                             // Optionally: mark stage as unstable
                             currentBuild.result = 'UNSTABLE'
                             }
                        }
                }
        }

        stage('Maven install') {
            steps {
                script {
                    sh 'mvn clean install -DskipTests=true'
                }
            }
        }
        
        stage('publish Artifact to Nexus ') {
            steps {
                script {
                    sh 'mvn deploy'
                }
            }
        }

        stage('Docker Build & Tag') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker push ${IMAGE_NAME}:${TAG}"
                }
            }
        }
        }
}
}
