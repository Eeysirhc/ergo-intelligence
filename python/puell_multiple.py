"""
Author: eeysirhc
Date written: 2021-12-20
Objective: calculate the running differential balance of every Ergo wallet address over time
Source: https://www.lookintobitcoin.com/charts/puell-multiple/
Formula:
i = Ergo mined * Ergo price
puell = i / moving_365days_average(i)

In the wild: https://www.reddit.com/r/ergonauts/comments/rhx3ko/ergo_puell_multiple_courtesy_of_ergostats/
"""

##### LOAD MODULES #####
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

##### GRAB DAILY PRICE DATA #####
## use coingeck_fetch.py and save CSV
## needs work: call function directly in this script instead of referencing CSV file
ergo = pd.read_csv("/path/to/file/ergo_history.csv")
ergo = ergo[ergo['symbol'] == 'ERG']
ergo['timestamp'] = pd.to_datetime(ergo['timestamp'])
ergo['date'] = ergo['timestamp']

##### CALCULATE ERGO ISSUANCE PER DAY #####
## use miner_revenue.sql script and save CSV
## needs work: read from postgres database directly instead of referencing CSV file
circ = pd.read_csv("/path/to/file/miner_revenue.csv")
circ = circ[['date', 'miner_revenue']]
circ['date'] = pd.to_datetime(circ['date'])
circ = circ.merge(ergo, on='date')
circ['issuance'] = circ['miner_revenue'] * circ['price']
circ['yoy'] = circ['issuance'].rolling(window=365).mean()
circ['puell'] = circ['issuance'] / circ['yoy']

##### JOIN FINAL DATA FRAME #####
## filter out data when 365 day historical value begins
circ_clean = circ[circ['date'] >= '2020-05-01']


##### PLOT DATA #####
sns.set(style='darkgrid')

plt.clf()
fig, ax = plt.subplots(figsize=(20,15))

sns.lineplot(x='date', y='puell', data=circ_clean, marker='o', label='Puell Multiple')
plt.axhline(y=4.00, color='red', linestyle=':')
plt.axhline(y=0.50, color='green', linestyle=':')

ax2 = plt.twinx()
sns.lineplot(x='date', y='price', data=circ_clean, ax=ax2, color='orange', label='USD Price')

ax.set_ylim(0)
ax.set_xlabel("")
ax.set_ylabel("Puell Multiple")
ax2.set_ylim(0)
ax2.set_ylabel("USD Price")

ax.legend(loc=2)
ax2.legend(loc=0)

plt.show()
