# Makefile for Compiler Frontend (Task 2)

CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -Wall -g

# Target executable
TARGET = task2

# Source files
LEX_SRC = task2.l
YACC_SRC = task2.y
INPUT = input.txt

# Generated files
LEX_OUT = lex.yy.c
YACC_OUT = task2.tab.c
YACC_HEADER = task2.tab.h

# Object files
OBJS = $(YACC_OUT:.c=.o) $(LEX_OUT:.c=.o)

.PHONY: all clean run test

# Default target
all: $(TARGET)

# Build the executable
$(TARGET): $(YACC_OUT) $(LEX_OUT)
	$(CC) $(CFLAGS) -o $(TARGET) $(YACC_OUT) $(LEX_OUT) -lm

# Generate parser from Yacc file
$(YACC_OUT) $(YACC_HEADER): $(YACC_SRC)
	$(BISON) -d $(YACC_SRC)

# Generate lexer from Lex file
$(LEX_OUT): $(LEX_SRC) $(YACC_HEADER)
	$(FLEX) $(LEX_SRC)

# Run the compiler with input.txt
run: $(TARGET)
	./$(TARGET) $(INPUT)

# Test with sample input
test: $(TARGET)
	@echo "Testing with input.txt:"
	@echo "======================="
	./$(TARGET) $(INPUT)

# Clean generated files
clean:
	rm -f $(TARGET) $(LEX_OUT) $(YACC_OUT) $(YACC_HEADER) *.o

# Help
help:
	@echo "Makefile for Compiler Frontend"
	@echo "==============================="
	@echo "Targets:"
	@echo "  make        - Build the compiler"
	@echo "  make run    - Build and run with input.txt"
	@echo "  make test   - Build and test with input.txt"
	@echo "  make clean  - Remove generated files"
	@echo "  make help   - Show this help message"
