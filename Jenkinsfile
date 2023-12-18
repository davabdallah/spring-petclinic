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
                container('kaniko'){
                    script{

                            sh 'echo "34.18.2.177 nexus.atos.test" >> /etc/hosts'
                            sh '/kaniko/executor -f $WORKSPACE/dockerfile -c $WORKSPACE/ --insecure --skip-tls-verify --cache=true --destination=http://nexus.atos.test/repository/nexus-docker/spring-petclinic:${VERSION}'

                        }
                    }
                }
            }     
        } 
    }
