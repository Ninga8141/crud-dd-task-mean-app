pipeline {
  agent any

  environment {
    IMAGE_BACKEND = "ninga8141/mean-backend"
    TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT?.substring(0,7)}"
    VM_USER = "ubuntu"
    VM_HOST = "3.84.126.63"
    DEPLOY_DIR = "meanapp-deploy"
  }

  tools {
    nodejs "Node18"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Backend') {
      steps {
        dir('backend') {
          sh 'npm install'
        }
      }
    }

    stage('Build Docker Image - Backend') {
      steps {
        sh "docker build -t ${IMAGE_BACKEND}:${TAG} ./backend"
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${IMAGE_BACKEND}:${TAG}"
          sh "docker tag ${IMAGE_BACKEND}:${TAG} ${IMAGE_BACKEND}:latest"
          sh "docker push ${IMAGE_BACKEND}:latest"
        }
      }
    }

    stage('Deploy to VM') {
      steps {
        sshagent (credentials: ['vm-ssh-key']) {
          sh """
            ssh -o StrictHostKeyChecking=no ${VM_USER}@${VM_HOST} 'bash -s' <<EOF
              set -e
              cd ~/${DEPLOY_DIR}
              echo "Pulling backend image: ${IMAGE_BACKEND}:latest"
              docker pull ${IMAGE_BACKEND}:latest
              docker compose up -d --remove-orphans --force-recreate
              docker image prune -af || true
              echo "Deployment completed at \$(date)"
EOF
          """
        }
      }
    }
  }

  post {
    success { echo 'Pipeline completed successfully 🎉' }
    failure { echo 'Pipeline failed ❌' }
  }
}

