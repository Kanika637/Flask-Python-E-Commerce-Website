pipeline {
    agent any
    
stages {
        stage('Clone Repository') {
            steps {
                git(url: 'https://github.com/Kanika637/Flask-Python-E-Commerce-Website.git', branch: 'master')
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'sudo docker build -t kanika26/python-web-comm-file .'
                }
            }
        }
        
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Authenticate with Docker Hub using credentials
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        def dockerImage = 'kanika26/python-web-comm-file:latest'
                        sh "sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                        sh "sudo docker push $dockerImage"
                    }
                }
            }
        }
        
        
        stage('Deploy to EKS') {
            steps {
                script {
                    // Authenticate with AWS using your AWS credentials
                    withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                                     string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        // Set the AWS CLI environment variables
                        sh "aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID"
                        sh "aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY"

                        // Authenticate with the EKS cluster
                        sh "aws eks --region ap-south-1 update-kubeconfig --name my-eks-cluster"

                        // Deploy the Kubernetes manifests to the EKS cluster
                        sh "kubectl apply -f deployment.yml"
                    }
                }
            }
        

    
        }    
        
        
    }
}
