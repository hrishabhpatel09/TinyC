all:
	flex tokenizer.l
	bison -d parse.y
	gcc-15 -o parser lex.yy.c parse.tab.c 

run:
	flex tokenizer.l
	bison -d parse.y
	gcc-15 -o parser lex.yy.c parse.tab.c 
	./parser < main.c
