##############################
# Author: eeysirhc
# Date written: 2022-01-10
# Objective: visualize ErgoPad investment relationship and vesting schedule tiers
# Reference: https://github.com/ergo-pad/ergopad/blob/main/docs/README.md#tokenomics-and-vesting-schedule
##############################

# LOAD PACKAGES
library(tidyverse)
library(scales)
library(patchwork)

# GENERATE SIGUSD AMOUNTS
tokens <- seq(1, 1000, 1) %>% 
  as_tibble() %>% 
  rename(dollar = value)

# CALCULATE ERGOPAD TOKENS BASED ON SIGUSD CONTRIBUTION
tokens_final <- tokens %>% 
  mutate(seed = dollar / 0.011,
         strategic = dollar / 0.02,
         presale = dollar / 0.03) %>%
  pivot_longer(2:4) %>% 
  mutate(name = case_when(name == 'seed' ~ 'Seed @ $0.011',
                          name == 'strategic' ~ 'Strategic @ $0.02',
                          name == 'presale' ~ 'Presale @ $0.03')) %>% 
  mutate(name = factor(name))

# VARIABLE FOR TOKEN AMOUNT BASED ON 1K SIGUSD INVESTMENT
amt <- tokens_final %>% filter(dollar == 1000) 
amt_seed <- amt[1,3]
amt_strategic <- amt[2,3]
amt_presale <- amt[3,3]

# FUNCTION FOR VESTING SCHEDULE
vest_schedule <- function(amount, months, segment){
  
  df <- seq(1, months, 1) %>% 
    as_tibble() %>% 
    mutate(vest = amount * ( 1 / months),
           cvest = cumsum(vest),
           value = as_factor(value),
           segment = segment)
  
  return(df)
  
}

# GENERATE VESTING SCHEDULE DATA
vest_seed <- vest_schedule(amt_seed, 9, 'seed') 
vest_strategic <- vest_schedule(amt_strategic, 6, 'strategic')
vest_presale <- vest_schedule(amt_presale, 3, 'presale')

# JOIN DATA FRAMES
vest <- rbind(vest_seed, vest_strategic, vest_presale)

# STANDARDIZE DIMENSION VALUES
vest_final <- vest %>% 
  mutate(segment = case_when(segment == 'seed' ~ 'Seed @ $0.011',
                             segment == 'strategic' ~ 'Strategic @ $0.02',
                             segment == 'presale' ~ 'Presale @ $0.03')) %>% 
  mutate(segment = factor(segment))

# REARRANGE LEVELS
ltemp <- c("Seed @ $0.011", "Strategic @ $0.02", "Presale @ $0.03")
tokens_final$name <- fct_relevel(tokens_final$name, ltemp)
vest_final$segment <- fct_relevel(vest_final$segment, ltemp)

# GRAPH: SIGUSD PURCHASE TO TOKEN AMOUNT
p1 <- tokens_final %>% 
  ggplot(aes(dollar, value, color = name)) +
  geom_line(size = 1) +
  labs(title = "ErgoPad",
       subtitle = "Token amount based on investment purchase",
       x = "sigUSD", y = "ErgoPad Tokens",
       color = NULL) +
  scale_y_continuous(labels = comma_format()) +
  scale_x_continuous(labels = dollar_format()) +
  scale_color_brewer(palette = 'Set1', direction = -1) +
  expand_limits(ymin = 0, ymax = 100000) +
  theme_bw(base_size = 20) +
  theme(legend.position = 'none')

# GRAPH: VESTING TIMELINE TO TOKEN AMOUNT
p2 <- vest_final %>% 
  ggplot() +
  geom_line(aes(value, cvest$value, color = segment, group = segment), size = 1) +
  labs(x = "Months Vested", y = NULL, color = NULL,
       subtitle = "Vesting schedule based on 1,000 sigUSD purchase amount") +
  scale_y_continuous(labels = comma_format()) +
  scale_color_brewer(palette = 'Set1', direction = -1) +
  expand_limits(ymin = 0, ymax = 100000) +
  theme_bw(base_size = 20) 


# FINAL GRAPH
p1 + p2


