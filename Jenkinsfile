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
            git://github.com/davabdallah/spring-petclinic.git
            steps{
                container('kaniko'){
                    script{
                            sh '/kaniko/executor --context `pwd` --insecure --skip-tls-verify --cache=true --destination=http://nexus.atos.test/repository/nexus-docker/spring-petclinic:${VERSION}'

                        }
                    }
                }
            }     
        } 
    }
