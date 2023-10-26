pipeline{
    agent {kubernetes {
          inheritFrom 'default'
        } 
    }

environment {
    VERSION = "${env.BUILD_ID}"
    nexus_creds = "Dav_-123"
}

    tools {
        maven "Maven3" 
    }

    stages{
        
        stage ('Build'){
            steps{
                container('maven'){
                    script{
                        sh 'chmod +x mvnw'
                        sh './mvnw clean package -Dcheckstyle.skip'        
                }
            }
        }
    }

        stage('Sonar Quality Check'){
            steps{
                container('maven'){
                    script{
                        withSonarQubeEnv(credentialsId: 'jenkins-sonarqube') {
                            sh 'mvn clean package sonar:sonar'   
                        }
                    }
                }
            }   
        } 

        stage ('Quality Gate Status'){
            steps{
                container('maven'){
                    script{
                         waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube'

                    }
                }
            }
        }

        stage ("Upload"){
            steps{
                container('podman'){
                    script{

                            sh 'echo "34.18.2.177 nexus.atos.test" >> /etc/hosts'
                            sh 'podman build -t nexus.atos.test:8083/spring-petclinic:${VERSION} .'
                            sh 'podman login --tls-verify=false -u admin -p $nexus_creds nexus.atos.test'
                            sh 'podman push nexus.atos.test/nexus-docker/spring-petclinic'
                        }
                    }
                }
            }     
        } 
    }
