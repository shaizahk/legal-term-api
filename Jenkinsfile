pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'shaizah56/legal-api'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Initialize') {
            steps {
                script {
                    def dockerHome = tool 'myDocker'
                    if (dockerHome == null) {
                        error("Docker tool 'myDocker' not found.")
                    }
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                    echo "Updated PATH: ${env.PATH}"
                }
            }
        }


        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-registry-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubeconfig-credentials-id']) {
                        sh 'kubectl apply -f k8s/deployment.yaml'
                    }
                }
            }
        }
    }
}
