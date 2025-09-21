pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    REGISTRY       = "docker.io"
    IMAGE_NAME     = "atuljkamble/docker-basic-website"
    SHORT_SHA      = "${env.GIT_COMMIT?.take(7)}"
  }

  parameters {
    string(name: 'TAG_SUFFIX', defaultValue: '', description: 'Optional extra tag (e.g., v1.0.0)')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Docker Build') {
      steps {
        sh '''
          docker build -t ${IMAGE_NAME}:build .
        '''
      }
    }

    stage('Smoke Test') {
      steps {
        sh '''
          set -eux
          docker rm -f webtest || true
          docker run -d --rm -p 8080:80 --name webtest ${IMAGE_NAME}:build
          for i in $(seq 1 20); do
            if curl -fsS http://localhost:8080/ >/dev/null; then
              echo "App OK ✅"
              break
            fi
            echo "Waiting for app... ($i)"
            sleep 1
          done
        '''
      }
      post {
        always {
          sh 'docker stop webtest || true'
        }
      }
    }

    stage('Tag Images') {
      steps {
        sh '''
          set -eux
          docker tag ${IMAGE_NAME}:build ${IMAGE_NAME}:latest
          if [ -n "${SHORT_SHA}" ]; then
            docker tag ${IMAGE_NAME}:build ${IMAGE_NAME}:${SHORT_SHA}
          fi
          if [ -n "${TAG_SUFFIX}" ]; then
            docker tag ${IMAGE_NAME}:build ${IMAGE_NAME}:${TAG_SUFFIX}
          fi
        '''
      }
    }

    stage('Login & Push') {
      environment {
        // Create a Jenkins credential (Username with password) id: dockerhub
        // Username = your Docker Hub username, Password/Token = access token
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            set -eux
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin ${REGISTRY}
            for TAG in latest ${SHORT_SHA} ${TAG_SUFFIX}; do
              if [ -n "$TAG" ]; then
                docker push ${IMAGE_NAME}:$TAG
              fi
            done
          '''
        }
      }
    }
  }

  post {
    always {
      sh 'docker image prune -f || true'
    }
  }
}
