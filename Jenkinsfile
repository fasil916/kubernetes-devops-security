pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archiveArtifacts 'target/*.jar' //so that they can be downloaded later
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
                
              docker.withRegistry(credentialsId: docker-hub-cred )
              sh '''printenv
              docker build -t muhammadfasil/numeric-app:$GIT_COMMIT .
              docker push muhammadfasil/numeric-app:$GIT_COMMIT
              '''
              }
            }
        } 
    }
}
