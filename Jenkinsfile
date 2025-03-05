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
                    // Use Jenkins' credentials system to handle Docker login securely
                    withDockerRegistry(credentialsId: 'docker-hub-cred') {
                        sh "docker build -t muhammadfasil/numeric-app-new:${env.GIT_COMMIT} ."
                        // Push Docker image
                        sh "docker push muhammadfasil/numeric-app-new:${env.GIT_COMMIT}"
                    }
                }
            }
        }
stage('kubernetes deployment -dev') {
            steps {
               withKubeConfig(credentialsId: 'kubeconfig') {
              sh "sed -i 's#replace#muhammadfasil/numeric-app-new:${env.GIT_COMMIT}#g' k8s_deployment_service.yaml"    
              sh "kubectl apply -f k8s_deployment_service.yaml"
               }
            }
        }
        
    }
}

 
