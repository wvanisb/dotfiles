NAME = ly
CC = gcc
FLAGS = -std=c99 -pedantic -g
FLAGS+= -Wall -Wextra -Werror=vla -Wno-unused-parameter
#FLAGS+= -DDEBUG
FLAGS+= -DGIT_VERSION_STRING=\"$(shell git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g')\"
LINK = -lpam -lxcb
VALGRIND = --show-leak-kinds=all --track-origins=yes --leak-check=full --suppressions=../res/valgrind.supp
CMD = ./$(NAME)

OS:= $(shell uname -s)
ifeq ($(OS), Linux)
	FLAGS+= -D_DEFAULT_SOURCE
endif

BIND = bin
OBJD = obj
SRCD = src
SUBD = sub
RESD = res
TESTD = tests

DATADIR ?= ${DESTDIR}/etc/ly
FLAGS+= -DDATADIR=\"$(DATADIR)\"

INCL = -I$(SRCD)
INCL+= -I$(SUBD)/ctypes
INCL+= -I$(SUBD)/argoat/src
INCL+= -I$(SUBD)/configator/src
INCL+= -I$(SUBD)/dragonfail/src
INCL+= -I$(SUBD)/termbox_next/src

SRCS = $(SRCD)/main.c
SRCS += $(SRCD)/config.c
SRCS += $(SRCD)/draw.c
SRCS += $(SRCD)/inputs.c
SRCS += $(SRCD)/login.c
SRCS += $(SRCD)/utils.c
SRCS += $(SUBD)/argoat/src/argoat.c
SRCS += $(SUBD)/configator/src/configator.c
SRCS += $(SUBD)/dragonfail/src/dragonfail.c

SRCS_OBJS:= $(patsubst %.c,$(OBJD)/%.o,$(SRCS))
SRCS_OBJS+= $(SUBD)/termbox_next/bin/termbox.a

.PHONY: final
final: $(BIND)/$(NAME)

$(OBJD)/%.o: %.c
	@echo "building object $@"
	@mkdir -p $(@D)
	@$(CC) $(INCL) $(FLAGS) -c -o $@ $<

$(SUBD)/termbox_next/bin/termbox.a:
	@echo "building static object $@"
	@(cd $(SUBD)/termbox_next && $(MAKE))

$(BIND)/$(NAME): $(SRCS_OBJS)
	@echo "compiling executable $@"
	@mkdir -p $(@D)
	@$(CC) -o $@ $^ $(LINK)

run:
	@cd $(BIND) && $(CMD)

leak: leakgrind
leakgrind: $(BIND)/$(NAME)
	@rm -f valgrind.log
	@cd $(BIND) && valgrind $(VALGRIND) 2> ../valgrind.log $(CMD)
	@less valgrind.log

install: $(BIND)/$(NAME)
	@echo "installing"
	@install -dZ ${DESTDIR}/etc/ly
	@install -DZ $(BIND)/$(NAME) -t ${DESTDIR}/usr/bin
	@install -DZ $(RESD)/config.ini -t ${DESTDIR}/etc/ly
	@install -DZ $(RESD)/xsetup.sh -t $(DATADIR)
	@install -DZ $(RESD)/wsetup.sh -t $(DATADIR)
	@install -dZ $(DATADIR)/lang
	@install -DZ $(RESD)/lang/* -t $(DATADIR)/lang
	@install -DZ $(RESD)/ly.service -t ${DESTDIR}/usr/lib/systemd/system

installnoconf: $(BIND)/$(NAME)
	@echo "installing without the configuration file"
	@install -dZ ${DESTDIR}/etc/ly
	@install -DZ $(BIND)/$(NAME) -t ${DESTDIR}/usr/bin
	@install -DZ $(RESD)/xsetup.sh -t $(DATADIR)
	@install -DZ $(RESD)/wsetup.sh -t $(DATADIR)
	@install -dZ $(DATADIR)/lang
	@install -DZ $(RESD)/lang/* -t $(DATADIR)/lang
	@install -DZ $(RESD)/ly.service -t ${DESTDIR}/usr/lib/systemd/system

uninstall:
	@echo "uninstalling"
	@rm -rf ${DESTDIR}/etc/ly
	@rm -rf $(DATADIR)
	@rm -f ${DESTDIR}/usr/bin/ly
	@rm -f ${DESTDIR}/usr/lib/systemd/system/ly.service

clean:
	@echo "cleaning"
	@rm -rf $(BIND) $(OBJD) valgrind.log
	@(cd $(SUBD)/termbox_next && $(MAKE) clean)

remotes:
	@echo "registering remotes"
	@git remote add github git@github.com:cylgom/$(NAME).git
	@git remote add gitea ssh://git@git.cylgom.net:2999/cylgom/$(NAME).git

github:
	@echo "sourcing submodules from https://github.com"
	@cp .github .gitmodules
	@git submodule sync
	@git submodule update --init --remote
	@cd $(SUBD)/argoat && make github
	@git submodule update --init --recursive --remote

gitea:
	@echo "sourcing submodules from https://git.cylgom.net"
	@cp .gitea .gitmodules
	@git submodule sync
	@git submodule update --init --remote
	@cd $(SUBD)/argoat && make gitea
	@git submodule update --init --recursive --remote
