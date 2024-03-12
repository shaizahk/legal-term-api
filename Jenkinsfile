pipeline {
    agent any

    environment {
    PROPERTIES = readProperties file: 'config/docker.properties'
    DOCKER_IMAGE = "${PROPERTIES.DOCKER_IMAGE}"
    DOCKER_TAG = "${PROPERTIES.DOCKER_TAG}"
    DOCKER_REGISTRY_URL = credentials('docker_registry_url')
    DOCKER_REGISTRY_CREDENTIALS = credentials('docker-registry-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

    stage('Run Tests') {
        steps {
            script {
                sh 'python3 tests/test_loading.py'
            }
        }
    }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }
        
         stage('Update Deployment Manifest') {
             steps {
                 script {
                     sh "sed -i '' 's|IMAGE_NAME_PLACEHOLDER|${DOCKER_IMAGE}|g' deployment.yaml"
                     sh "sed -i '' 's|TAG_PLACEHOLDER|${DOCKER_TAG}|g' deployment.yaml"
                 }
             }
         }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("${DOCKER_REGISTRY_URL}", "${DOCKER_REGISTRY_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml -f service.yaml'
                }
            }
        }
    }
        post {
        failure {
            script {
                echo 'A stage has failed. Executing cleanup and rollback...'
                sh 'kubectl rollout undo deployment/legal-api'
            }
        }
    }
}
