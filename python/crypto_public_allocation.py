#!/usr/bin/env python
##########
# Note: exported from Jupyter Notebook as .py file
##########

# **Author:** @curbsideprophet
# **Date written:** 2022-01-04
# **Last updated:** 2022-01-05
# **Objective:** visualize the public allocation of various cryptocurrencies
#
# **Description via @Glasgow:**
# This information isn't easy to find - and it should be !
# Please post any additions, corrections, comments, improvements in the comments below (with references if possible).
# Will be amended and added to [linktr.ee](https://linktr.ee/fairstart_crypto)
#
# Source: https://www.reddit.com/r/ergonauts/comments/rwluas/wip_public_allocation_of_various_cryptocurrencies/

# ## Load modules
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set(style='whitegrid')


# ## Generate dataset
labels = ['cryptocurrency', 'public_allocation', 'Segment']

df = [
    ['Polygon', 19, 'ETH L2'],
    ['Polkadot', 25, 'Layer 1'],
    ['Terra', 36, 'Cosmos'],
    ['Ethereum', 36.3, 'Layer 1'],
    ['Avalanche', 39, 'Layer 1'],
    ['Solana', 39, 'Layer 1'],
    ['Tron', 40, 'Layer 1'],
    ['Binance Smart Chain', 50, 'ETH Fork'],
    ['Algorand', 50, 'Layer 1'],
    ['Ripple', 55, 'Layer 1'],
    ['Cosmos', 69, 'Layer 1'],
    ['Cardano', 81, 'Layer 1'],
    ['Uniswap', 60, 'ERC-20'],
    ['Crypto.com', 91, 'Cosmos'],
    ['EOS', 90, 'Layer 1'],
    ['Ergo', 95.57, 'Layer 1'],
    ['Nano', 95, 'Layer 1'],
    ['Litecoin', 100, 'BTC Fork'],
    ['Ravencoin', 100, 'BTC Fork'],
    ['Bitcoin', 100, 'Layer 1']
]

df = pd.DataFrame(df)
df.columns = labels
df = df.sort_values('public_allocation', ascending=False)


# ## Graph data
plt.rcParams["figure.dpi"] = 1000
plt.figure(figsize=(20,15))

g = sns.barplot(x='public_allocation', y='cryptocurrency', data=df, hue='Segment', dodge=False)
#g.bar_label(g.containers[0])

plt.xlabel("Public Allocation (%)")
plt.ylabel("")

plt.show()
