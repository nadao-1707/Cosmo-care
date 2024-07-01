from flask import Flask, jsonify, request
import torch
from torchvision import models, transforms
from PIL import Image

app = Flask(__name__)

# Define paths and variables for model loading
checkpoint_path = 'C:/Users/acer/Documents/GitHub/Cosmo-care/cosmo_care/lib/Services.model.py'
num_classes = 3  # Number of classes: dry, normal, oily

# Load the model
device = torch.device('cpu')  # Load on CPU
model = models.resnet50(pretrained=True)
num_ftrs = model.fc.in_features
model.fc = torch.nn.Linear(num_ftrs, 1000)  # Adjust to match the original pretrained model
state_dict = torch.load(checkpoint_path, map_location=device)

# Check for mismatched keys (due to DataParallel or other reasons)
new_state_dict = {}
for key, value in state_dict.items():
    if key.startswith('module.'):
        new_state_dict[key[7:]] = value  # remove module. prefix
    else:
        new_state_dict[key] = value

# Load state_dict into model (ensure strict=False if some parameters don't match)
model.load_state_dict(new_state_dict, strict=False)

# Modify the fc layer again to fit your specific dataset
model.fc = torch.nn.Linear(num_ftrs, num_classes)

# Set the model to evaluation mode
model.eval()

# Define transformations needed for your model input
transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])


# Function to preprocess an image for model prediction
def preprocess_image(image):
    image = transform(image).unsqueeze(0)
    return image.to(device)


# Mapping of class indices to labels
index_label = {0: "dry", 1: "normal", 2: "oily"}


@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':
        # Ensure that an image file is uploaded
        if 'file' not in request.files:
            return jsonify({'error': 'No file uploaded'})

        file = request.files['file']

        try:
            # Load image from file
            image = Image.open(file.stream)

            # Preprocess the image
            img_tensor = preprocess_image(image)

            # Perform inference
            with torch.no_grad():
                output = model(img_tensor)
                _, predicted = output.max(1)

                # Map predicted index to label
                predicted_label = index_label[predicted.item()]

                # Return the result as JSON response
                return jsonify({'class': predicted_label})

        except Exception as e:
            return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
