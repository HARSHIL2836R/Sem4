import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the CSV file
file_path = "./phone_music_usage_april2025.csv"
data = pd.read_csv(file_path,encoding='ISO-8859-1')

# Clean and preprocess the data
data = data.dropna()  # Drop empty rows
# print(data.columns[5])
# print(data.dtypes)
# exit()
# for i in range(1, 7):
#     col = data.columns[i]
#     if data[col].dtype == 'object':  # Ensure the column contains strings
#         data[col] = data[col].str.replace('�', '-').str.split('-').apply(
#             lambda x: (int(x[0]) + int(x[1])) / 2
#         )
#     else:
#         data[col] = pd.to_numeric(data[col],errors='coerce')

import numpy as np
import re

# Function to convert time ranges like '15–30' into their numeric average
def average_range(value):
    if isinstance(value, str):
        # Extract numbers (handling various dash characters)
        numbers = re.findall(r'\d+', value)
        if len(numbers) == 2:
            return (int(numbers[0]) + int(numbers[1])) / 2
        elif len(numbers) == 1:
            return float(numbers[0])
    return np.nan  # fallback for unrecognized format

# Columns to convert
time_of_day_columns = ['Late Night', 'Morning', 'Afternoon', 'Evening']

# Apply conversion
for col in time_of_day_columns:
    data[col] = data[col].apply(average_range)

# Display the cleaned dataframe
# df.head()


# Create a pivot table for visualization
highlight_data = data[list(data.columns)]
highlight_data.set_index('Date', inplace=True)

# Insert an empty row after the date "12-0

# Plot the highlight table
plt.figure(figsize=(10, 6))
sns.heatmap(highlight_data, annot=True, fmt=".0f", cmap="YlGnBu", cbar=True)
plt.title("Highlight Table: Daily Screen Time and Music Time")
plt.xlabel("Metrics")
plt.ylabel("Date")
plt.xticks(rotation=45)
plt.tight_layout()

# Save and show the plot
output_path = "c:\\Users\\Dell\\Documents\\IIT_academics\\Sem 4\\HS312\\Data\\highlight_table.png"
plt.savefig(output_path)
plt.show()