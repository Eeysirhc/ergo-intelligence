/***************************
Author: eeysirhc
Date written: 2022-02-26
Last updated: 2022-03-03
Objective: retrieve all Ergo addresses holding the $ergopad token
Resources: https://ergopad.io/ 
***************************/

select
no.address,
sum(a.ergopad_quantity) as ergopad_quantity,

-- classification courtesy of Marty (esot321c) from ErgoPad team
case 
when address = '9hXmgvzndtakdSAgJ92fQ8ZjuKirWAw8tyDuyJrXP6sKHVpCz8XbMANK3BVJ1k3WD6ovQKTCasjKL5WMncRB6V9HvmMnJ2WbxYYjtLFS9sifDNXJWugrNEgoVK887bR5oaLZA95yGkMeXVfanxpNDZYaXH9KpHCpC5ohDtaW1PF17b27559toGVCeCUNti7LXyXV8fWS1mVRuz2PhLq5mB7hg2bqn7CZtVM8ntbUJpjkHUc9cP1R8Gvbo1GqcNWgM7gZkr2Dp514BrFz1cXMkv7TYEqH3cdxX9c82hH6fdaf3n6avdtZ5bgqerUZVDDW6ZsqxrqTyTMQUUirRAi3odmMGmuMqDJbU3Z1VnCF9NBow7jrKUDSgckDZakFZNChsr5Kq1kQyNitYJUh9fra1jLHCQ9yekz3te9E' then 'Staking Contract (3 Years)'
when address = 'Y2JDKcXN5zrz3NxpJqhGcJzgPRqQcmMhLqsX3TkkqMxQKK86Sh3hAZUuUweRZ97SLuCYLiB2duoEpYY2Zim3j5aJrDQcsvwyLG2ixLLzgMaWfBhTqxSbv1VgQQkVMKrA4Cx6AiyWJdeXSJA6UMmkGcxNCANbCw7dmrDS6KbnraTAJh6Qj6s9r56pWMeTXKWFxDQSnmB4oZ1o1y6eqyPgamRsoNuEjFBJtkTWKqYoF8FsvquvbzssZMpF6FhA1fkiH3n8oKpxARWRLjx2QwsL6W5hyydZ8VFK3SqYswFvRnCme5Ywi4GvhHeeukW4w1mhVx6sbAaJihWLHvsybRXLWToUXcqXfqYAGyVRJzD1rCeNa8kUb7KHRbzgynHCZR68Khi3G7urSunB9RPTp1EduL264YV5pmRLtoNnH9mf2hAkkmqwydi9LoULxrwsRvp' then 'Vesting Contract'
when address = '3eiC8caSy3jiCxCmdsiFNFJ1Ykppmsmff2TEpSsXY1Ha7xbpB923Uv2midKVVkxL3CzGbSS2QURhbHMzP9b9rQUKapP1wpUQYPpH8UebbqVFHJYrSwM3zaNEkBkM9RjjPxHCeHtTnmoun7wzjajrikVFZiWurGTPqNnd1prXnASYh7fd9E2Limc2Zeux4UxjPsLc1i3F9gSjMeSJGZv3SNxrtV14dgPGB9mY1YdziKaaqDVV2Lgq3BJC9eH8a3kqu7kmDygFomy3DiM2hYkippsoAW6bYXL73JMx1tgr462C4d2PE7t83QmNMPzQrD826NZWM2c1kehWB6Y1twd5F9JzEs4Lmd2qJhjQgGg4yyaEG9irTC79pBeGUj98frZv1Aaj6xDmZvM22RtGX5eDBBu2C8GgJw3pUYr3fQuGZj7HKPXFVuk3pSTQRqkWtJvnpc4rfiPYYNpM5wkx6CPenQ39vsdeEi36mDL8Eww6XvyN4cQxzJFcSymATDbQZ1z8yqYSQeeDKF6qCM7ddPr5g5fUzcApepqFrGNg7MqGAs1euvLGHhRk7UoeEpofFfwp3Km5FABdzAsdFR9' then 'Amount Staked'
when address = '9ehADYzAkYzUzQHqwM5KqxXwKAnVvkL5geSkmUzK51ofj2dq7K8' then 'DAO Emission (Quarterly)'
when address = '9fSjNZipSXemYLcgy7Jp7cC6D8M9SvBAEM6HyMUv9MN2Tti3T5m' then 'ErgoPad Treasury'
when address = '9gibNzudNny7MtB725qGM3Pqftho1SMpQJ2GYLYRDDAftMaC285' then 'Unclaimed Seed/Strategic Token Sales'
when address = '5vSUZRZbdVbnk4sJWjg2uhL94VZWRg4iatK9VgMChufzUgdihgvhR8yWSUEJKszzV7Vmi6K8hCyKTNhUaiP8p5ko6YEU9yfHpjVuXdQ4i5p4cRCzch6ZiqWrNukYjv7Vs5jvBwqg5hcEJ8u1eerr537YLWUoxxi1M4vQxuaCihzPKMt8NDXP4WcbN6mfNxxLZeGBvsHVvVmina5THaECosCWozKJFBnscjhpr3AJsdaL8evXAvPfEjGhVMoTKXAb2ZGGRmR8g1eZshaHmgTg2imSiaoXU5eiF3HvBnDuawaCtt674ikZ3oZdekqswcVPGMwqqUKVsGY4QuFeQoGwRkMqEYTdV2UDMMsfrjrBYQYKUBFMwsQGMNBL1VoY78aotXzdeqJCBVKbQdD3ZZWvukhSe4xrz8tcF3PoxpysDLt89boMqZJtGEHTV9UBTBEac6sDyQP693qT3nKaErN8TCXrJBUmHPqKozAg9bwxTqMYkpmb9iVKLSoJxG7MjAj72SRbcqQfNCVTztSwN3cRxSrVtz4p87jNFbVtFzhPg7UqDwNFTaasySCqM' then 'LP: ERG/ergopad'
when address = '3gb1RZucekcRdda82TSNS4FZSREhGLoi1FxGDmMZdVeLtYYixPRviEdYireoM9RqC6Jf4kx85Y1jmUg5XzGgqdjpkhHm7kJZdgUR3VBwuLZuyHVqdSNv3eanqpknYsXtUwvUA16HFwNa3HgVRAnGC8zj8U7kksrfjycAM1yb19BB4TYR2BKWN7mpvoeoTuAKcAFH26cM46CEYsDRDn832wVNTLAmzz4Q6FqE29H9euwYzKiebgxQbWUxtupvfSbKaHpQcZAo5Dhyc6PFPyGVFZVRGZZ4Kftgi1NMRnGwKG7NTtXsFMsJP6A7yvLy8UZaMPe69BUAkpbSJdcWem3WpPUE7UpXv4itDkS5KVVaFtVyfx8PQxzi2eotP2uXtfairHuKinbpSFTSFKW3GxmXaw7vQs1JuVd8NhNShX6hxSqCP6sxojrqBxA48T2KcxNrmE3uFk7Pt4vPPdMAS4PW6UU82UD9rfhe3SMytK6DkjCocuRwuNqFoy4k25TXbGauTNgKuPKY3CxgkTpw9WfWsmtei178tLefhUEGJueueXSZo7negPYtmcYpoMhCuv4G1JZc283Q7f3mNXS' then 'LP: SigUSD/ergopad (???)'
else ' '
end notes 

from node_outputs no

left join
(select ni.box_id
  from node_inputs ni
where ni.main_chain = true ) i
on i.box_id = no.box_id

left join
(select na.token_id, na.box_id, na.value/10^2 as ergopad_quantity
from node_assets na) a
on a.box_id = no.box_id

where no.main_chain = true
and a.token_id = 'd71693c49a84fbbecd4908c94813b46514b18b67a99952dc1e6e4791556de413'
and not exists (select box_id from node_inputs ni where no.box_id = ni.box_id)
group by 1 
order by 2 desc
;




/***************************
Staked amount per address
WIP: need to QA and validate the data
***************************/

select 
no.address, 
sum(s.amount) as staked_amount
from node_outputs no

join (select token_id, 
box_id, 
name, 
description, 
split_part(split_part(description, ':', 1), '{', 2) as category, 
cast(trim(split_part(split_part(description, ',', 1), ':', 2), ' ') as float) as amount
from tokens where name = 'ergopad Stake Key') s 
on s.box_id = no.box_id 

and not exists (select box_id from node_inputs ni where no.box_id = ni.box_id)
group by 1 
order by 2 desc 
;



