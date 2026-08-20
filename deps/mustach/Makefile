MUSTACH_CFLAGS := -fPIC -Wall -Wextra -DVERSION=1.2.10

results.mk:
	[ -f mustach-1.2.10.tar.gz ] || { echo "missing vendored mustach-1.2.10.tar.gz; run 'toku vendor'" >&2; exit 1; }
	if [ -d mustach-1.2.10 ]; then rm -rf mustach-1.2.10; fi
	tar xf mustach-1.2.10.tar.gz
	cd mustach-1.2.10 && $(CC) -c $(MUSTACH_CFLAGS) $(CFLAGS) -o mustach.o mustach.c
	cd mustach-1.2.10 && $(CC) -c $(MUSTACH_CFLAGS) $(CFLAGS) -o mustach-wrap.o mustach-wrap.c
	cd mustach-1.2.10 && $(AR) rcs libmustach.a mustach.o mustach-wrap.o
	touch results.mk
