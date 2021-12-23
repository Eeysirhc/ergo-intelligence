/***************************
Author: eeysirhc
Date written: 2021-12-01
Objective: pull daily miner revenue numbers
***************************/

select
  min(timestamp) as t,
  cast(sum(miner_revenue)/10^9 as bigint) as miner_revenue,
  to_char(to_timestamp(timestamp / 1000), 'YYYY-MM-DD') as date
from blocks_info
where exists(select 1 from node_headers h where h.main_chain = true)
group by date
order by t asc

;
