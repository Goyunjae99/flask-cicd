# 베이스 이미지 선택
FROM python:3.9

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일 복사
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# 앱 복사
COPY . .

# Flask 실행
CMD ["python", "app.py"]

# Flask 기본 포트
EXPOSE 5000

