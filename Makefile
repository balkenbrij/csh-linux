#	$OpenBSD: Makefile,v 1.14 2015/10/26 21:57:42 naddy Exp $
#
# C Shell with process control; VM/UNIX VAX Makefile
# Bill Joy UC Berkeley; Jim Kulp IIASA, Austria

PROG=	csh
CFLAGS+=-I${.CURDIR} -I.
SRCS=	alloc.c char.c const.c csh.c dir.c dol.c error.c exec.c exp.c file.c \
	func.c glob.c hist.c init.c lex.c misc.c parse.c proc.c \
	sem.c set.c str.c time.c

CLEANFILES+=error.h const.h

const.h: error.h

error.h: error.c
	@rm -f $@
	@echo '/* Do not edit this file, make creates it. */' > $@
	@echo '#ifndef _h_sh_err' >> $@
	@echo '#define _h_sh_err' >> $@
	egrep 'ERR_' ${.CURDIR}/$*.c | egrep '^#define' >> $@
	@echo '#endif /* _h_sh_err */' >> $@

const.h: const.c
	@rm -f $@
	@echo '/* Do not edit this file, make creates it. */' > $@
	${CC} -E ${CFLAGS} ${.CURDIR}/$*.c | egrep 'Char STR' | \
	    sed -e 's/Char \([a-zA-Z0-9_]*\)\(.*\)/extern Char \1[];/' | \
	    sort >> $@

.depend alloc.o: const.h error.h 

.include <bsd.prog.mk>
