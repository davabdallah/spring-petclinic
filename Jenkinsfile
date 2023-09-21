pipeline{
    agent {kubernetes {
          inheritFrom 'default'
  } }

    tools {
        maven "maven3" 
    }
    stages{
        
        stage('Sonar Quality Check'){
            agent {
               label 'podman'
           }
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
            agent {
               label 'podman'
           }
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
            agent {
               label 'podman'
           }
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
            agent {
               label 'podman'
           }
            steps{
                container('podman'){
                    script{
                        withCredentials([string(credentialsId: 'nexus_passwd', variable: 'nexus_creds')]) {
                            sh 'chown -R podman:podman /var/lib/containers'
                            sh 'chmod -R 777 /var/lib/containers'
                            sh 'podman build -t spring-petclinic:1 .'
                            sh 'podman login -u admin -p $nexus_creds 10.108.101.73:8083'
                            sh 'podman push 10.108.101.73:8083/spring-petclinic'
                    }
                }
            }
        }    
    } 
}
}
