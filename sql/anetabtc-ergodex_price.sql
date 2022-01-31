/***************************
Author: eeysirhc
Date written: 2022-01-29
Objective: pull $NETA price data from ErgoDEX indexer
***************************/

SELECT 
a_x.ticker as x_ticker, 
x_amount/POWER(10,a_x.decimals) as x_amount,
a_y.ticker as y_ticker, 
y_amount/POWER(10,a_y.decimals) as y_amount, 
(x_amount/POWER(10,a_x.decimals))*(y_amount/POWER(10,a_y.decimals)) as k,
(y_amount/POWER(10,a_y.decimals))/(x_amount/POWER(10,a_x.decimals)) as price,
gindex as global_index

FROM pools p
LEFT JOIN assets a_x ON a_x.id = p.x_id
LEFT JOIN assets a_y ON a_y.id = p.y_id
WHERE pool_id = '7d2e28431063cbb1e9e14468facc47b984d962532c19b0b14f74d0ce9ed459be'
ORDER BY gindex ASC
;

