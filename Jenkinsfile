pipeline {
    agent any

    stages {
        stage('Build Artifact') {
            steps {
                sh "mvn clean package -DskipTests=true"
                archiveArtifacts 'target/*.jar' // Archive artifacts for later download
            }
        }

        stage('Unit Test') {
            steps {
                sh "mvn test"
            }
        }

        stage('Docker build and push') {
            steps {
                script {
                    // Use docker.withRegistry to authenticate with Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-cred') {
                        // Build Docker image
                        sh "docker build -t muhammadfasil/numeric-app:${env.GIT_COMMIT} ."
                        // Push Docker image
                        sh "docker push muhammadfasil/numeric-app:${env.GIT_COMMIT}"
                    }
                }
            }
        }
    }
}
