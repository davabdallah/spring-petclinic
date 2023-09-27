pipeline{
    agent {kubernetes {
          inheritFrom 'default'
  } }

    tools {
        maven "maven3" 
    }
    stages{
        
        stage('Sonar Quality Check'){
            steps{
                container('maven'){
                    script{
                        withSonarQubeEnv(credentialsId: 'sonarqube.jenkins') {
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
                         withSonarQubeEnv(credentialsId: 'sonarqube.jenkins'){
                            sh 'mvn clean package sonar:sonar' 
                        }
                    }
                }
            }
        }
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
        stage ("Upload"){
            steps{
                container('podman'){
                    script{
                        withCredentials([string(credentialsId: 'nexus_passwd', variable: 'nexus_creds')]) {
                            sh 'chown -R podman:podman /var/lib/containers'
                            sh 'chmod -R 777 /var/lib/containers'
                            sh 'export GODEBUG=x509ignoreCN=0'
                            sh 'echo "10.182.0.3 nexus.atostask.com" >> /etc/hosts'
                            sh 'podman build -t nexus.atostask.com:8083/spring-petclinic .'
                            sh 'podman login -u admin -p $nexus_creds nexus.atostask.com'
                            sh 'podman push nexus.atostask.com/mydocker/spring-petclinic'
                    }
                }
            }
        }    
    } 
}
}
