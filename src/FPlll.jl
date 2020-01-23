module FPlll

using Nemo

export bkz, bkz_trans

# To make all exported Nemo functions visible to someone using "using hecke"
# we have to export everything again

const pkgdir = joinpath(dirname(@__FILE__), "..")
const libdir = joinpath(pkgdir, "dep", "usr", "lib")
const libflint_fplll = joinpath(pkgdir, "dep", "usr", "lib", "libflint_fplll")
  
function __init__()

  on_windows = Sys.iswindows() ? true : false
  on_linux = Sys.islinux()? ? true : false

  if "HOSTNAME" in keys(ENV) && ENV["HOSTNAME"] == "juliabox"
    push!(Libdl.DL_LOAD_PATH, "/usr/local/lib")
  elseif on_linux
    push!(Libdl.DL_LOAD_PATH, libdir)
    Libdl.dlopen(libflint_fplll)
  else
    push!(Libdl.DL_LOAD_PATH, libdir)
  end
end

function bkz(A::fmpz_mat, bs::Int)
  B = deepcopy(A)
  st = ccall((:fplll_bkz, :libflint_fplll), Int, (Ref{fmpz_mat}, Int), &B, bs)
  return B
end

function bkz_trans(A::fmpz_mat, bs::Int)
  B = deppcopy(A)
  T = zero_matrix(FlintZZ, nrows(A), nrows(A))
  st = ccall((:fplll_bkz_trans, :libflint_fplll), Int, (Ref{fmpz_mat}, Ref{fmpz_mat}, Int), &B, &T, bs)
  return B, T
end

function lll(A::fmpz_mat)
  B = deepcopy(A)
  st = ccall((:fplll_lll, :libflint_fplll), Int, (Ref{fmpz_mat}, ), &B)
  return B
end

function lll_trans(A::fmpz_mat)
  B = deepcopy(A)
  T = zero_matrix(FlintZZ, nrows(A), nrows(A))
  st = ccall((:fplll_lll_trans, :libflint_fplll), Int, (Ref{fmpz_mat}, Ref{fmpz_mat}), &B, &T)
  return B, T
end

end # module
