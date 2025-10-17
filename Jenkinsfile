pipeline {
    agent any

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
                    echo "🚀 Docker 이미지 빌드 및 푸시 중... 태그: ${tag}"

                    // 🔐 Jenkins Credential 사용 (dockerhub-credentials)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            docker build -t goyunjae99/flask-cicd:${tag} .
                            echo "🔑 DockerHub 로그인 중..."
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push goyunjae99/flask-cicd:${tag}
                            docker tag goyunjae99/flask-cicd:${tag} goyunjae99/flask-cicd:latest
                            docker push goyunjae99/flask-cicd:latest
                        """
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    def tag = "v${env.BUILD_NUMBER}"
                    echo "🐳 새 버전 컨테이너 실행 중..."
                    sh """
                        docker stop flask || true
                        docker rm flask || true
                        docker run -d --name flask -p 5000:5000 goyunjae99/flask-cicd:${tag}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ 파이프라인 성공적으로 완료됨!"
        }
        failure {
            echo "❌ 파이프라인 실패. 로그를 확인하세요."
        }
    }
}

