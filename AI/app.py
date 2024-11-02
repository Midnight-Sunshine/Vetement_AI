from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
from tensorflow.keras.applications.mobilenet_v2 import MobileNetV2, preprocess_input, decode_predictions
from PIL import Image
import numpy as np
import io
from googletrans import Translator  # Import the Google Translate library

app = Flask(__name__)
CORS(app)

# Load MobileNetV2 pre-trained model
model = MobileNetV2(weights="imagenet")

# Initialize the translator
translator = Translator()

def prepare_image(image_bytes):
    """Preprocess the image to fit MobileNetV2 input requirements."""
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    img = img.resize((224, 224))  # MobileNetV2 input size
    img = np.array(img)
    img = preprocess_input(img)
    img = np.expand_dims(img, axis=0)
    return img

@app.route('/classify', methods=['POST'])
def classify_image():
    if 'image' not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    image_bytes = request.files['image'].read()
    image = prepare_image(image_bytes)

    # Get predictions
    predictions = model.predict(image)
    decoded_predictions = decode_predictions(predictions, top=1)[0][0]
    
    english_category = decoded_predictions[1]  # Predicted class label
    confidence = float(decoded_predictions[2])  # Confidence score

    # Translate category to French using Google Translate
    french_category = translator.translate(english_category, src='en', dest='fr').text

    return jsonify({"category": french_category, "confidence": confidence})

if __name__ == '__main__':
    app.run(debug=True)
