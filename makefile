CC = g++
NAME = parser
YFILE = $(NAME:=.y)
LFILE = $(NAME:=.l)
TABC = $(NAME:=.tab.c)
TABH = $(NAME:=.tab.h)
BISON = bison
FLEX = flex

$(NAME): lex.yy.c $(TABC)
	$(CC) $^ -o $@

lex.yy.c: $(LFILE) $(TABH)
	$(FLEX) $<

$(TABC) $(TABH): $(YFILE)
	$(BISON) -d $<

.PHONY: clean
clean:
	rm -f $(PROGRAM) *~

