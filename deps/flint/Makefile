default: libflint_fplll.so
main.o: main.cpp
	gcc -c -o main.o main.cpp -fpic -I../fplll -I../fplll/fplll -I/home/fieker/.julia/dev/Nemo/src/../deps/usr/include $(CFLAGS)

libflint_fplll.so: main.o
	gcc -shared -o libflint_fplll.so main.o -lfplll -lflint -L../usr/lib -L/home/fieker/.julia/dev/Nemo/src/../deps/usr/lib $(LDFLAGS)

install: libflint_fplll.so
	mv libflint_fplll.so ../usr/lib
