##############################
# Author: eeysirhc
# Date written: 2021-04-28
# Objective: fetch daily price data from CoinGecko API
##############################

# LOAD MODULES
import pandas as pd

from pycoingecko import CoinGeckoAPI
cg = CoinGeckoAPI()


# CREATE FUNCTION
def coingecko_fetch(id_coin):

  # GRAB META DATA
  md = cg.get_coins_markets(ids=id_coin, vs_currency='usd')
  md = pd.DataFrame(md, columns=["id", "symbol"])
  md['symbol'] = md['symbol'].str.upper()

  # CREATE DATAFRAME
  df_raw = cg.get_coin_market_chart_by_id(id=id_coin, vs_currency='usd', days='3650')
  p = pd.DataFrame(df_raw['prices'])
  mc = pd.DataFrame(df_raw['market_caps'])
  df = pd.merge(p, mc, how='left', on=0)

  # RENAME COLUMNS
  labels = ['timestamp', 'price', 'market_cap']
  df.columns = labels

  # CLEANUP AND JOIN WITH META DATA
  df['timestamp'] = pd.to_datetime(df['timestamp'], unit="ms")
  df['id'] = id_coin
  df = df.merge(md, how='left', on='id')
  df = df[['timestamp', 'id', 'symbol', 'price', 'market_cap']]

  return(df)


# EXAMPLE
# coingecko_fetch("ergo")
