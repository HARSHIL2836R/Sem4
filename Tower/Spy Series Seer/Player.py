import numpy as np
import copy
import matplotlib.pyplot as plt
import torch
import torch.nn as nn
import torch.optim as optim
import sklearn
from sklearn import metrics as metrics
import pandas as pd

def data_loader(path, table_idx, player_or_dealer):
    #utility for loading train.csv, example use in the notebook
    data = pd.read_csv(path, header=[0,1,2])
    spy = data[(f'table_{table_idx}', player_or_dealer, 'spy')]
    card = data[(f'table_{table_idx}', player_or_dealer, 'card')]
    return np.array([spy, card]).T

class MyPlayer:
    def __init__(self,table_index):
        self.table_index = table_index

        # Load training data for both player and dealer streams.
        try:
            self.player_data = data_loader("train.csv", table_index, 'player')
            self.dealer_data = data_loader("train.csv", table_index, 'dealer')
        except Exception as e:
            print("Error loading training data:", e)
            self.player_data = None
            self.dealer_data = None

        # Train autoregressive (AR(5)) linear models for spy forecasting.
        if self.player_data is not None:
            self.player_model = self.train_linear_model(self.player_data[:, 0])
        else:
            self.player_model = None

        if self.dealer_data is not None:
            self.dealer_model = self.train_linear_model(self.dealer_data[:, 0])
        else:
            self.dealer_model = None
        
    def get_card_value_from_spy_value(self,value):
        """
        value: a value from the spy series as a float
        
        It is the same function you found in the previous part
        We will not judge this function in this part, so you can choose the return type as you prefer.
        Only make sure you return the correct value as you will be using this function
        
        The body is random  for now, rewrite accordingly

        Output:
            return a scalar value of the prediction
        """
        return 2 + (value+0.5)%10
        
    def get_player_spy_prediction(self,hist):
        """
        hist a 1D numpy array of size (len_history,) len_history=5
        return a scalar value of the prediction

        The body is random  for now, rewrite accordingly

        Output:
            return a scalar value of the prediction
        """
        if self.player_model is None:
            return 1e6
        return self.predict(self.player_model, hist)

    def get_dealer_spy_prediction(self,hist):
        """
        hist a 1D numpy array of size (len_history,) len_history=5
        
        The body is random  for now, rewrite accordingly

        Output:
            return a scalar value of the prediction
        """
        if self.dealer_model is None:
            return 1e6
        return self.predict(self.dealer_model, hist)


    def train_linear_model(self, series):
        """
        Trains a simple AR(5) linear regression model.
        Given a series of spy values, it builds a design matrix using the previous 5 observations
        and solves for coefficients in the equation:
              spy[t] = w0 * spy[t-5] + ... + w4 * spy[t-1] + bias
        Returns:
            theta: A numpy array of shape (6,) containing the 5 weights and bias term.
        """
        X = []
        y = []
        for t in range(5, len(series)):
            X.append(series[t-5:t])
            y.append(series[t])
        X = np.array(X)  # shape (n, 5)
        y = np.array(y)  # shape (n,)
        # Append a column of ones for the bias term.
        X_design = np.hstack([X, np.ones((X.shape[0], 1))])
        theta, residuals, rank, s = np.linalg.lstsq(X_design, y, rcond=None)
        return theta  # theta[0:5] are weights, theta[5] is bias

    def predict(self, model, hist):
        """
        Computes the predicted spy value given the model coefficients and history.
        """
        # model is an array of shape (6,) where the last element is the bias.
        # hist is a 1D numpy array of length 5.
        return np.dot(hist, model[:5]) + model[5]