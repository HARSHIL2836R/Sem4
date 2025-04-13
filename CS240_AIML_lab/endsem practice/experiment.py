import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split

# Generate a custom binary classification dataset
X, y = make_classification(n_samples=1000, n_features=2, n_redundant=0, 
                         n_informative=2, random_state=42, n_clusters_per_class=1)

# Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

class LogisticRegression:
    def __init__(self, learning_rate=0.01, epochs=100):
        self.lr = learning_rate
        self.epochs = epochs
        self.weights = None
        self.bias = None
        self.losses = []

    def sigmoid(self, z):
        return 1 / (1 + np.exp(-z))

    def fit(self, X, y):
        n_samples, n_features = X.shape
        self.weights = np.zeros(n_features)
        self.bias = 0
        
        for _ in range(self.epochs):
            # Forward pass
            z = np.dot(X, self.weights) + self.bias
            y_pred = self.sigmoid(z)
            
            # Calculate loss
            loss = -np.mean(y * np.log(y_pred + 1e-7) + (1 - y) * np.log(1 - y_pred + 1e-7))
            self.losses.append(loss)
            
            # Backward pass
            dz = y_pred - y
            dw = (1/n_samples) * np.dot(X.T, dz)
            db = (1/n_samples) * np.sum(dz)
            
            # Update parameters
            self.weights -= self.lr * dw
            self.bias -= self.lr * db

class NeuralNetwork:
    def __init__(self, input_size, learning_rate=0.01, epochs=100):
        self.lr = learning_rate
        self.epochs = epochs
        self.weights = np.random.randn(input_size, 1) * 0.01
        self.bias = 0
        self.losses = []

    def sigmoid(self, z):
        return 1 / (1 + np.exp(-z))

    def fit(self, X, y):
        y = y.reshape(-1, 1)
        
        for _ in range(self.epochs):
            # Forward pass
            z = np.dot(X, self.weights) + self.bias
            y_pred = self.sigmoid(z)
            
            # Calculate loss
            loss = -np.mean(y * np.log(y_pred + 1e-7) + (1 - y) * np.log(1 - y_pred + 1e-7))
            self.losses.append(loss)
            
            # Backward pass
            dz = (y_pred - y)
            dw = (1/len(y)) * np.dot(X.T, dz)
            db = (1/len(y)) * np.sum(dz)
            
            # Update parameters
            self.weights -= self.lr * dw
            self.bias -= self.lr * db

# Train both models
lr_model = LogisticRegression(learning_rate=0.1, epochs=100)
nn_model = NeuralNetwork(input_size=2, learning_rate=0.1, epochs=100)

lr_model.fit(X_train, y_train)
nn_model.fit(X_train, y_train)

# Plot losses
plt.figure(figsize=(10, 6))
plt.plot(lr_model.losses, label='Logistic Regression')
plt.plot(nn_model.losses, label='Neural Network')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Training Loss Comparison')
plt.legend()
plt.grid(True)
plt.show()