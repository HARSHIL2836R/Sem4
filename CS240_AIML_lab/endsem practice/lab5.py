import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# # Function to one-hot encode the target variable into the 10 classes (0-9)
# # Input shape: (N,),    Output: (N, 10)
# def one_hot(Y):
#     one_hot_Y = np.zeros((Y.size, 10))
#     one_hot_Y[np.arange(Y.size), Y] = 1
#     return one_hot_Y

# # Loading the MNIST dataset
# train_data=pd.read_csv(r"./mnist_train.csv")
# test_data=pd.read_csv(r"./mnist_test.csv")

# # Preprocessing the data
# train_data=train_data.to_numpy()    # train_data shape: (60000, 785)
# test_data=test_data.to_numpy()      # test_data shape: (10000, 785)

# X_train=train_data[:,1:]            # X_train shape: (60000, 784)
# y_train=train_data[:,0]             # y_train shape: (60000,)
# X_test=test_data[:,1:]              # X_test shape: (10000, 784)
# y_test=test_data[:,0]               # y_test shape: (10000,)

# X_train = X_train / 255.0           # Normalizing the data
# X_test = X_test / 255.0

# one_hot_y_train = one_hot(y_train)  # one_hot_y_train shape: (60000, 10)
# one_hot_y_test = one_hot(y_test)    # one_hot_y_test shape: (10000, 10)

import numpy as np

def sigmoid(z):
    return 1 / (1 + np.exp(-z))

def sigmoid_deriv(a):
    return a * (1 - a)

def relu(z):
    return np.maximum(0, z)

def relu_deriv(a):
    return np.where(a > 0, 1, 0)

def softmax(z):
    exps = np.exp(z - np.max(z, axis=1, keepdims=True))
    return exps / np.sum(exps, axis=1, keepdims=True)

def cross_entropy(predictions, labels):
    m = labels.shape[0]
    return -np.sum(labels * np.log(predictions + 1e-9)) / m

def one_hot(y, num_classes):
    return np.eye(num_classes)[y]

class NeuralNetwork:
    def __init__(self, layer_sizes, activations):
        """
        layer_sizes: List[int] – sizes of input, hidden, and output layers.
        activations: List[str] – activation functions for each layer except input.
                                Supported: 'sigmoid', 'relu', 'softmax'
        """
        self.L = len(layer_sizes) - 1
        self.activations = activations
        self.weights = []
        self.biases = []
        
        for i in range(self.L):
            w = np.random.randn(layer_sizes[i], layer_sizes[i+1]) * np.sqrt(2. / layer_sizes[i])
            b = np.zeros((1, layer_sizes[i+1]))
            self.weights.append(w)
            self.biases.append(b)

    def activation(self, z, func):
        if func == 'sigmoid': return sigmoid(z)
        if func == 'relu': return relu(z)
        if func == 'softmax': return softmax(z)
        raise ValueError("Unsupported activation.")

    def activation_deriv(self, a, func):
        if func == 'sigmoid': return sigmoid_deriv(a)
        if func == 'relu': return relu_deriv(a)
        raise ValueError("Derivative not supported for this activation.")

    def forward(self, X):
        A = X
        activations = [A]
        zs = []

        for i in range(self.L):
            Z = A @ self.weights[i] + self.biases[i]
            A = self.activation(Z, self.activations[i])
            zs.append(Z)
            activations.append(A)
        return activations, zs

    def backward(self, X, Y, activations, zs, lr):
        m = X.shape[0]
        deltas = [None] * self.L

        # Compute delta for output layer
        if self.activations[-1] == 'softmax':
            deltas[-1] = activations[-1] - Y
        else:
            delta = (activations[-1] - Y)
            deltas[-1] = delta * self.activation_deriv(activations[-1], self.activations[-1])

        # Backpropagate
        for l in reversed(range(self.L - 1)):
            d = deltas[l + 1] @ self.weights[l + 1].T
            deltas[l] = d * self.activation_deriv(activations[l + 1], self.activations[l])

        # Gradient descent update
        for l in range(self.L):
            dw = activations[l].T @ deltas[l] / m
            db = np.mean(deltas[l], axis=0, keepdims=True)
            self.weights[l] -= lr * dw
            self.biases[l] -= lr * db

    def train(self, X, Y, epochs=1000, lr=0.01, verbose=False):
        for epoch in range(epochs):
            activations, zs = self.forward(X)
            self.backward(X, Y, activations, zs, lr)

            if verbose and epoch % 100 == 0:
                loss = cross_entropy(activations[-1], Y)
                print(f"Epoch {epoch} – Loss: {loss:.4f}")

    def predict(self, X):
        A, _ = self.forward(X)
        return np.argmax(A[-1], axis=1)

    def test(self, X, Y):
        preds = self.predict(X)
        true = np.argmax(Y, axis=1)
        accuracy = np.mean(preds == true)
        print(f"Predictions: {preds}")
        print(f"Actual Values: {true}")
        print(f"Test Accuracy: {accuracy * 100:.2f}%")
        return accuracy


# Sample XOR-like dataset (for classification)
X = np.array([
    [0, 0],
    [0, 1],
    [1, 0],
    [1, 1]
])
y = np.array([0, 1, 1, 0])
Y = one_hot(y, 2)

# Define network with 1 hidden layer (2 neurons) using ReLU and softmax output
nn = NeuralNetwork(layer_sizes=[2, 4, 2], activations=['relu', 'softmax'])
nn.train(X, Y, epochs=1000, lr=0.1, verbose=True)

# Test
nn.test(X, Y)
