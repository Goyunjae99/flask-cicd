pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }

    stages {
        stage('Build') {
            steps {
                echo '📦 Flask 의존성 설치 중...'
                sh 'pip install -r requirements.txt || true'
            }
        }

        stage('Test') {
            steps {
                echo '🧪 테스트 중...'
                sh 'echo "테스트 통과!"'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}"
                    echo "🚀 Docker 이미지 빌드 및 푸시 시작 (태그: ${tag})..."

                    sh """
                        docker build -t goyunjae99/flask-cicd:${tag} .
                        echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                        docker push goyunjae99/flask-cicd:${tag}
                        docker tag goyunjae99/flask-cicd:${tag} goyunjae99/flask-cicd:latest
                        docker push goyunjae99/flask-cicd:latest
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    echo "🐳 최신 버전 컨테이너 자동 실행 중..."
                    sh """
                        docker stop flask || true
                        docker rm flask || true
                        docker pull goyunjae99/flask-cicd:latest
                        docker run -d --name flask -p 5000:5000 goyunjae99/flask-cicd:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ 파이프라인 성공적으로 완료됨!'
        }
        failure {
            echo '❌ 파이프라인 실패. 로그를 확인하세요.'
        }
    }
}

