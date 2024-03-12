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
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh '/usr/local/bin/docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/repository/docker/shaizah56/legal-api/', 'docker-registry-credentials') {
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
