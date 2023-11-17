pipeline {
    agent any
    environment {
        GIT_REPO_URL = 'https://github.com/Emna-Cheniour/kubernetes_TP.git'
        DOCKER_IMAGE = 'nginx:latest'
    }
    stages{
        stage('Pull from GitHub') {
            steps {
                echo "******** FETCHING ********"
                checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: GIT_REPO_URL]]])
            }
        }

        stage('Build and Deploy to Minikube') {
            steps {
                echo "******** BUILDING AND DEPLOYING ********"
                sh "minikube start" 
                sh "kubectl apply -f ./nginx-app-deployment.yaml"
                sh "kubectl apply -f ./nginx-service.yaml"
            }
        }

        stage('Nagios Monitoring') {
            steps {
                echo "******** NAGIOS MONITORING ********"
                script {
                    def nginxServiceIP = sh(script: "minikube service nginx-service --url", returnStdout: true).trim()
                    def httpStatus = sh(script: "curl -s -o NUL -w %%{http_code} ${nginxServiceIP}\\80", returnStdout: true).trim()
                    if (httpStatus == '200') {
                        echo "OK - NGINX is healthy"
                    } else {
                        echo "CRITICAL - NGINX is not responding correctly"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
        
        stage('Clean Environment'){
            steps{
                echo "******** CLEANING ********"
                sh "kubectl delete deployment nginx-app-deployment"
                sh "kubectl delete service nginx-service"
                sh "minikube stop"
            }
        }
    }
}
