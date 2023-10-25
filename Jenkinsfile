pipeline{
    agent {kubernetes {
          inheritFrom 'default'
        } 
    }

environment {
    VERSION = "${env.BUILD_ID}"
}

    tools {
        maven "maven3" 
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
                        withCredentials([string(credentialsId: 'nexus-jenkins', variable: 'nexus_creds')]) {

                            sh 'export GODEBUG=x509ignoreCN=0'
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
}
