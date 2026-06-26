; page:  $page_number $inst_or_value | $ip $tp $value_on_head $ax | $t1 $t2


; generate_instuction_pages :: null terminated
>,  ; fill first $inst_or_value
[   ; looping :: we are on $inst_or_value

    <[->>>>>>>+>+<<<<<<<<]
    >>>>>>>[-<<<<<<<+>>>>>>>]   ; copied $page_number
    >+                          ; increment new $page_number
    >,                          ; fill new $inst_or_value
]

; set_ip_and_tp
>>+<<<
[->>+>+<<<] >>[-<<+>>]  ; $tp is set and $ip is correct :: we are on $ip

; go_page_0
<< [ ; looping :: we are on $page_number
    #prev_page
]

> [ ; main loop :: we are on $inst_or_value which should be inst :: going until null inst


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is add ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    --------
    --------
    --------
    --------
    -------- --- ; $t1=minus 43 :: 43 is add
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is add :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is add :: on $t1
    > [-         ; if inst is add
        ; go_page_tp
        << [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<<<
            #next_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<< [->>->+<<<] >>> [-<<<+>>>]            ; $ax=$page_number minus $tp :: on $t1
            < ; on $ax
        ] ; on $ax=0
        
        ; add_inst_or_value
        <<<< +  ; just added to value

        ; go_page_ip
        >>>> [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<<<
            #prev_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<<< [->>>->+<<<<] >>>> [-<<<<+>>>>]      ; $ax=$page_number minus $ip :: on $t1
            < ; on $ax
        ] ; on $ax=0
        <<< + ; add_ip
        << #next_page
        >>>>>>>  ; on $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is sub ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    --------
    --------
    --------
    --------
    -------- ----- ; $t1=minus 45 :: 45 is sub
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is sub :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is sub :: on $t1
    > [-         ; if inst is sub
        ; go_page_tp
        << [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<<<
            #next_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<< [->>->+<<<] >>> [-<<<+>>>]            ; $ax=$page_number minus $tp :: on $t1
            < ; on $ax
        ] ; on $ax=0
        
        ; sub_inst_or_value
        <<<< -  ; just subtracted from value

        ; go_page_ip
        >>>> [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<<<
            #prev_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<<< [->>>->+<<<<] >>>> [-<<<<+>>>>]      ; $ax=$page_number minus $ip :: on $t1
            < ; on $ax
        ] ; on $ax=0
        <<< + ; add_ip
        << #next_page
        >>>>>>>  ; on $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is right ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    ------------
    ------------
    ------------
    ------------
    ------------ -- ; $t1=minus 62 :: 62 is right
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is right :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is right :: on $t1
    > [-         ; if inst is right
        ; add_tp
        <<<< +
        ; add_ip
        < +
        << #next_page
        >>>>>>>  ; on $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is left ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    ------------
    ------------
    ------------
    ------------
    ------------ ; $t1=minus 60 :: 60 is left
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is left :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is left :: on $t1
    > [-         ; if inst is left
        ; sub_tp
        <<<< -
        ; add_ip
        < +
        << #next_page
        >>>>>>>  ; on $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is obrac ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    ------------------
    ------------------
    ------------------
    ------------------
    ------------------ - ; $t1=minus 91 :: 91 is obrac
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is obrac :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is obrac :: on $t1
    > [-         ; if inst is obrac
        ; go_page_tp
        << [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<<<
            #next_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<< [->>->+<<<] >>> [-<<<+>>>]            ; $ax=$page_number minus $tp :: on $t1
            < ; on $ax
        ] ; on $ax=0
        
        ; load_value_on_head
        <<<< [->>>+>+<<<<] >>>> [-<<<<+>>>>]          ; value_on_head loaded :: on $ax=0

        ; go_page_ip
        + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<<<
            #prev_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<<< [->>>->+<<<<] >>>> [-<<<<+>>>>]      ; $ax=$page_number minus $ip :: on $t1
            < ; on $ax
        ] ; on $ax=0

        + ; $ax=1
        < [[-]  ; if $value_on_head :: consumed
            > - ; $ax=0
            <
        ] ; on $value_on_head=0 :: $ax is we_should_continue
        
        << + << #next_page  ; add_ip and next_page

        >>>>> [  ; while $ax
            ; if $inst_or_value is not obrac: sub_ax
            > ------------------
              ------------------
              ------------------
              ------------------
              ------------------ - ; $t1=minus 91 :: 91 is obrac
            <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]  ; $t1 is $inst_or_value minus 91 :: on $t2=0
            < [[-]  ; if $inst_or_value is not obrac :: consumed
                < - > ; sub_ax
            ]

            ; if $inst_or_value is not cbrac: add_ax
            ------------------
            ------------------
            ------------------
            ------------------
            ------------------ --- ; $t1=minus 93 :: 93 is cbrac
            <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]  ; $t1 is $inst_or_value minus 93 :: on $t2=0
            < [[-]  ; if $inst_or_value is not cbrac :: consumed
                < + > ; add_ax
            ]

            ; on $t1
            <<<< + << #next_page >>>>>  ; add_ip and next_page
        ]
        >> ; go to $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is cbrac ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    ------------------
    ------------------
    ------------------
    ------------------
    ------------------ --- ; $t1=minus 93 :: 93 is cbrac
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is cbrac :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is cbrac :: on $t1
    > [-         ; if inst is cbrac
        << [-] - ; $ax=FF

        [  ; while $ax
            ; sub_ip and prev_page
            <<< - << #prev_page 
            ; if $inst_or_value is not obrac: sub_ax
            >>>>>> ------------------
                   ------------------
                   ------------------
                   ------------------
                   ------------------ - ; $t1=minus 91 :: 91 is obrac
            <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]  ; $t1 is $inst_or_value minus 91 :: on $t2=0
            < [[-]  ; if $inst_or_value is not obrac :: consumed
                < - > ; sub_ax
            ]

            ; if $inst_or_value is not cbrac: add_ax
            ------------------
            ------------------
            ------------------
            ------------------
            ------------------ --- ; $t1=minus 93 :: 93 is cbrac
            <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]  ; $t1 is $inst_or_value minus 93 :: on $t2=0
            < [[-]  ; if $inst_or_value is not cbrac :: consumed
                < + > ; add_ax
            ]
            <  ; on $ax 
        ]
        >> ; go to $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is comma ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    --------
    --------
    --------
    --------
    -------- ---- ; $t1=minus 44 :: 44 is comma
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is comma :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is comma :: on $t1
    > [-         ; if inst is comma
        ; go_page_tp
        << [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<<<
            #next_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<< [->>->+<<<] >>> [-<<<+>>>]            ; $ax=$page_number minus $tp :: on $t1
            < ; on $ax
        ] ; on $ax=0
        
        ; add_inst_or_value
        <<<< ,  ; just read to value

        ; go_page_ip
        >>>> [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<<<
            #prev_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<<< [->>>->+<<<<] >>>> [-<<<<+>>>>]      ; $ax=$page_number minus $ip :: on $t1
            < ; on $ax
        ] ; on $ax=0
        <<< + ; add_ip
        << #next_page
        >>>>>>>  ; on $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; if inst is dot ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    >>>>>
    --------
    --------
    --------
    --------
    -------- ------ ; $t1=minus 44 :: 44 is dot
    <<<<< [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>]
    +            ; now $t2=1 and $t1 is 0 if inst is dot :: on $t2
    < [>-<[-]]   ; now $t1=0 and $t2 is 0/1 = inst is dot :: on $t1
    > [-         ; if inst is dot
        ; go_page_tp
        << [-] + ; init $ax with nonzero :: it's going to be $page_number~=$tp
        [
            <<<<<
            #next_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<< [->>->+<<<] >>> [-<<<+>>>]            ; $ax=$page_number minus $tp :: on $t1
            < ; on $ax
        ] ; on $ax=0
        
        ; add_inst_or_value
        <<<< .  ; just wrote to value

        ; go_page_ip
        >>>> [-] + ; init $ax with nonzero :: it's going to be $page_number~=$ip
        [
            <<<<<
            #prev_page
            >>>>> [-] <<<<<                           ; zero init $ax
            [->>>>>+>+<<<<<<] >>>>>> [-<<<<<<+>>>>>>] ; $ax=$page_number :: on $t1
            <<<< [->>>->+<<<<] >>>> [-<<<<+>>>>]      ; $ax=$page_number minus $ip :: on $t1
            < ; on $ax
        ] ; on $ax=0
        <<< + ; add_ip
        << #next_page
        >>>>>>>  ; on $t2 to be consistant
    ]; <<<<<< $t1 and $t2 are clear here :: on $inst_or_value



]