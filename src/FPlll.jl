VERSION >= v"0.4.0-dev+6521" && __precompile__()

module FPlll

using Nemo

export bkz, bkz_trans

# To make all exported Nemo functions visible to someone using "using hecke"
# we have to export everything again

const pkgdir = joinpath(dirname(@__FILE__), "..")
const libdir = joinpath(pkgdir, "local", "lib")
const libflint_fplll = joinpath(pkgdir, "local", "lib", "libflint_fplll")
  
function __init__()

   on_windows = @windows ? true : false
   on_linux = @linux ? true : false

   if "HOSTNAME" in keys(ENV) && ENV["HOSTNAME"] == "juliabox"
       push!(Libdl.DL_LOAD_PATH, "/usr/local/lib")
   elseif on_linux
       push!(Libdl.DL_LOAD_PATH, libdir)
       Libdl.dlopen(libflint_fplll)
   else
      push!(Libdl.DL_LOAD_PATH, libdir)
   end
 
   println("Welcome to FPlll version 0.1")
end

function bkz(A::fmpz_mat, bs::Int)
  B = parent(A)(A)
  st = ccall((:fplll_bkz, :libflint_fplll), Int, (Ptr{fmpz_mat}, Int), &B, bs)
  return B
end

function bkz_trans(A::fmpz_mat, bs::Int)
  B = parent(A)(A)
  T = MatrixSpace(ZZ, rows(A), rows(A))()
  st = ccall((:fplll_bkz_trans, :libflint_fplll), Int, (Ptr{fmpz_mat}, Ptr{fmpz_mat}, Int), &B, &T, bs)
  return B, T
end

function lll(A::fmpz_mat)
  B = parent(A)(A)
  st = ccall((:fplll_lll, :libflint_fplll), Int, (Ptr{fmpz_mat}, ), &B)
  return B
end

function lll_trans(A::fmpz_mat)
  B = parent(A)(A)
  T = MatrixSpace(ZZ, rows(A), rows(A))()
  st = ccall((:fplll_lll_trans, :libflint_fplll), Int, (Ptr{fmpz_mat}, Ptr{fmpz_mat}), &B, &T)
  return B, T
end

end # module
