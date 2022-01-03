"""
Author: eeysirhc
Date written: 2022-01-03
Objective: performance analytics visualization of Ergodex liquidity pool investments
"""

##### LOAD MODULES #####
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from pycoingecko import CoinGeckoAPI
cg = CoinGeckoAPI()

##### LOAD ERGODEX DAILY LIQUIDITY POOL DATA #####
ergodex_data = "/path/to/file/ergodex-data.csv"
df = pd.read_csv(ergodex_data)
df['date'] = pd.to_datetime(df['date'])

##### FUNCTION FOR DAILY PRICE DATA #####
def coingecko_fetch(id_coin):

  # GRAB META DATA
  md = cg.get_coins_markets(ids=id_coin, vs_currency='usd')
  md = pd.DataFrame(md, columns=["id", "symbol"])
  md['symbol'] = md['symbol'].str.upper()

  # CREATE DATAFRAME
  df_raw = cg.get_coin_market_chart_by_id(id=id_coin, vs_currency='usd', days='3650')
  df = pd.DataFrame(df_raw['prices'])

  # RENAME COLUMNS
  labels = ['timestamp', 'price']
  df.columns = labels

  # CLEANUP AND JOIN WITH META DATA
  df['timestamp'] = pd.to_datetime(df['timestamp'], unit="ms")
  df['id'] = id_coin
  df = df.merge(md, how='left', on='id')
  df = df[['timestamp', 'price']]

  return(df)

##### GRAB ERGO DATA FROM COINGECKO #####
ergo = coingecko_fetch("ergo")
ergo.rename(columns = {'timestamp': 'date'}, inplace = True)


##### JOIN DATA FRAMES #####
df_final = df.merge(ergo, how='left', on='date')


##### SET STATIC VARIABLES FOR INITIAL INVESTMENT #####
ilp1 = df_final.lp_pair1[0]
ilp2 = df_final.lp_pair2[0]
ilp_ratio = ilp1 / ilp2
ilp_price = df_final.price[0]

##### CALCULATE PERFORMANCE ANALYTICS #####
df_final['ratio'] = df_final.lp_pair1 / df_final.lp_pair2
df_final['lp_value1'] = df_final.lp_pair1 * df_final.price
df_final['lp_value2'] = df_final.lp_pair2 * df_final.price * df_final.ratio
df_final['lp_investment'] = df_final.lp_value1 + df_final.lp_value2
df_final['hodl_instead'] = (ilp1 * df_final.price) + (ilp2 * df_final.price * ilp_ratio)
df_final['erg_diff'] = 100 * (df_final.price / ilp_price - 1)
df_final['lp_vs_hodl'] = 100 * (df_final.lp_investment / df_final.hodl_instead - 1)


##### GRAPH: SCATTERPLOT OF PRICE DELTA VS LP/HODL #####
df_clean = df_final.iloc[1:]

plt.clf()
plt.figure(figsize=(20,15))

sns.scatterplot(data=df_clean, x="erg_diff", y="lp_vs_hodl", s=100)

plt.axhline(0, color='grey', linestyle=':')
plt.axvline(0, color='grey', linestyle=':')
plt.xlim(-50, 50)
plt.ylim(-50, 50)
plt.xlabel("ERG price change (%)")
plt.ylabel("LP vs HODL (%)")

plt.show()



##### GRAPH: TIME SERIES OF LP VS HODL #####
plt.clf()
plt.figure(figsize=(20,15))

sns.lineplot(data=df_final, x="date", y="lp_investment", marker="o", color='steelblue', label="LP Investment")
sns.lineplot(data=df_final, x="date", y="hodl_instead", marker="o", color='red', label="HODL Instead")

plt.ylim(0, 20)
plt.xlabel("")
plt.ylabel("USD Value")

plt.show()
