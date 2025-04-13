import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split


class LinearRegression:
    """
    Manual implementation of Linear Regression using gradient descent.
    """
    def __init__(self, learning_rate=0.01, n_iterations=1000):
        self.learning_rate = learning_rate
        self.n_iterations = n_iterations
        self.weights = None
        self.bias = None
        self.cost_history = []
        
    def fit(self, X, y):
        # Initialize parameters
        n_samples, n_features = X.shape
        self.weights = np.zeros(n_features)
        self.bias = 0
        
        # Normalize features to improve convergence and numerical stability
        self.X_mean = np.mean(X, axis=0)
        self.X_std = np.std(X, axis=0) + 1e-8  # Add small epsilon to avoid division by zero
        X_normalized = (X - self.X_mean) / self.X_std
        
        # Gradient descent
        for i in range(self.n_iterations):
            # Linear model: y_pred = X.W + b
            y_pred = np.dot(X_normalized, self.weights) + self.bias
            
            # Compute gradients
            dw = (1/n_samples) * np.dot(X_normalized.T, (y_pred - y))
            db = (1/n_samples) * np.sum(y_pred - y)
            
            # Update parameters
            self.weights -= self.learning_rate * dw
            self.bias -= self.learning_rate * db
            
            # Compute cost for monitoring
            cost = (1/(2*n_samples)) * np.sum((y_pred - y)**2)
            self.cost_history.append(cost)
        
        return self
    
    def predict(self, X):
        # Normalize the input features using same parameters as in training
        X_normalized = (X - self.X_mean) / self.X_std
        return np.dot(X_normalized, self.weights) + self.bias
    
    def predict(self, X):
        return np.dot(X, self.weights) + self.bias


class PolynomialRegression:
    """
    Manual implementation of Polynomial Regression.
    This actually transforms the features and then applies linear regression.
    """
    def __init__(self, degree=2, learning_rate=0.01, n_iterations=1000):
        self.degree = degree
        self.linear_regression = LinearRegression(
            learning_rate=learning_rate, 
            n_iterations=n_iterations
        )
        
    def transform_features(self, X):
        """
        Transform features to include polynomial terms up to specified degree.
        If X is 1D, we create [x, x^2, x^3, ..., x^degree].
        If X is multi-dimensional, we create polynomial features for each dimension.
        """
        if len(X.shape) == 1:
            X = X.reshape(-1, 1)
            
        n_samples, n_features = X.shape
        X_poly = np.ones((n_samples, 1))  # Start with a column of ones (for bias)
        
        # Scale down features to prevent numerical overflow
        X_scaled = X / np.max(np.abs(X), axis=0)
        
        for i in range(1, self.degree + 1):
            for feature in range(n_features):
                X_poly = np.column_stack((X_poly, X_scaled[:, feature] ** i))
                
        return X_poly[:, 1:]  # Remove the first column of ones
    
    def fit(self, X, y):
        X_poly = self.transform_features(X)
        self.linear_regression.fit(X_poly, y)
        return self
    
    def predict(self, X):
        X_poly = self.transform_features(X)
        return self.linear_regression.predict(X_poly)


class RidgeRegression:
    """
    Manual implementation of Ridge Regression (L2 regularization).
    """
    def __init__(self, alpha=1.0, learning_rate=0.01, n_iterations=1000):
        self.alpha = alpha  # Regularization strength
        self.learning_rate = learning_rate
        self.n_iterations = n_iterations
        self.weights = None
        self.bias = None
        self.cost_history = []
        
    def fit(self, X, y):
        # Initialize parameters
        n_samples, n_features = X.shape
        self.weights = np.zeros(n_features)
        self.bias = 0
        
        # Gradient descent
        for i in range(self.n_iterations):
            # Linear model: y_pred = X.W + b
            y_pred = np.dot(X, self.weights) + self.bias
            
            # Compute gradients (with L2 regularization)
            dw = (1/n_samples) * (np.dot(X.T, (y_pred - y)) + self.alpha * self.weights)
            db = (1/n_samples) * np.sum(y_pred - y)  # No regularization for bias
            
            # Update parameters
            self.weights -= self.learning_rate * dw
            self.bias -= self.learning_rate * db
            
            # Compute cost (with L2 regularization)
            mse = (1/n_samples) * np.sum((y_pred - y)**2)
            l2_reg = (self.alpha / (2*n_samples)) * np.sum(self.weights**2)
            cost = mse + l2_reg
            self.cost_history.append(cost)
        
        return self
    
    def predict(self, X):
        return np.dot(X, self.weights) + self.bias


class LassoRegression:
    """
    Manual implementation of Lasso Regression (L1 regularization).
    """
    def __init__(self, alpha=1.0, learning_rate=0.01, n_iterations=1000):
        self.alpha = alpha  # Regularization strength
        self.learning_rate = learning_rate
        self.n_iterations = n_iterations
        self.weights = None
        self.bias = None
        self.cost_history = []
        
    def fit(self, X, y):
        # Initialize parameters
        n_samples, n_features = X.shape
        self.weights = np.zeros(n_features)
        self.bias = 0
        
        # Gradient descent
        for i in range(self.n_iterations):
            # Linear model: y_pred = X.W + b
            y_pred = np.dot(X, self.weights) + self.bias
            
            # Compute gradients (with L1 regularization)
            dw = (1/n_samples) * np.dot(X.T, (y_pred - y))
            
            # Add L1 gradient (subgradient approach for L1)
            l1_grad = np.zeros(n_features)
            for j in range(n_features):
                if self.weights[j] > 0:
                    l1_grad[j] = 1
                elif self.weights[j] < 0:
                    l1_grad[j] = -1
                else:
                    l1_grad[j] = 0
                    
            dw += (self.alpha / n_samples) * l1_grad
            db = (1/n_samples) * np.sum(y_pred - y)  # No regularization for bias
            
            # Update parameters
            self.weights -= self.learning_rate * dw
            self.bias -= self.learning_rate * db
            
            # Compute cost (with L1 regularization)
            mse = (1/n_samples) * np.sum((y_pred - y)**2)
            l1_reg = (self.alpha / n_samples) * np.sum(np.abs(self.weights))
            cost = mse + l1_reg
            self.cost_history.append(cost)
        
        return self
    
    def predict(self, X):
        return np.dot(X, self.weights) + self.bias


class ElasticNetRegression:
    """
    Manual implementation of ElasticNet Regression (combination of L1 and L2).
    """
    def __init__(self, alpha=1.0, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000):
        self.alpha = alpha  # Regularization strength
        self.l1_ratio = l1_ratio  # Mix ratio between L1 and L2 (1 = Lasso, 0 = Ridge)
        self.learning_rate = learning_rate
        self.n_iterations = n_iterations
        self.weights = None
        self.bias = None
        self.cost_history = []
        
    def fit(self, X, y):
        # Initialize parameters
        n_samples, n_features = X.shape
        self.weights = np.zeros(n_features)
        self.bias = 0
        
        # Gradient descent
        for i in range(self.n_iterations):
            # Linear model: y_pred = X.W + b
            y_pred = np.dot(X, self.weights) + self.bias
            
            # Compute gradients (with combined L1 and L2 regularization)
            dw_mse = (1/n_samples) * np.dot(X.T, (y_pred - y))
            
            # L1 component (subgradient)
            dw_l1 = np.zeros(n_features)
            for j in range(n_features):
                if self.weights[j] > 0:
                    dw_l1[j] = 1
                elif self.weights[j] < 0:
                    dw_l1[j] = -1
                else:
                    dw_l1[j] = 0
            
            # L2 component
            dw_l2 = self.weights
            
            # Combine gradients
            dw = dw_mse + (self.alpha * self.l1_ratio * dw_l1) / n_samples + \
                 (self.alpha * (1 - self.l1_ratio) * dw_l2) / n_samples
            
            db = (1/n_samples) * np.sum(y_pred - y)  # No regularization for bias
            
            # Update parameters
            self.weights -= self.learning_rate * dw
            self.bias -= self.learning_rate * db
            
            # Compute cost (with combined regularization)
            mse = (1/n_samples) * np.sum((y_pred - y)**2)
            l1_reg = (self.alpha * self.l1_ratio / n_samples) * np.sum(np.abs(self.weights))
            l2_reg = (self.alpha * (1 - self.l1_ratio) / (2*n_samples)) * np.sum(self.weights**2)
            cost = mse + l1_reg + l2_reg
            self.cost_history.append(cost)
        
        return self
    
    def predict(self, X):
        return np.dot(X, self.weights) + self.bias


class LogisticRegression:
    """
    Manual implementation of Logistic Regression for binary classification.
    """
    def __init__(self, learning_rate=0.01, n_iterations=1000):
        self.learning_rate = learning_rate
        self.n_iterations = n_iterations
        self.weights = None
        self.bias = None
        self.cost_history = []
        
    def sigmoid(self, z):
        """Sigmoid activation function"""
        # Clip to avoid overflow
        z = np.clip(z, -500, 500)
        return 1 / (1 + np.exp(-z))
    
    def fit(self, X, y):
        # Initialize parameters
        n_samples, n_features = X.shape
        self.weights = np.zeros(n_features)
        self.bias = 0
        
        # Gradient descent
        for i in range(self.n_iterations):
            # Model: sigmoid(X.W + b)
            linear_model = np.dot(X, self.weights) + self.bias
            y_pred = self.sigmoid(linear_model)
            
            # Compute gradients
            dw = (1/n_samples) * np.dot(X.T, (y_pred - y))
            db = (1/n_samples) * np.sum(y_pred - y)
            
            # Update parameters
            self.weights -= self.learning_rate * dw
            self.bias -= self.learning_rate * db
            
            # Compute binary cross entropy cost
            epsilon = 1e-15  # To avoid log(0)
            y_pred = np.clip(y_pred, epsilon, 1 - epsilon)
            cost = (-1/n_samples) * np.sum(y * np.log(y_pred) + (1 - y) * np.log(1 - y_pred))
            self.cost_history.append(cost)
        
        return self
    
    def predict_proba(self, X):
        """Return probability estimates"""
        linear_model = np.dot(X, self.weights) + self.bias
        return self.sigmoid(linear_model)
    
    def predict(self, X, threshold=0.5):
        """Return class predictions"""
        return (self.predict_proba(X) >= threshold).astype(int)


# --------------------------
# EXAMPLE USAGE
# --------------------------

def generate_linear_data(n_samples=100, n_features=1, noise=0.1):
    """Generate synthetic linear data for regression examples"""
    X = np.random.randn(n_samples, n_features)
    true_weights = np.random.randn(n_features)
    true_bias = np.random.randn()
    y = np.dot(X, true_weights) + true_bias + noise * np.random.randn(n_samples)
    return X, y, true_weights, true_bias

def generate_polynomial_data(n_samples=100, degree=2, noise=0.1):
    """Generate synthetic polynomial data"""
    # Use a smaller range to prevent numerical instability
    X = np.linspace(-3, 3, n_samples).reshape(-1, 1)
    y = np.zeros(n_samples)
    
    # Generate the polynomial with controlled coefficients
    np.random.seed(42)  # For reproducibility
    for i in range(degree + 1):
        # Smaller coefficients for higher powers to prevent overflow
        coef = np.random.randn() / (i + 1)
        y += coef * (X.flatten() ** i)
    
    # Add noise
    y += noise * np.random.randn(n_samples)
    return X, y

def generate_classification_data(n_samples=100, n_features=2, separability=1.0):
    """Generate synthetic binary classification data"""
    X = np.random.randn(n_samples, n_features)
    true_weights = separability * np.random.randn(n_features)
    true_bias = separability * np.random.randn()
    logits = np.dot(X, true_weights) + true_bias
    probabilities = 1 / (1 + np.exp(-logits))
    y = (np.random.rand(n_samples) < probabilities).astype(int)
    return X, y

def demo_linear_regression():
    """Demonstrate linear regression implementation"""
    print("\n----- Linear Regression Demo -----")
    X, y, true_weights, true_bias = generate_linear_data(n_samples=200, n_features=1)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Fit model
    model = LinearRegression(learning_rate=0.01, n_iterations=1000)
    model.fit(X_train, y_train)
    
    # Make predictions
    y_pred = model.predict(X_test)
    
    # Evaluate
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    
    print(f"True weights: {true_weights}, True bias: {true_bias}")
    print(f"Learned weights: {model.weights}, Learned bias: {model.bias}")
    print(f"MSE: {mse:.4f}, R²: {r2:.4f}")
    
    # Plot results
    plt.figure(figsize=(10, 6))
    
    plt.subplot(1, 2, 1)
    plt.scatter(X_test, y_test, color='blue', label='Actual')
    plt.scatter(X_test, y_pred, color='red', label='Predicted')
    plt.plot(X_test, y_pred, color='green', label='Regression Line')
    plt.title('Linear Regression Predictions vs Actual')
    plt.xlabel('X')
    plt.ylabel('y')
    plt.legend()
    
    plt.subplot(1, 2, 2)
    plt.plot(model.cost_history)
    plt.title('Cost History')
    plt.xlabel('Iteration')
    plt.ylabel('Cost')
    
    plt.tight_layout()
    plt.savefig('linear_regression_demo.png')

def demo_polynomial_regression():
    """Demonstrate polynomial regression implementation"""
    print("\n----- Polynomial Regression Demo -----")
    X, y = generate_polynomial_data(n_samples=200, degree=3, noise=0.5)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Fit model
    model = PolynomialRegression(degree=3, learning_rate=0.001, n_iterations=2000)
    model.fit(X_train, y_train)
    
    # Make predictions
    y_pred = model.predict(X_test)
    
    # Handle any NaN values in predictions
    if np.isnan(y_pred).any():
        print("Warning: NaN values detected in predictions. Replacing with mean value.")
        mean_val = np.nanmean(y_pred)
        y_pred = np.nan_to_num(y_pred, nan=mean_val)
    
    # Evaluate
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    
    print(f"MSE: {mse:.4f}, R²: {r2:.4f}")
    
    # Plot results
    plt.figure(figsize=(10, 6))
    
    plt.subplot(1, 2, 1)
    # Sort for proper line plotting
    sort_idx = np.argsort(X_test.flatten())
    plt.scatter(X_test, y_test, color='blue', label='Actual')
    plt.plot(X_test[sort_idx], y_pred[sort_idx], color='red', label='Polynomial Fit')
    plt.title('Polynomial Regression Predictions vs Actual')
    plt.xlabel('X')
    plt.ylabel('y')
    plt.legend()
    
    plt.subplot(1, 2, 2)
    plt.plot(model.linear_regression.cost_history)
    plt.title('Cost History')
    plt.xlabel('Iteration')
    plt.ylabel('Cost')
    
    plt.tight_layout()
    plt.savefig('polynomial_regression_demo.png')

def demo_regularized_regression():
    """Demonstrate Ridge, Lasso, and ElasticNet regression"""
    print("\n----- Regularized Regression Demo -----")
    # Generate data with many features
    X, y, true_weights, true_bias = generate_linear_data(n_samples=200, n_features=20, noise=0.5)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Models to compare
    models = {
        "Linear": LinearRegression(learning_rate=0.01, n_iterations=1000),
        "Ridge": RidgeRegression(alpha=1.0, learning_rate=0.01, n_iterations=1000),
        "Lasso": LassoRegression(alpha=0.1, learning_rate=0.01, n_iterations=1000),
        "ElasticNet": ElasticNetRegression(alpha=0.5, l1_ratio=0.5, learning_rate=0.01, n_iterations=1000)
    }
    
    # Train and evaluate each model
    results = {}
    for name, model in models.items():
        model.fit(X_train, y_train)
        y_pred = model.predict(X_test)
        mse = mean_squared_error(y_test, y_pred)
        r2 = r2_score(y_test, y_pred)
        results[name] = {"mse": mse, "r2": r2, "weights": model.weights}
        print(f"{name} - MSE: {mse:.4f}, R²: {r2:.4f}")
    
    # Plot comparison of weights
    plt.figure(figsize=(12, 6))
    
    for i, (name, result) in enumerate(results.items()):
        plt.subplot(2, 2, i+1)
        plt.stem(result["weights"])
        plt.title(f"{name} Regression: Learned Weights")
        plt.xlabel("Feature Index")
        plt.ylabel("Weight Value")
    
    plt.tight_layout()
    plt.savefig('regularized_regression_demo.png')

def demo_logistic_regression():
    """Demonstrate logistic regression implementation"""
    print("\n----- Logistic Regression Demo -----")
    X, y = generate_classification_data(n_samples=200, n_features=2, separability=2.0)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Fit model
    model = LogisticRegression(learning_rate=0.1, n_iterations=1000)
    model.fit(X_train, y_train)
    
    # Make predictions
    y_pred = model.predict(X_test)
    
    # Evaluate
    accuracy = np.mean(y_pred == y_test)
    print(f"Accuracy: {accuracy:.4f}")
    
    # Plot decision boundary
    plt.figure(figsize=(10, 6))
    
    plt.subplot(1, 2, 1)
    # Create a mesh grid for visualization
    h = 0.02  # Step size
    x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
    
    # Plot decision boundary
    Z = model.predict(np.c_[xx.ravel(), yy.ravel()])
    Z = Z.reshape(xx.shape)
    plt.contourf(xx, yy, Z, alpha=0.3)
    
    # Plot training points
    scatter = plt.scatter(X_test[:, 0], X_test[:, 1], c=y_test, edgecolors='k', marker='o')
    plt.title('Logistic Regression Decision Boundary')
    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    
    plt.subplot(1, 2, 2)
    plt.plot(model.cost_history)
    plt.title('Cost History')
    plt.xlabel('Iteration')
    plt.ylabel('Cost')
    
    plt.tight_layout()
    plt.savefig('logistic_regression_demo.png')

if __name__ == "__main__":
    demo_linear_regression()
    demo_polynomial_regression()
    demo_regularized_regression()
    demo_logistic_regression()
    
    print("\nAll demonstrations completed. Check the output images for visualization.")