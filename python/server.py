from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

GEMINI_API_KEY = "AIzaSyC9Dv4b-73KLTc7E2jqqrIRhgSPO4F4Fjo"
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-flash:generateContent"

@app.route('/generate', methods=['POST'])
def generate():
    data = request.json
    prompt = data.get('prompt')
    
    if not prompt:
        return jsonify({"error": "No prompt provided"}), 400

    headers = {
        "Content-Type": "application/json"
    }
    
    payload = {
        "contents": [
            {
                "role": "user", 
                "parts": [{"text": prompt}]
            }
        ]
    }
    
    response = requests.post(f"{GEMINI_API_URL}?key={GEMINI_API_KEY}", 
                             headers=headers, json=payload)
    
    return jsonify(response.json())

if __name__ == '__main__':
    app.run()