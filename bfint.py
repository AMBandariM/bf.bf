def evaluate(code, input, verbose=False):
    fi, output = 0, []
    def getch():
        nonlocal fi
        if fi >= len(input):
            print('NOT ENOUGH INPUT PROVIDED')
            exit(1)
        val = input[fi]
        fi += 1
        return val
    def putch(val):
        nonlocal output
        output.append(val)

    code     = cleanup(list(code))
    if verbose: print(f'code: {code}')
    bracemap = buildbracemap(code)

    cells, codeptr, cellptr = [0], 0, 0

    expcounter = 0
    while codeptr < len(code):
        command = code[codeptr]

        if command == "!":
            print('! cells:', end='')
            for i in range(len(cells)):
                if i % 8 == 0: print('\n    ', end='')
                print(f'{cells[i]:02X} ', end='')
            print(f'\n  ip: {codeptr}, tp: {cellptr}')
            expcounter += 1
            if expcounter == 50: exit(1)
        if command == ">":
            cellptr += 1
            if cellptr == len(cells): cells.append(0)

        if command == "<":
            cellptr = 0 if cellptr <= 0 else cellptr - 1

        if command == "+":
            cells[cellptr] = cells[cellptr] + 1 if cells[cellptr] < 255 else 0

        if command == "-":
            cells[cellptr] = cells[cellptr] - 1 if cells[cellptr] > 0 else 255

        if command == "[" and cells[cellptr] == 0: codeptr = bracemap[codeptr]
        if command == "]" and cells[cellptr] != 0: codeptr = bracemap[codeptr]
        if command == ".": putch(cells[cellptr])
        if command == ",": cells[cellptr] = getch()
            
        codeptr += 1
    
    if verbose: print(f'cells: {cells}')
    return output


def cleanup(code):
    return ''.join(filter(lambda x: x in ['.', ',', '[', ']', '<', '>', '+', '-', '!'], code))


def buildbracemap(code):
    temp_bracestack, bracemap = [], {}

    for position, command in enumerate(code):
        if command == "[": temp_bracestack.append(position)
        if command == "]":
            start = temp_bracestack.pop()
            bracemap[start] = position
            bracemap[position] = start
    return bracemap

def generator():
    code = ''
    with open('bf_human.bf', 'r') as f: code = f.read()

    prev_page_code = ''
    with open('prev_page_human.bf', 'r') as f: prev_page_code = f.read()
    prev_page_code = cleanup(prev_page_code)

    next_page_code = ''
    with open('next_page_human.bf', 'r') as f: next_page_code = f.read()
    next_page_code = cleanup(next_page_code)


    code = code.replace('#prev_page', prev_page_code)
    code = code.replace('#next_page', next_page_code)

    with open('bf.bf', 'w') as f: f.write(cleanup(code))


def run_bf_in_bf(prog, input):
    code = ''
    with open('bf.bf', 'r') as f: code = f.read()
    result = evaluate(code, [ord(c) for c in f'{prog}\0{input}'])
    print('result:')
    for r in result:
        print(chr(r), end='')
    print()

if __name__ == '__main__':
    generator()
    # with open('input.txt', 'wb') as f: f.write(b'+[----->+++<]>+.---.+++++++..+++.\0')
