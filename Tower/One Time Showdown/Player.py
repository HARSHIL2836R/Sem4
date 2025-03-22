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
    # utility for loading train.csv, example use in the notebook
    data = pd.read_csv(path, header=[0,1,2])
    spy = data[(f'table_{table_idx}', player_or_dealer, 'spy')]
    card = data[(f'table_{table_idx}', player_or_dealer, 'card')]
    return np.array([spy, card]).T

class MyPlayer:
    def __init__(self, table_index):
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
        
    def get_card_value_from_spy_value(self, value):
        """
        Given a spy value (a float), this function deterministically maps it to its corresponding
        blackjack card value (2–10, with face cards as 10, and Ace as 11). For simplicity,
        this version uses a modulo-based mapping with an offset.
        """
        # Improved deterministic mapping can be implemented here.
        # For now we use a simple transform: ensure result is in {2,...,11}
        card = 2 + int((value + 0.5) % 10)
        # Cap face cards to 10 and aces to 11.
        
        return card
        
    def get_player_spy_prediction(self, hist):
        """
        Given a history (length=5) of player spy values, returns the forecasted next spy value.
        """
        if self.player_model is None:
            return 1e6
        return self.predict(self.player_model, hist)

    def get_dealer_spy_prediction(self, hist):
        """
        Given a history (length=5) of dealer spy values, returns the forecasted next spy value.
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
        Computes the predicted spy value given the model coefficients and a history of 5 values.
        """
        return np.dot(hist, model[:5]) + model[5]

    def get_player_action(self,
                          curr_spy_history_player, 
                          curr_spy_history_dealer, 
                          curr_card_history_player, 
                          curr_card_history_dealer, 
                          curr_player_total, 
                          curr_dealer_total, 
                          turn,
                          game_index,
                          ):
        """
        Arguments:
            curr_spy_history_player: list of spy values observed for the player so far
            curr_spy_history_dealer: list of spy values observed for the dealer so far
            curr_card_history_player: list of card values observed for the player so far
            curr_card_history_dealer: list of card values observed for the dealer so far
            curr_player_total: current total score for the player
            curr_dealer_total: current total score for the dealer
            turn: "player" if it is the player's turn to draw, or "dealer" if it is the dealer's phase
            game_index: an integer denoting which game is ongoing (can be used to reset any game-specific state)
        
        Returns:
            if turn=="player": returns "hit" or "stand"
            if turn=="dealer": returns "surrender" or "continue"
        """
        # ----- PLAYER TURN -----
        if turn == "player":
            # If enough spy history exists, forecast the next spy value and convert to a predicted card.
            if len(curr_spy_history_player) >= 5:
                history = np.array(curr_spy_history_player[-5:])
                pred_spy = self.get_player_spy_prediction(history)
                pred_card = self.get_card_value_from_spy_value(pred_spy)
            else:
                pred_card = 5  # default safe guess
            
            # Conservative strategy:
            # Always hit if total is very low (cannot bust).
            if curr_player_total < 11:
                return "hit"
            # If total is moderately low, hit without too much risk.
            elif curr_player_total < 15:
                return "hit"
            # When in the danger zone (15-17), use forecast and a safety margin.
            elif 15 <= curr_player_total < 18:
                margin = 21 - curr_player_total
                # Only hit if the predicted card is safely below the maximum that could be drawn
                # Here we require a margin of at least 2 points.
                if pred_card <= max(0, margin - 2):
                    return "hit"
                else:
                    return "stand"
            # If total is 18 or above, it's too risky to hit.
            else:
                return "stand"
        
        # ----- DEALER TURN -----
        elif turn == "dealer":
            # If dealer's total is 17 or higher, they have reached a safe zone.
            if curr_dealer_total >= 17:
                return "continue"
            # Use forecast if we have enough history.
            if len(curr_spy_history_dealer) >= 5:
                history = np.array(curr_spy_history_dealer[-5:])
                pred_spy = self.get_dealer_spy_prediction(history)
                pred_card = self.get_card_value_from_spy_value(pred_spy)
            else:
                pred_card = 5  # default safe guess

            # Improved dealer strategy:
            # If dealer's total is less than player's total, attempt to draw if it's safe.
            if curr_dealer_total < curr_player_total:
                # Only continue if drawing the predicted card leaves a safety margin.
                if (curr_dealer_total + pred_card) <= 21 and pred_card <= (21 - curr_dealer_total - 2):
                    return "continue"
                else:
                    return "surrender"
            else:
                # If dealer's total is equal to or exceeds player's, no need to risk drawing further.
                return "surrender"
        else:
            # Fallback action if turn is unrecognized.
            return "stand"
