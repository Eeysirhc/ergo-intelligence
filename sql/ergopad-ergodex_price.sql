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
WHERE pool_id = 'd7868533f26db1b1728c1f85c2326a3c0327b57ddab14e41a2b77a5d4c20f4b2'
ORDER BY gindex ASC



;
