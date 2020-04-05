pipeline {

     environment {
          registry = "diegotc/chat-channel"
          registryCredential = '826db27a-8ac9-41a9-83e8-0a920204a2f0'
     }

     agent any
     stages {
         stage('Build') {
             steps {
                 sh 'echo "Hello World"'
                 sh '''
                     echo "Multiline shell steps works too"
                     ls -lah
                 '''
             }
         }

         stage ("lint dockerfile") {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }

            steps {
                sh 'hadolint Dockerfile | tee -a hadolint_lint.txt'
            }

            post {
                always {
                    archiveArtifacts 'hadolint_lint.txt'
                }
            }
         }

          stage('Lint HTML') {
              steps {
                  sh 'tidy -q -e *.html'
              }
         }

         stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
         }


         stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
          }


         stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
         }

         stage('Update Correct images for blue deploying') {
            steps{
                sh "sed s/%BUILD_NUMBER%/$BUILD_NUMBER/g k8/deployment-blue-template.yml  > k8/deployment-blue.yml"
                sh "cat k8/deployment-blue.yml"
            }
         }

         stage('Blue Deployment') {
             steps {
                script{
                   sh 'ansible-playbook -i inventory main-k8-blue.yml -vvvv'
                }

             }
         }

         stage('Green Deployment') {
            input{
                message "Do you want to proceed for production deployment?"
            }
             steps {
                script{
                    sh "sed s/%BUILD_NUMBER%/$BUILD_NUMBER/g k8/deployment-green-template.yml  > k8/deployment-green.yml"
                    sh "cat k8/deployment-green.yml"
                }
                script{
                    sh 'ansible-playbook -i inventory main-k8-green.yml -vvvv'
                }
             }
         }



     }
}