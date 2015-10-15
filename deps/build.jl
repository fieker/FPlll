on_windows = @windows ? true : false
on_osx = @osx ? true : false

oldwdir = pwd()

pkgdir = Pkg.dir("FPlll") 
wdir = Pkg.dir("FPlll", "deps")
vdir = Pkg.dir("FPlll", "local")

Nemo_pkgdir = Pkg.dir("Nemo") 
Nemo_vdir = Pkg.dir("Nemo", "local")

if !ispath(Pkg.dir("FPlll", "local"))
    mkdir(Pkg.dir("FPlll", "local"))
end
if !ispath(Pkg.dir("FPlll", "local", "lib"))
    mkdir(Pkg.dir("FPlll", "local", "lib"))
end

LDFLAGS = "-Wl,-rpath,$vdir/lib -Wl,-rpath,\$\$ORIGIN/../share/julia/site/v$(VERSION.major).$(VERSION.minor)/FPlll/local/libi -Wl,-rpath,$Nemo_vdir/lib"

cd(wdir)

cd(wdir)

# install fplll

if on_windows
  error("not done yet: FPlll on windows")
else
  if !ispath(Pkg.dir("FPlll", "deps", "fplll"))
    run(`git clone https://github.com/dstehle/fplll`)
  else  
    cd("$wdir/deps/fplll")
    run(`git pull`)
  end
  run(`./autogen.sh`)
  run(`./configure --prefix=$vdir --with-gmp=$Nemo_vdir`)
  run(`make install`)
  cd("../flint")
  run(`make install`)
end

push!(Libdl.DL_LOAD_PATH, Pkg.dir("FPlll", "local", "lib"))

cd(oldwdir)

