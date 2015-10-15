default: libflint_fplll.so
main.o: main.cpp
	gcc -c -o main.o main.cpp -fpic -I../fplll -I../fplll/src -I../../../Nemo/local/include $(CFLAGS)

libflint_fplll.so: main.o
	gcc -shared -o libflint_fplll.so main.o -lfplll -lflint -L../../local/lib -L../../../Nemo/local/lib $(LDFLAGS)

install: libflint_fplll.so
	mv libflint_fplll.so ../../local/lib


