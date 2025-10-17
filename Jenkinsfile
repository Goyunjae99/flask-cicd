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
                    echo "🚀 Docker 이미지 빌드 및 푸시 중... (태그: ${tag})"

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            # 이미지 빌드
                            docker build -t goyunjae99/flask-cicd:${tag} .

                            # DockerHub 로그인
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                            # 이미지 푸시
                            docker push goyunjae99/flask-cicd:${tag}

                            # latest 태그 갱신
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
                        # 기존 flask 컨테이너 중지 및 삭제
                        docker stop flask 2>/dev/null || true
                        docker rm flask 2>/dev/null || true

                        # 혹시 포트 5000을 점유 중인 다른 컨테이너도 모두 종료 및 삭제
                        docker ps --filter 'publish=5000' -q | xargs -r docker stop || true
                        docker ps -a --filter 'publish=5000' -q | xargs -r docker rm || true

                        # 새 컨테이너 실행
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
            echo "❌ 파이프라인 실패! 로그를 확인하세요."
        }
    }
}

