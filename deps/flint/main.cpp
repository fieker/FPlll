/* Copyright (C) 2005-2008 Damien Stehle.
   Copyright (C) 2007 David Cade.
   Copyright (C) 2008-2011 Xavier Pujol.

   This file is part of fplll. fplll is free software: you
   can redistribute it and/or modify it under the terms of the GNU Lesser
   General Public License as published by the Free Software Foundation,
   either version 2.1 of the License, or (at your option) any later version.

   fplll is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with fplll. If not, see <http://www.gnu.org/licenses/>. */

#include "config.h"
#include "main.h"

#include "flint/fmpz.h"
#include "flint/fmpz_mat.h"

/*
typedef struct
{ 
  void * entries;
  long r;
  long c;
  void * rows;
} flint_mat_t;
*/


extern "C" {

int fplll_bkz(fmpz_mat_t A, int bs)
{
  BKZParam param;
  IntMatrix b;
  int status;

  param.blockSize = bs;

  b = IntMatrix(A->r, A->c);
  for(int i=0; i<A->r; i++) {
    for(int j=0; j<A->c; j++) {
      fmpz_get_mpz(b[i][j].getData(), fmpz_mat_entry(A, i, j));
    }
  }

  status = bkzReduction(&b, NULL, param, FT_DEFAULT);

  for(int i=0; i<A->r; i++) {
    for(int j=0; j<A->c; j++) {
      fmpz_set_mpz(fmpz_mat_entry(A, i, j), b[i][j].getData());
    }
  }  

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
  for(int i=0; i<A->r; i++) {
    for(int j=0; j<A->c; j++) {
      fmpz_get_mpz(b[i][j].getData(), fmpz_mat_entry(A, i, j));
    }
  }

  u = IntMatrix(A->r, A->r);

  status = bkzReduction(&b, &u, param, FT_DEFAULT);

  for(int i=0; i<A->r; i++) {
    for(int j=0; j<A->c; j++) {
      fmpz_set_mpz(fmpz_mat_entry(A, i, j), b[i][j].getData());
    }
  }  
  b.clear();

  for(int i=0; i<T->r; i++) {
    for(int j=0; j<T->c; j++) {
      fmpz_set_mpz(fmpz_mat_entry(T, i, j), u[i][j].getData());
    }
  }  

  u.clear();

  if (status != RED_SUCCESS) {
    cerr << "Failure: " << getRedStatusStr(status) << endl;
  }
  return status;
}

}
