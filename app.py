from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "LG통합우승 절대 안돼"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

