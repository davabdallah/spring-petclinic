pipeline{
    agent { kubernetes {
       inheritFrom 'default'
       }
    }
    environment {

    }
    tools {
        maven "maven3" 
    }
    stages{
        stage('Sonar Quality Check'){
            container('maven'){
                steps{
                    script{
                        withSonarQubeEnv(credentialsId: 'sonarqube.jenkins') {
                            sh 'mvn clean package sonar:sonar'   
                         }
                    }
                }
            }   
        } 
        stage ('Quality Gate Status'){
            container('mavin'){
                steps{
                    script{
                         withSonarQubeEnv(credentialsId: 'sonarqube.jenkins'){
                            sh 'mvn clean package sonar:sonar' 
                        }
                    }
                }
            }
        }
        stage ('Build'){
            container('maven'){
                steps{
                    script{
                        sh 'chmod +x mvnw'
                        sh './mvnw clean package spring-boot:build-image'                    
                }
            }
        }
    }
        stage ("Upload"){
            container('kaniko')
            steps{
                script{
                     withCredentials([string(credentialsId: 'nexus_passwd', variable: 'nexus_creds')]) {
                        sh docker login -u admin -p $nexus_creds 10.108.101.73:8083

                        sh docker push 10.108.101.73:8083/spring-petclinic

                        sh docker rmi 10.108.101.73:8083/spring-petclinic
                    }
                }
            }
        }
    }    
}   
