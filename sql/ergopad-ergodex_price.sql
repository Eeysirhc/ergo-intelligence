/***************************
Author: @curbisdeprophet
Date written: 2022-02-01
Objective: pull $ERGOPAD price data from ErgoDEX indexer
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
WHERE pool_id = '61a579c46d92f2718576fc9839a2a1983f172e889ec234af8504b5bbf10edd89' 
ORDER BY gindex ASC



;
