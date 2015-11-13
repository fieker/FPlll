/* Copyright (C) 2005-2008 Damien Stehle.
   Copyright (C) 2007 David Cade.
   Copyright (C) 2008-2011 Xavier Pujol.
   Copyright (C) 2015 Claus Fieker

   This file is part of FPlll. FPlll is free software: you
   can redistribute it and/or modify it under the terms of the GNU Lesser
   General Public License as published by the Free Software Foundation,
   either version 2.1 of the License, or (at your option) any later version.

   FPlll is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with FPlll. If not, see <http://www.gnu.org/licenses/>. */

#include "config.h"
#include "main.h"

#include "flint/fmpz.h"
#include "flint/fmpz_mat.h"

extern "C" {

static void flint_to_fplll(IntMatrix &b, fmpz_mat_t A)
{
  for(int i=0; i<A->r; i++) {
    for(int j=0; j<A->c; j++) {
      fmpz_get_mpz(b[i][j].getData(), fmpz_mat_entry(A, i, j));
    }
  }
}

static void fplll_to_flint(fmpz_mat_t A, IntMatrix b)
{
  for(int i=0; i<A->r; i++) {
    for(int j=0; j<A->c; j++) {
      fmpz_set_mpz(fmpz_mat_entry(A, i, j), b[i][j].getData());
    }
  }
}

int fplll_bkz(fmpz_mat_t A, int bs)
{
  BKZParam param;
  IntMatrix b;
  int status;

  param.blockSize = bs;
  b = IntMatrix(A->r, A->c);
  flint_to_fplll(b, A);


  status = bkzReduction(&b, NULL, param, FT_DEFAULT);

  fplll_to_flint(A, b);
  b.clear();

  if (status != RED_SUCCESS) {
    cerr << "Failure: " << getRedStatusStr(status) << endl;
  }

  return status;
}

int fplll_bkz_trans(fmpz_mat_t A, fmpz_mat_t T, int bs)
{
  BKZParam param;
  IntMatrix b, u;
  int status;

  param.blockSize = bs;

  b = IntMatrix(A->r, A->c);
  flint_to_fplll(b, A);

  u = IntMatrix(A->r, A->r);

  status = bkzReduction(&b, &u, param, FT_DEFAULT);

  fplll_to_flint(A, b);
  fplll_to_flint(T, u);
  b.clear();
  u.clear();

  if (status != RED_SUCCESS) {
    cerr << "Failure: " << getRedStatusStr(status) << endl;
  }
  return status;
}

int fplll_lll(fmpz_mat_t A)
{
  IntMatrix b;
  int status;
  double delta = LLL_DEF_DELTA, eta = LLL_DEF_ETA;

  b = IntMatrix(A->r, A->c);
  flint_to_fplll(b, A);

  status = lllReduction(b, delta, eta, LM_PROVED, FT_DEFAULT, 0, 0);

  fplll_to_flint(A, b);
  b.clear();

  if (status != RED_SUCCESS) {
    cerr << "Failure: " << getRedStatusStr(status) << endl;
  }

  return status;
}

int fplll_lll_trans(fmpz_mat_t A, fmpz_mat_t T)
{
  IntMatrix b, u;
  int status;
  double delta = LLL_DEF_DELTA, eta = LLL_DEF_ETA;

  b = IntMatrix(A->r, A->c);
  flint_to_fplll(b, A);

  u = IntMatrix(A->r, A->r);

  status = lllReduction(b, u, delta, eta, LM_PROVED, FT_DEFAULT, 0, 0);

  fplll_to_flint(A, b);
  fplll_to_flint(T, u);
  b.clear();
  u.clear();

  if (status != RED_SUCCESS) {
    cerr << "Failure: " << getRedStatusStr(status) << endl;
  }
  return status;
}


}
