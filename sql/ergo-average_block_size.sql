/***************************
Author: eeysirhc
Date written: 2021-12-27
Objective: compute the average block size over time
Source: https://github.com/ergoplatform/explorer-backend/blob/master/modules/explorer-core/src/main/scala/org/ergoplatform/explorer/db/queries/BlockInfoQuerySet.scala
***************************/

select
  min(timestamp) as t,
  cast(avg(block_size) as bigint) as block_size,
  to_char(to_timestamp(timestamp / 1000), 'YYYY-MM-DD') as date
from blocks_info

where (exists(select 1 from node_headers h where h.main_chain = true))
group by date
order by t asc

;
