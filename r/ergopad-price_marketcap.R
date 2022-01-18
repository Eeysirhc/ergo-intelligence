##############################
# Author: eeysirhc
# Date written: 2022-01-18
# Objective: visualize ErgoPad price target vs market capitalization based on launchpad competitors on other blockchains
# References:
## https://ergopad.io/token
## https://www.coingecko.com/en/coins/thorstarter
## https://www.coingecko.com/en/coins/adapad
## https://www.coingecko.com/en/coins/bscpad
## https://www.coingecko.com/en/coins/velaspad
## https://www.coingecko.com/en/coins/polkastarter
##############################


# LOAD PACKAGES
library(tidyverse)
library(scales)

########################################
##### FUNCTION FOR PRICE SIMULATION #####
## TAKES THE HIGH/LOW VALUES AND SIMULATES DATA VIA UNIFORM DISTRIBUTION
price_sim <- function(min_price, max_price){
  values <- runif(1e3, min_price, max_price) %>%
    as_tibble()
}
########################################



# PRICE VARIABLES AS OF 2022-01-18
ergopad_price <- 0.04
ergopad_mcap <- 800000/1e6

xrune <- 0.170756
adapad <- 0.192306
bscpad <- 1.47
vlxpad <- 0.451250
pols <- 2.08

p <- c(xrune, adapad, bscpad, vlxpad, pols)

# SIMULATE DATA
ergopad <- price_sim(min(p), max(p))


# GRAPH: ERGOPAD PRICE TARGETS TO MARKET CAPITLIZATION
ergopad %>%
  mutate(fmcap = (value * ergopad_mcap) / ergopad_price) %>%
  ggplot(aes(value, fmcap)) +
  geom_point(color = 'steelblue') +
  scale_y_continuous(labels = dollar_format(round(2))) +
  scale_x_continuous(labels = dollar_format()) +
  labs(x = "Price", y = "Market Capitalization (millions)",
       subtitle = "Uniform distribution of price averages for $XRUNE, $ADAPAD, $BSCPAD, $VLXPAD, $POLS",
       title = "ErgoPad: potential market capitalization based on price target",
       caption = "$0.04 IDO at $800K market cap") +
  expand_limits(ymin = 0, ymax = 50, xmin = 0, xmax = 2.5) +
  theme_bw(base_size = 15)
