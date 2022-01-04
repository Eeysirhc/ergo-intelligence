"""
Author: eeysirhc
Date written: 2021-01-04
Objective: visualize the public allocation of various cryptocurrencies
"""

##### LOAD MODULES #####
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set(style='darkgrid')


##### GENERATE DATASET #####
labels = ['cryptocurrency', 'public_allocation']

df = [
    ['Polygon', 19],
    ['Polkadot', 25],
    ['Terra', 36],
    ['Ethereum', 36.3],
    ['Avalanche', 39],
    ['Solana', 39],
    ['Tron', 40],
    ['Binance', 50],
    ['Cosmo', 69],
    ['Ripple', 55],
    ['Cardano', 81],
    ['Uniswap', 60],
    ['Algorand', 50],
    ['Crypto.com', 91],
    ['EOS', 90],
    ['Litecoin', 100],
    ['Nano', 95],
    ['Ergo', 95.57],
    ['Ravencoin', 100],
    ['Bitcoin', 100]
]

df = pd.DataFrame(df)

df.columns = labels

df = df.sort_values('public_allocation', ascending=False)



##### GRAPH DATA #####
plt.rcParams["figure.dpi"] = 1000
plt.figure(figsize=(20,15))

g = sns.barplot(x='public_allocation', y='cryptocurrency', data=df)
g.bar_label(g.containers[0])

plt.xlabel("Public Allocation (%)")
plt.ylabel("")

plt.show()
