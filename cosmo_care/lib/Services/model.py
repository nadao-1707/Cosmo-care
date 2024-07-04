from flask import Flask, request, jsonify
from PIL import Image
import io
import torch
import torchvision.transforms as transforms
import numpy as np
from torchvision.models import efficientnet_v2_s, EfficientNet_V2_S_Weights
import torch.nn as nn

# Initialize the Flask application
app = Flask(__name__)

# Load the model
OUT_CLASSES = 3
device = "cuda" if torch.cuda.is_available() else "cpu"

efficientnet = efficientnet_v2_s(weights=EfficientNet_V2_S_Weights.IMAGENET1K_V1)
num_ftrs = efficientnet.classifier[1].in_features
efficientnet.classifier[1] = nn.Linear(num_ftrs, OUT_CLASSES)
efficientnet.load_state_dict(torch.load('skin_model.pth', map_location=device))
efficientnet.eval()
efficientnet.to(device)

# Define the transform
transform = transforms.Compose([
    transforms.ToPILImage(),
    transforms.ToTensor(),
    transforms.Resize((224, 224)),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

label_index = {0: "dry", 1: "normal", 2: "oily"}

def predict(image_bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    img = transform(np.array(img))
    img = img.unsqueeze(0)  # Add batch dimension

    with torch.no_grad():
        img = img.to(device)
        out = efficientnet(img)
        _, predicted = torch.max(out.data, 1)

    return label_index[predicted.item()]

# Define a route for the default URL, which loads the form
@app.route('/')
def index():
    return "Skin Type Classification API"

# Define a route for the API
@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if file:
        # Check for supported image types
        allowed_extensions = {'jpg', 'jpeg', 'png', 'gif'}
        if '.' in file.filename and file.filename.rsplit('.', 1)[1].lower() not in allowed_extensions:
            return jsonify({'error': 'Unsupported file type'}), 400

        try:
            image_bytes = file.read()
            prediction = predict(image_bytes)
            return jsonify({'prediction': prediction})
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return jsonify({'error': 'Failed to process the file'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
