# BrainFuck in BrainFuck
one night I couldn't sleep, and, you know...

## How To Use
final product is `bf.bf` and you can interpret it with any valid interpreter you find, `bfint.c` for example.

input format for `bf.bf` is f"{code}\0{input}" (in python fstring). in other words: you provide BrainFuck program in ASCII format (without comments), a 0 byte and then input for the provided BrainFuck program.

## Source Code
`bf_human.high_level` is a high level code that explains how this interpreter works. `bf_human.bf` is just `bf` with comments, for avoiding repeatition, contents of `next_page_human.bf` and `prev_page_human.bf` will replace `#next_page` and `#prev_page` in `bf_human.bf`, respectively.

## Performance
it is BrainFuck in BrainFuck, so yes it is slow! you must try small programs or wait for a long time. I mean, don't run it on itself!

## Security
interpreter (`bf.bf`) puts the tape data next to the code, so you should be careful with your code!

## Acknowledgements
`bfint.py` is stolen from [here](https://github.com/pocmo/Python-Brainfuck) and `bfint.c` is written by `grok`.
