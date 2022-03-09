##############################
# Author: eeysirhc
# Date written: 2021-12-22
# Objective: visualize the Ergo emission schedule
# Reference: https://ergoplatform.org/docs/whitepaper.pdf
##############################


# LOAD PACKAGES
library(tidyverse)
library(scales)

# STATIC VALUES
## START BLOCK REDUCTION
top_end <- 720000
## BLOCK DAMEPENER
dampen <- 64800
## MAX BLOCKs
b_max <- 2080800

# GENERATE BLOCK HEIGHT
b <- seq(1, b_max, 1) %>% 
  as_tibble() %>% 
  rename(block = value)

# MINER SCHEDULE
m <- b %>% 
  mutate(miner_rewards = case_when(block >= 1 & block <= 655199 ~ 67.5,
                                   block >= 655200 & block <= 719999 ~ 66,
                                   block >= top_end+(dampen*0) & block < top_end+(dampen*1) ~ 63.00,
                                   block >= top_end+(dampen*1) & block < top_end+(dampen*2) ~ 60.00,
                                   block >= top_end+(dampen*2) & block < top_end+(dampen*3) ~ 57.00,
                                   block >= top_end+(dampen*3) & block < top_end+(dampen*4) ~ 54.00,
                                   block >= top_end+(dampen*4) & block < top_end+(dampen*5) ~ 51.00,
                                   block >= top_end+(dampen*5) & block < top_end+(dampen*6) ~ 48.00,
                                   block >= top_end+(dampen*6) & block < top_end+(dampen*7) ~ 45.00,
                                   block >= top_end+(dampen*7) & block < top_end+(dampen*8) ~ 42.00,
                                   block >= top_end+(dampen*8) & block < top_end+(dampen*9) ~ 39.00,
                                   block >= top_end+(dampen*9) & block < top_end+(dampen*10) ~ 36.00,
                                   block >= top_end+(dampen*10) & block < top_end+(dampen*11) ~ 33.00,
                                   block >= top_end+(dampen*11) & block < top_end+(dampen*12) ~ 30.00,
                                   block >= top_end+(dampen*12) & block < top_end+(dampen*13) ~ 27.00,
                                   block >= top_end+(dampen*13) & block < top_end+(dampen*14) ~ 24.00,
                                   block >= top_end+(dampen*14) & block < top_end+(dampen*15) ~ 21.00,
                                   block >= top_end+(dampen*15) & block < top_end+(dampen*16) ~ 18.00,
                                   block >= top_end+(dampen*16) & block < top_end+(dampen*17) ~ 15.00,
                                   block >= top_end+(dampen*17) & block < top_end+(dampen*18) ~ 12.00,
                                   block >= top_end+(dampen*18) & block < top_end+(dampen*19) ~ 9.00,
                                   block >= top_end+(dampen*19) & block < top_end+(dampen*20) ~ 6.00,
                                   block >= top_end+(dampen*20) & block < b_max ~ 3.00,
                                   block >= b_max ~ 0)) %>% 
  mutate(miner_cumulative = cumsum(miner_rewards))

# TREASURY SCHEDULE
t <- b %>% 
  mutate(treasury = case_when(block >= 1 & block <= 525599 ~ 7.5,
                              block >= 525600 & block <= 590399 ~ 4.5,
                              block >= 590400 & block <= 655199 ~ 1.5,
                              TRUE ~ 0)) %>% 
  mutate(treasury_cumulative = cumsum(treasury))

# COMBINED DATA FRAME
ergo <- m %>% 
  left_join(t) %>% 
  mutate(total_supply = miner_cumulative + treasury_cumulative)

# PLOT DATA
ggplot() +
  geom_line(aes(ergo$block, ergo$miner_cumulative), color = 'blue', size = 1) +
  geom_line(aes(ergo$block, ergo$treasury_cumulative), color = 'seagreen', size = 1) +
  geom_line(aes(ergo$block, ergo$total_supply), color = 'black', size = 1) +
  scale_y_continuous(labels = comma_format(),
                     limits = c(0, 100e6)) +
  scale_x_continuous(labels = comma_format()) +
  labs(x = "Block Height", 
       y = "Ergo Supply") +
  theme_bw(base_size = 15)


# ERGO Seed Phrase #9: "Anotha ___ anotha dolla"