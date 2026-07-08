page: $pn_hi $pn_lo $inst_or_value  |  $ax $tp_hi $tp_lo $ip_hi $ip_lo  |  $t1 $t2

; generate_instuction_pages :: $ terminated
>>,
------------
------------
------------ ; fill first $inst_or_value
> + <  ; set first $ax=1 so we can exploit it for go_page_0

[   ; looping :: we are on $inst_or_value
    < [->>>>>>>+>>>+<<<<<<<<<<] >>>>>>> [-<<<<<<<+>>>>>>>]          ; copied $pn_lo : on $t1
    <<<<<<<< [->>>>>>>>+>>+<<<<<<<<<<] >>>>>>>> [-<<<<<<<<+>>>>>>>>] ; copied $pn_hi : on $t1
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


; set_ip_and_tp
< [- > + >>> + <<<<] > [- < + >]      ; copy $pn_lo to $tp_lo
<< [ - >> + >> + <<<<] >> [- << + >>] ; copy $pn_hi to $tp_hi : on $inst_or_value
>>>  ; : on $tp_lo
; add one to $tp
+
< + >
[<->
    [- > ; goto $tx
     + < ; bkto $rl]
] > [- < + >] <

<<  ; : on $ax
; go_page_0
- [ + 
> [- <<<<<<<<<< + >>>>>>>>>>] > [- <<<<<<<<<< + >>>>>>>>>>] <<
<<<<<<<<<< - ] <  ; : on $inst_or_value

[  ; main loop :: we are on $inst_or_value which should be inst :: going until 0 inst ($)



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is add ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    ------- ; $t1=minus 7 :: 7 is add
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is add :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is add :: on $t1
    > [-         ; if inst is add
        ; go_page_tp
        <<<<<< [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<
            #next_page
            >>> [-] <<<                                                                 ; zero init $ax : on $pn_hi
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<<<          ; : on $tp_hi
            [- >>>> + > - <<<<<] >>>> [- <<<< + >>>>] > [[-] <<<<<< + >>>>>>] <<<<<<<<  ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <<<                ; : on $tp_lo
            [- >>> + > - <<<<] >>> [- <<< + >>>] > [[-] <<<<<< + >>>>>>] <<<<<<         ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        
        ; add one to $ip
        >>>>
        +
        < + >
        [<->
            [- > ; goto $tx
            + < ; bkto $rl]
        ] > [- < + >] <
        
        ; add_inst_or_value
        <<<<< +  ; just added to value

        ; go_page_ip
        > [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<
            #prev_page
            >>> [-] <<<                               ; zero init $ax
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<            ; : on $tp_hi
            [- >> + > - <<<] >> [- << + >>] > [[-] <<<<<< + >>>>>>] <<<<<<<<            ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <                  ; : on $tp_lo
            [- > + > - <<] > [- < + >] > [[-] <<<<<< + >>>>>>] <<<<<<                   ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        >>>>>>  ; on $t2 to be consistant
    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is sub ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    --------- ; $t1=minus 9 :: 9 is sub
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is sub :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is sub :: on $t1
    > [-         ; if inst is sub
        ; go_page_tp
        <<<<<< [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<
            #next_page
            >>> [-] <<<                                                                 ; zero init $ax : on $pn_hi
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<<<          ; : on $tp_hi
            [- >>>> + > - <<<<<] >>>> [- <<<< + >>>>] > [[-] <<<<<< + >>>>>>] <<<<<<<<  ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <<<                ; : on $tp_lo
            [- >>> + > - <<<<] >>> [- <<< + >>>] > [[-] <<<<<< + >>>>>>] <<<<<<         ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        
        ; add one to $ip
        >>>>
        +
        < + >
        [<->
            [- > ; goto $tx
            + < ; bkto $rl]
        ] > [- < + >] <
        
        ; add_inst_or_value
        <<<<< -  ; just added to value

        ; go_page_ip
        > [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<
            #prev_page
            >>> [-] <<<                               ; zero init $ax
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<            ; : on $tp_hi
            [- >> + > - <<<] >> [- << + >>] > [[-] <<<<<< + >>>>>>] <<<<<<<<            ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <                  ; : on $tp_lo
            [- > + > - <<] > [- < + >] > [[-] <<<<<< + >>>>>>] <<<<<<                   ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        >>>>>>  ; on $t2 to be consistant
    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is right ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    ------------- -------------  ; $t1=minus 26 :: 26 is right
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is right :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is right :: on $t1
    > [-         ; if inst is right
        ; add_ip
        <<
        +
        < + >
        [<->
            [- > ; goto $tx
            + < ; bkto $rl]
        ] > [- < + >] <

        ; add_tp
        << 
        +
        < + >
        [<->
            [- >>> ; goto $tx
            + <<< ; bkto $rl]
        ] >>> [- <<< + >>>] <<<

        <<<<< #next_page
        >>>>>>>>>  ; on $t2 to be consistant
    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is left ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    ------------- -----------  ; $t1=minus 24 :: 24 is left
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is left :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is left :: on $t1
    > [-         ; if inst is left
        ; add_ip
        <<
        +
        < + >
        [<->
            [- > ; goto $tx
            + < ; bkto $rl]
        ] > [- < + >] <

        ; sub_tp
        << 
        < - >
        [<+>
            [- >>> ; goto $tx
            + <<< ; bkto $rl]
        ] >>> [- <<< + >>>] <<<
        -
        <<<<< #next_page
        >>>>>>>>>  ; on $t2 to be consistant
    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is obrac ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    ----------- ----------- ----------- ----------- -----------  ; $t1=minus 55 :: 55 is obrac
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is obrac :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is obrac :: on $t1
    > [-         ; if inst is obrac
        ; go_page_tp
        <<<<<< [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<
            #next_page
            >>> [-] <<<                                                                 ; zero init $ax : on $pn_hi
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<<<          ; : on $tp_hi
            [- >>>> + > - <<<<<] >>>> [- <<<< + >>>>] > [[-] <<<<<< + >>>>>>] <<<<<<<<  ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <<<                ; : on $tp_lo
            [- >>> + > - <<<<] >>> [- <<< + >>>] > [[-] <<<<<< + >>>>>>] <<<<<<         ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        ; load_value_on_ax
        < [->+ >>>>> + <<<<<<] >>>>>> [- <<<<<< + >>>>>>]  ; : on $t1=0

        ; go_page_ip
        + ; $t1=1 :: it's going to mean $pn~=$ip
        [
            [-]
            <<<<<<<< #prev_page 
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<        ; : on $ip_hi
            [- >> + > - <<<] >> [- << + >>] > [[-] >>>>>>>>> + <<<<<<<<<] <<<<<<<<  ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <              ; : on $ip_lo
            [- > + > - <<] > [- < + >] > [[-] >>>>>>>>> + <<<<<<<<<] <              ; : on $t1
            >>>>>>>>>> [- <<<<<<<<<< + >>>>>>>>>>] <<<<<<<<<<                       ; : on $t1=calculated
        ]; on $t1=0

        <<<<< [ [-] >>>>> + <<<<< ] + >>>>> [- <<<<< - >>>>> ] <<<<<  ; : on $ax=we_should_continue_skipping 

        <<< #next_page >>>

        [  ; : on $ax=we_should_continue_skipping_counter

            >>>>>>
            ----------- ----------- ----------- ----------- -----------     ; $t2=minus 55 :: 55 is obrac
            <<<<<<< [- >>>>>> + > + <<<<<<<] >>>>>> [- <<<<<< + >>>>>>] >   ; : on $t2=$inst_or_value minus 55
            [ [-] <<<<<< - >>>>>> ]

            ----------- ----------- ----------- ----------- -------------   ; $t2=minus 57 :: 57 is cbrac
            <<<<<<< [- >>>>>> + > + <<<<<<<] >>>>>> [- <<<<<< + >>>>>>] >   ; : on $t2=$inst_or_value minus 57
            [ [-] <<<<<< + >>>>>> ]

            <<<<<<<<< #next_page >>>
        ]
        ; fix_ip : on $ax=0
        >>> [-] > [-] <<<<
        <<<     ; : on $pn_hi
        [ - >>>>>> + > + <<<<<<< ] >>>>>>> [- <<<<<<< + >>>>>>>]        ; set $ip_hi : on $ip_lo
        <<<<<<  ; : on $pn_lo
        [ - >>>>>> + > + <<<<<<< ] >>>>>>> [- <<<<<<< + >>>>>>>]        ; set $ip_lo : on $t1

        >  ; go to $t2 to be consistant
    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is cbrac ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    ----------- ----------- ----------- ----------- ----------- --  ; $t1=minus 57 :: 57 is cbrac
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is cbrac :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is cbrac :: on $t1
    > [-         ; if inst is cbrac
        <<<<<< [-] -  ; : on $ax=255

        [ ; while $ax
            <<< #prev_page
            >>>>>>>>>
            ----------- ----------- ----------- ----------- -----------     ; $t2=minus 55 :: 55 is obrac
            <<<<<<< [- >>>>>> + > + <<<<<<<] >>>>>> [- <<<<<< + >>>>>>] >   ; : on $t2=$inst_or_value minus 55
            [ [-] <<<<<< - >>>>>> ]

            ----------- ----------- ----------- ----------- -------------   ; $t2=minus 57 :: 57 is cbrac
            <<<<<<< [- >>>>>> + > + <<<<<<<] >>>>>> [- <<<<<< + >>>>>>] >   ; : on $t2=$inst_or_value minus 57
            [ [-] <<<<<< + >>>>>> ]
            <<<<<<  ; : on $ax
        ]
        ; fix_ip : on $ax=0
        >>> [-] > [-] <<<<
        <<<     ; : on $pn_hi
        [ - >>>>>> + > + <<<<<<< ] >>>>>>> [- <<<<<<< + >>>>>>>]        ; set $ip_hi : on $ip_lo
        <<<<<<  ; : on $pn_lo
        [ - >>>>>> + > + <<<<<<< ] >>>>>>> [- <<<<<<< + >>>>>>>]        ; set $ip_lo : on $t1

        >  ; go to $t2 to be consistant

    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is comma ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    -------- ; $t1=minus 8 :: 8 is comma
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is comma :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is comma :: on $t1
    > [-         ; if inst is comma
        ; go_page_tp
        <<<<<< [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<
            #next_page
            >>> [-] <<<                                                                 ; zero init $ax : on $pn_hi
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<<<          ; : on $tp_hi
            [- >>>> + > - <<<<<] >>>> [- <<<< + >>>>] > [[-] <<<<<< + >>>>>>] <<<<<<<<  ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <<<                ; : on $tp_lo
            [- >>> + > - <<<<] >>> [- <<< + >>>] > [[-] <<<<<< + >>>>>>] <<<<<<         ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        
        ; add one to $ip
        >>>>
        +
        < + >
        [<->
            [- > ; goto $tx
            + < ; bkto $rl]
        ] > [- < + >] <
        
        ; get_inst_or_value
        <<<<< ,  ; just read to value

        ; go_page_ip
        > [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<
            #prev_page
            >>> [-] <<<                               ; zero init $ax
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<            ; : on $tp_hi
            [- >> + > - <<<] >> [- << + >>] > [[-] <<<<<< + >>>>>>] <<<<<<<<            ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <                  ; : on $tp_lo
            [- > + > - <<] > [- < + >] > [[-] <<<<<< + >>>>>>] <<<<<<                   ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        >>>>>>  ; on $t2 to be consistant
    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is dot ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>>
    ---------- ; $t1=minus 10 :: 10 is dot
    <<<<<< [- >>>>>> + > + <<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is dot :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is dot :: on $t1
    > [-         ; if inst is dot
        ; go_page_tp
        <<<<<< [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<
            #next_page
            >>> [-] <<<                                                                 ; zero init $ax : on $pn_hi
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<<<          ; : on $tp_hi
            [- >>>> + > - <<<<<] >>>> [- <<<< + >>>>] > [[-] <<<<<< + >>>>>>] <<<<<<<<  ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <<<                ; : on $tp_lo
            [- >>> + > - <<<<] >>> [- <<< + >>>] > [[-] <<<<<< + >>>>>>] <<<<<<         ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        
        ; add one to $ip
        >>>>
        +
        < + >
        [<->
            [- > ; goto $tx
            + < ; bkto $rl]
        ] > [- < + >] <
        
        ; put_inst_or_value
        <<<<< .  ; just wrote the value

        ; go_page_ip
        > [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<
            #prev_page
            >>> [-] <<<                               ; zero init $ax
            [- >>>>>>>> + > + <<<<<<<<<] >>>>>>>> [- <<<<<<<< + >>>>>>>>] <<            ; : on $tp_hi
            [- >> + > - <<<] >> [- << + >>] > [[-] <<<<<< + >>>>>>] <<<<<<<<            ; : on $pn_lo
            [- >>>>>>> + > + <<<<<<<<] >>>>>>> [- <<<<<<< + >>>>>>>] <                  ; : on $tp_lo
            [- > + > - <<] > [- < + >] > [[-] <<<<<< + >>>>>>] <<<<<<                   ; $t1=$t2=0 : on $ax=computed
        ] ; on $ax=0
        >>>>>>  ; on $t2 to be consistant
    ]; <<<<<<< $t1 and $t2 are clear here :: on $inst_or_value



]
