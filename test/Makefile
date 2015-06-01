NAME = test
CFLAGS = -g -std=c99 -Wall -Wextra -Werror
CC = gcc
SRC = main.c

all: $(NAME)

$(NAME): $(SRC)
	$(CC) $(CFLAGS) -o $(NAME) $(SRC) \
		-L/usr/lib64 \
		-lgridclient \
		-lmetautils \
		-lgridcluster \
		-lgridcluster-remote \
		-lmeta0v2 \
		-lmeta1v2 \
		-lmeta2v2 \
		-lmeta0remote \
		-lmeta0utils \
		-lmeta1remote \
		-lmeta2v2lbutils \
		-lmeta2v2remote \
		-lmeta2v2utils \
		-lmetautils
