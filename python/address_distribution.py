"""
Author: eeysirhc
Date written: 2021-12-20
Objective: visualize Ergo wallet distribution to find the average mean of all holders
"""

# LOAD MODULES
import vaex
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticer as ticker
import seaborn as sns


# IMPORT AND SANITIZE DATA
## use address_balance.sql script and save CSV
## needs work: read from postgres database directly instead of referencing CSV file
df_raw = vaex.from_csv("/path/to/file/address_balance.csv", parse_dates=['date'], copy_index=False)

## calculate running balance per day for each Ergo address
df = df_raw.groupby(df=('address', 'date'), agg={'balance': vaex.agg.sum('diff')})
df = df.sort('date', ascending=True)
df = df.to_pandas_df(['address', 'date', 'balance'])

## finalize the cumulative total for every Ergo address
df['tally'] = df.groupby(['address'])['balance'].cumsum()


# CLASSIFY WALLET SEGMENTATION
## needs work: use % distribution instead of raw values
df['segment'] = 'whale'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'plankton'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'shrimp'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'crab'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'lobster'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'octopus'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'fish'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'dolphin'
df.loc[df['tally'].between(1, 10, inclusive=True), 'segment'] = 'shark'


# FIND AVERAGE MEAN OF ALL ERGO ADDRESSES
avg = df[df['date'] == '2021-12-20']
avg = avg[avg['tally'] > 0]
avg = avg.tally.mean()


# FINALIZE DATA FRAMES
df_final = df.drop_duplicates(['address'], keep='last')
df_final = df_final[df_final['tally'] >= 1]


# PLOT DATA
plt.clf()
plt.figure(figsize=(20,15))

ax = sns.histplot(data=df_final, x='tally', hue='segment', bins=200, log_scale=True)
ax.xaxis.set_major_formatter(ticker.FuncFormatter(lambda x, _: '{:g}'.format(x)))

plt.title("Ergo: wallet size distribution as of 2021-12-20 \n $ERG wallet average = 397", fontsize=20)
plt.xlabel("Wallet Size (log-scale)")
plt.ylabel("")

plt.show()
