using Nemo, Pkg

oldwdir = pwd()
import Libdl

pkgdir = joinpath(@__DIR__, "..")

wdir = @__DIR__

Nemo_pkgdir = joinpath(dirname(pathof(Nemo)), "..")

@show Nemo_pkgdir

const Nemo_libdir = joinpath(Nemo_pkgdir, "deps", "usr", "lib")
const Nemo_bindir = joinpath(Nemo_pkgdir, "deps", "usr", "bin")
const Nemo_prefixpath = joinpath(Nemo_pkgdir, "deps", "usr")

prefixpath = joinpath(@__DIR__, "usr")

Nemo_vdir = joinpath(Nemo_pkgdir, "deps", "usr")

if !ispath(joinpath(wdir, "usr"))
  mkdir(joinpath(wdir, "usr"))
end

LDFLAGS = "-Wl,-rpath,$prefixpath/lib -Wl,-rpath,$Nemo_prefixpath/lib"

cd(wdir)

# install fplll

const makefile="""
default: libflint_fplll.so
main.o: main.cpp
	gcc -c -o main.o main.cpp -fpic -I../fplll -I../fplll/fplll -I$Nemo_prefixpath/include \$(CFLAGS)

libflint_fplll.so: main.o
	gcc -shared -o libflint_fplll.so main.o -lfplll -lflint -L../usr/lib -L$Nemo_prefixpath/lib \$(LDFLAGS)

install: libflint_fplll.so
	mv libflint_fplll.so ../usr/lib
"""

println(makefile)

if isfile(joinpath(wdir, "flint", "Makefile"))
  rm(joinpath(wdir, "flint", "Makefile"))
end

open(joinpath(wdir, "flint", "Makefile"), "w") do f
  write(f, makefile)
end

if Sys.iswindows()
  error("not done yet: FPlll on windows")
else
  if !ispath(joinpath(wdir, "fplll"))
    run(`git clone https://github.com/dstehle/fplll`)
    cd("$wdir/fplll")
    run(`./autogen.sh`)
  else  
    cd("$wdir/fplll")
    run(`git pull`)
  end
  run(`./configure --prefix=$prefixpath --with-gmp=$Nemo_prefixpath`)
  run(`make -j4 install`)
  cd("../flint")
  withenv(()->run(`make install`), "LDFLAGS"=>LDFLAGS)
end

push!(Libdl.DL_LOAD_PATH, joinpath(wdir, "usr", "lib"))

cd(oldwdir)

