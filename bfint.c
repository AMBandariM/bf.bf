#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAPE_SIZE 30000
#define MAX_CODE_SIZE (1 << 22)  // 4MB max BF code

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <program.bf> <input.txt>\n", argv[0]);
        return 1;
    }

    // Read Brainfuck program
    FILE *bf_file = fopen(argv[1], "rb");
    if (!bf_file) {
        perror("Failed to open .bf file");
        return 1;
    }

    fseek(bf_file, 0, SEEK_END);
    long bf_size = ftell(bf_file);
    fseek(bf_file, 0, SEEK_SET);

    char *code = malloc(bf_size + 1);
    if (!code) {
        fclose(bf_file);
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    fread(code, 1, bf_size, bf_file);
    fclose(bf_file);
    code[bf_size] = '\0';

    // Filter valid Brainfuck commands and build jump table
    char *program = malloc(bf_size + 1);
    int *jump = malloc(bf_size * sizeof(int));
    if (!program || !jump) {
        free(code);
        free(program);
        free(jump);
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    int pc = 0;
    for (int i = 0; i < bf_size; i++) {
        char c = code[i];
        if (c == '>' || c == '<' || c == '+' || c == '-' ||
            c == '.' || c == ',' || c == '[' || c == ']') {
            program[pc] = c;
            jump[pc] = 0;
            pc++;
        }
    }
    program[pc] = '\0';
    int code_len = pc;

    // Build bracket matching table
    int *stack = malloc(code_len * sizeof(int));
    int sp = 0;
    for (int i = 0; i < code_len; i++) {
        if (program[i] == '[') {
            stack[sp++] = i;
        } else if (program[i] == ']') {
            if (sp == 0) {
                fprintf(stderr, "Mismatched brackets\n");
                free(code); free(program); free(jump); free(stack);
                return 1;
            }
            int open = stack[--sp];
            jump[open] = i;
            jump[i] = open;
        }
    }
    if (sp != 0) {
        fprintf(stderr, "Mismatched brackets\n");
        free(code); free(program); free(jump); free(stack);
        return 1;
    }
    free(stack);

    // Read input file
    FILE *in_file = fopen(argv[2], "rb");
    if (!in_file) {
        perror("Failed to open .txt file");
        free(code); free(program); free(jump);
        return 1;
    }

    fseek(in_file, 0, SEEK_END);
    long input_size = ftell(in_file);
    fseek(in_file, 0, SEEK_SET);

    char *input = malloc(input_size + 1);
    if (!input) {
        fclose(in_file);
        free(code); free(program); free(jump);
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    fread(input, 1, input_size, in_file);
    fclose(in_file);
    input[input_size] = '\0';

    // Interpreter
    unsigned char *tape = calloc(TAPE_SIZE, 1);
    if (!tape) {
        free(code); free(program); free(jump); free(input);
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    int ptr = 0;
    int ip = 0;      // instruction pointer
    long input_pos = 0;

    while (ip < code_len) {
        char cmd = program[ip];
        switch (cmd) {
            case '>':
                if (ptr < TAPE_SIZE - 1) ptr++;
                break;
            case '<':
                if (ptr > 0) ptr--;
                break;
            case '+':
                tape[ptr]++;
                break;
            case '-':
                tape[ptr]--;
                break;
            case '.':
                putchar(tape[ptr]);
                fflush(stdout);
                break;
            case ',':
                if (input_pos < input_size) {
                    tape[ptr] = (unsigned char)input[input_pos++];
                } else {
                    tape[ptr] = 0;  // EOF behavior: set to 0
                }
                break;
            case '[':
                if (tape[ptr] == 0) {
                    ip = jump[ip];
                }
                break;
            case ']':
                if (tape[ptr] != 0) {
                    ip = jump[ip];
                }
                break;
        }
        ip++;
    }

    // Cleanup
    free(tape);
    free(code);
    free(program);
    free(jump);
    free(input);

    return 0;
}