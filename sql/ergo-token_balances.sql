/***************************
Author: eeysirhc
Date written: 2022-02-14
Objective: view to retrieve all boxes from select tokens per address over time 

Tokens: 
- $ERGOPAD
- $NETA
- $COMET
***************************/


create view token_balances as 

select
to_timestamp(timestamp / 1000) as timestamp,
no.box_id,
no.address,
a.token_id,
a.name, 
a.quantity

from node_outputs no

left join
(select ni.box_id
  from node_inputs ni
where ni.main_chain = true ) i
on i.box_id = no.box_id

left join
(select na.token_id, na.box_id, na.value/10^t.decimals as quantity, t.name 
from node_assets na
left join public.tokens t on t.token_id = na.token_id
) a on a.box_id = no.box_id

where no.main_chain = true
and not exists (select box_id from node_inputs ni where no.box_id = ni.box_id)

and no.address like '9%%'

and a.token_id in (

    -- ERGOPAD
    'd71693c49a84fbbecd4908c94813b46514b18b67a99952dc1e6e4791556de413',

    -- NETA 
    '472c3d4ecaa08fb7392ff041ee2e6af75f4a558810a74b28600549d5392810e8',

    -- COMET
    '0cd8c9f416e5b1ca9f986a7f10a84191dfb85941619e49e53c0dc30ebf83324b'
    ) 
;

