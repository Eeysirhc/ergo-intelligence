/***************************
Author: eeysirhc
Date written: 2021-12-27
Last updated: 2022-01-15
Objective: calculate the running differential balance of every Ergo wallet address over time
***************************/

with outputs as (
        select timestamp,
        nos.address,
        sum(value) as value
    from node_outputs nos
    where nos.main_chain
    group by 1,2
),
inputs as (
        select txs.timestamp,
        nos.address,
        sum(nos.value) as value
    from node_inputs nis
    join node_outputs nos on nos.box_id = nis.box_id
    join node_transactions txs on txs.id = nis.tx_id
    where nos.main_chain and nis.main_chain
    group by 1,2
),
balance as (
        select coalesce(nos.timestamp, nis.timestamp) as timestamp,
        coalesce(nos.address, nis.address) as address,
        coalesce(nos.value, 0) - coalesce(nis.value, 0) as diff
    from outputs nos
    full outer join inputs nis on nis.timestamp = nos.timestamp and nos.address = nis.address
    order by 1
)

select address,
    to_timestamp(timestamp / 1000) as timestamp,
    diff / 10^9 as diff
from balance

where address like '9%'
group by 1, 2, 3
having length(address) = 51

;
