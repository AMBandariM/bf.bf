page: $pn_hi $pn_lo $inst_or_value  |  $ax $tp_hi $tp_lo $ip_hi $ip_lo  |  $t1 $t2

; generate_instuction_pages :: $ terminated
>>,
> + <  ; set first $ax=1 so we can exploit it for go_page_0
------------
------------
------------ ; fill first $inst_or_value

[   ; looping :: we are on $inst_or_value
    < [->>>>>>>+>>>+<<<<<<<<<<] >>>>>>> [-<<<<<<<+>>>>>>>>]          ; copied $pn_lo : on $t1
    <<<<<<<< [->>>>>>>>+>>+<<<<<<<<<<] >>>>>>>> [-<<<<<<<<+>>>>>>>] ; copied $pn_hi : on $t1
    >>>  ; : on $pn_lo

    ; add one to $pn
    +
    < + >
    [<->
        [- >>>>>>> ; goto $tx
         + <<<<<<< ; bkto $rl]
    ] >>>>>>> [- <<<<<<< + >>>>>>>] <<<<<<<

    >,
    ------------
    ------------
    ------------                ; fill new $inst_or_value
] ; : on $inst_or_value=0
!



; set_ip_and_tp
<<<