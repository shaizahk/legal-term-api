pipeline {
    agent any

    environment {
    PROPERTIES = readProperties file: 'config/docker.properties'
    DOCKER_IMAGE = "${PROPERTIES.DOCKER_IMAGE}"
    DOCKER_TAG = "${PROPERTIES.DOCKER_TAG}"
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
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-registry-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
        post {
        failure {
            script {
                echo 'A stage has failed. Executing cleanup and rollback...'
                // Rollback Kubernetes deployment
                sh 'kubectl rollout undo deployment/your-deployment-name'
                // Additional cleanup actions
            }
        }
    }
}
