; we assume that we are on $page_number of current page

; page:  $page_number $inst_or_value | $ip $tp $value_on_head $ax | $t1 $t2

; fill next $page_number if it is zero
>>>>>>> +                  ; $t2=1
> [-<[-]<+>>] << [->>+<<]  ; $t1=0 $t2 is 0/1 = next $page_number is zero :: on $t1
> [-                       ; if next $page_number is 0 :: temps are clear :: on $t2
    <<<<<<< [->>>>>>>+>+<<<<<<<<] >>>>>>>[-<<<<<<<+>>>>>>>] > + ; now temps are 0 and next $page_number is $page_number plus 1 :: we are on next $page_number
    < ; on $t2 to be consistant
]
>>> [-] > [-] > [-] > [-]   ; next $ip $tp $value_on_head $ax are 0 :: on next $ax
<<<                          ; on next $ip
<<<<<<<< [->>>>>>>>+>+<<<<<<<<<] >>>>>>>>> [-<<<<<<<<<+>>>>>>>>>] ; next $ip is set :: on next $tp
<<<<<<<< [->>>>>>>>+>+<<<<<<<<<] >>>>>>>>> [-<<<<<<<<<+>>>>>>>>>] ; next $tp is set
<<<<<<<< [->>>>>>>>+>+<<<<<<<<<] >>>>>>>>> [-<<<<<<<<<+>>>>>>>>>] ; next $value_on_head is set
<<<<<<<< [->>>>>>>>+>+<<<<<<<<<] >>>>>>>>> [-<<<<<<<<<+>>>>>>>>>] ; next $ax is set :: on next $t1
<<<<<< ; on next $page_number
