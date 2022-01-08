"""
Author: eeysirhc
Date written: 2022-01-03
Last updated: 2022-01-07
Objective: performance analytics visualization of Ergodex liquidity pool investments

Example CSV header requirements:
date, lp_pair1, lp_pair2
2021-11-17, 0.97906, 8.41
2021-11-27, 1.07014, 7.54
2021-11-28, 1.03666, 7.80
"""

##### LOAD MODULES #####
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from pycoingecko import CoinGeckoAPI
cg = CoinGeckoAPI()

##### LOAD ERGODEX DAILY LIQUIDITY POOL DATA #####
ergodex_data_raw = "/path/to/file/ergodex-data.csv"
ergodex_data = pd.read_csv(ergodex_data_raw)
ergodex_data['date'] = pd.to_datetime(ergodex_data['date'])

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
##############################

##### GRAB ERGO DATA FROM COINGECKO #####
ergo = coingecko_fetch("ergo")
ergo.rename(columns = {'timestamp': 'date'}, inplace = True)


##### FUNCTION TO COMPUTE AND JOIN DATAFRAMES #####
def ergodex_analytics(df):

    df_final = df.merge(ergo, how='left', on='date')

    # SET STATIC VARIABLES FOR INITIAL INVESTMENT
    ilp1 = df_final.lp_pair1[0]
    ilp2 = df_final.lp_pair2[0]
    ilp_ratio = ilp1 / ilp2
    ilp_price = df_final.price[0]

    # CALCULATE PERFORMANCE ANALYTICS
    df_final['ratio'] = df_final.lp_pair1 / df_final.lp_pair2
    df_final['lp_value1'] = df_final.lp_pair1 * df_final.price
    df_final['lp_value2'] = df_final.lp_pair2 * df_final.price * df_final.ratio
    df_final['lp_investment'] = df_final.lp_value1 + df_final.lp_value2
    df_final['hodl_instead'] = (ilp1 * df_final.price) + (ilp2 * df_final.price * ilp_ratio)
    df_final['erg_diff'] = 100 * (df_final.price / ilp_price - 1)
    df_final['lp_vs_hodl'] = 100 * (df_final.lp_investment / df_final.hodl_instead - 1)

    return(df_final)
##############################


##### FINALIZE DATA FRAME #####
ergodex = ergodex_analytics(ergodex_data)
ergodex = ergodex.iloc[1:]



##### GRAPHING REGION #####

plt.rcParams["figure.dpi"] = 1000

fig = plt.figure(figsize=(20,15))

### SCATTERPLOT OF PRICE DELTA VS LP/HOLD ###
ax1 = fig.add_subplot(2, 1, 1)
ax1 = sns.scatterplot(data=ergodex, x="erg_diff", y="lp_vs_hodl", s=100)
ax1.axhline(0, color='grey', linestyle=':')
ax1.axvline(0, color='grey', linestyle=':')
ax1.set_xlabel("ERG Price change (%)")
ax1.set_ylabel("LP vs HODL (%)")
ax1.set_xlim(-60, 60)
ax1.set_ylim(-60, 60)

### TIME SERIES OF LP VS HODL ###
ax2 = fig.add_subplot(2, 1, 2)
ax2 = sns.lineplot(data=ergodex, x="date", y="lp_investment", marker="o", color='steelblue', label="LP Investment")
ax2 = sns.lineplot(data=ergodex, x="date", y="hodl_instead", marker="o", color='red', label="HODL Instead")
ax2.set_xlabel("")
ax2.set_ylabel("USD Value")
ax2.set_ylim(0, 20)

plt.show()
