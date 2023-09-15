pipeline {
    agent any

    environment {
        NGINX_VM_SSH_CREDENTIALS = credentials('azure-cred')
        NGINX_VM_IP = '20.205.13.24'
        NGINX_VM_PATH = '/home/azureuser/sample-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Kanika637/Flask-Python-E-Commerce-Website.git'
            }
        }

        stage('Install Dependencies') {
            steps {
               
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Deploy to NGINX VM') {
            steps {
                script {
                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'azure-cred', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                            sudo scp -r -i /home/azureuser/.ssh/sqlite.pem * azureuser@20.205.13.24:/home/azureuser/sample-app/
                        """
                    }
                }
            }
        }

        stage('Write Nginx Configuration') {
            steps {
                script {
                    def nginxConfig = """
                        server {
                            listen 80;
                            server_name 20.205.13.24;

                            location / {
                                proxy_pass http://127.0.0.1:5000;
                                proxy_set_header Host \$host;
                                proxy_set_header X-Real-IP \$remote_addr;
                            }
                        }
                    """

                   
                    writeFile file: 'nginx_config', text: nginxConfig

                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'azure-cred', keyFileVariable: 'SSH_KEY')]) {
                        sh "sudo scp -i /home/azureuser/.ssh/sqlite.pem -o StrictHostKeyChecking=no nginx_config azureuser@20.205.13.24:/home/azureuser/nginx-code"
                    }

                    
                    sh """
                        sudo ssh -i /home/azureuser/.ssh/sqlite.pem -o StrictHostKeyChecking=no azureuser@20.205.13.24 'sudo mv /home/azureuser/nginx-code/nginx_config /etc/nginx/sites-available/my_app'
                    """
                }
            }
        }

        stage('Restart NGINX') {
            steps {
                script {
                  
                    withCredentials([sshUserPrivateKey(credentialsId: 'azure-cred', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                            sudo ssh -i /home/azureuser/.ssh/sqlite.pem -o StrictHostKeyChecking=no azureuser@20.205.13.24 'sudo systemctl restart nginx'
                        """
                    }
                }
            }
        }

        stage('Start Application') {
            steps {
                script {
                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'azure-cred', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                            sudo ssh -i /home/azureuser/.ssh/sqlite.pem -o StrictHostKeyChecking=no azureuser@20.205.13.24 'pkill -f "python3 wsgi.py"'
                        """
                    }

                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'azure-cred', keyFileVariable: 'SSH_KEY')]) {
                        sh """
                            sudo ssh -i /home/azureuser/.ssh/sqlite.pem -o StrictHostKeyChecking=no azureuser@20.205.13.24 'cd /home/azureuser/sample-app && python3 wsgi.py &'
                        """
                    }

                   
                    sleep time: 300, unit: 'SECONDS'
                }
            }
        }
    }
}
