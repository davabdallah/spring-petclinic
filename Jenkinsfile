pipeline{
    agent any
    tools {
        maven "maven3" 
    }
    stages{
        stage('Sonar Quality Check'){ 
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonarqube.jenkins') {
                     sh 'mvn clean package sonar:sonar'   
                  }
                }
            }
        }    
        stage ('Quality Gate Status'){
            steps{
                script{
                       withSonarQubeEnv(credentialsId: 'sonarqube.jenkins') {
                     sh 'mvn clean package sonar:sonar'   
                }
            }
        }
    }
        stage ('Build and Push to Nexus'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nexus_passwd', variable: 'nexus_creds')]) {
                        sh 'chmod +x mvnw'
                        
                        sh './mvnw clean package spring-boot:build-image'

                        sh 'docker login -u admin -p $nexus_creds 10.108.101.73:8083'

                        sh 'docker push 10.108.101.73:8083/spring-petclinic'

                    }
                }
            }
        }
  }    
}   
