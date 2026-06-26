; we assume that we are not in page_0 and we are on $page_number of current page

; page:  $page_number $inst_or_value | $ip $tp $value_on_head $ax | $t1 $t2

<<<  ; on $ax
[-] <[-] <[-] <[-] ; prev $ip $tp $value_on_head $ax cleaned :: on prev $ip
>>>>>>>> [-<<<<<<<+<+>>>>>>>>] <<<<<<<[->>>>>>>+<<<<<<<] ; prev $ip set :: on prev $tp
>>>>>>>> [-<<<<<<<+<+>>>>>>>>] <<<<<<<[->>>>>>>+<<<<<<<] ; prev $tp set :: on prev $value_on_head
>>>>>>>> [-<<<<<<<+<+>>>>>>>>] <<<<<<<[->>>>>>>+<<<<<<<] ; prev $value_on_head set :: on prev $ax
>>>>>>>> [-<<<<<<<+<+>>>>>>>>] <<<<<<<[->>>>>>>+<<<<<<<] ; prev $ax set :: on prev $t1
<<<<<<   ; on prev $page_number
