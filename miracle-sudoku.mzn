include "alldifferent.mzn";

array[1..9, 1..9] of var 1..9: grid;

% basic sudoku rules
constraint forall(col in 1..9)(
    alldifferent([grid[col, row] | row in 1..9])
);
constraint forall(row in 1..9)(
    alldifferent([grid[col, row] | col in 1..9])
);
constraint forall(row_block in 0..2, col_block in 0..2)(
    alldifferent(
        [
            grid[3 * col_block + col, 3 * row_block + row]
                | col in 1..3, row in 1..3
        ]
    )
);


% cells that are a king's move apart cannot have the same number
constraint forall(col in 1..9, row in 1..9, col_move in -1..1, row_move in -1..1
    where (col_move != 0 \/ row_move != 0)
      /\ (col + col_move in 1..9)
      /\ (row + row_move in 1..9))(
    grid[col, row] != grid[col + col_move, row + row_move]
);


% cells that are a knight's move apart cannot have the same number
constraint forall(col in 1..9, row in 1..9, col_move in {-1, 1}, row_move in {-2, 2}
    where (col + col_move in 1..9) 
      /\ (row + row_move in 1..9))(
    grid[col, row] != grid[col + col_move, row + row_move]
);
constraint forall(col in 1..9, row in 1..9, row_move in {-1, 1}, col_move in {-2, 2}
    where (row + row_move in 1..9)
      /\ (col + col_move in 1..9))(
    grid[col, row] != grid[col + col_move, row+row_move]
);


% orthogonal adjacencies cannot be consecutive numbers
constraint forall(col in 1..9, row in 1..9, col_move in {-1, 1}, dif in {-1,1} 
    where (col + col_move in 1..9))(
    grid[col, row] != grid[col + col_move, row] + dif
);
constraint forall(col in 1..9, row in 1..9, row_move in {-1, 1}, dif in {-1,1} 
    where (row + row_move in 1..9))(
    grid[col, row] != grid[col, row + row_move] + dif
);


% initial placement. without these, the solver takes 2.5s to find all of the solutions
constraint grid[5,3] = 1;
constraint grid[6,7] = 2;

% Running miracle_sudoku.mzn
% grid = array2d(1..9, 1..9,
% [
%    4, 8, 3, 7, 2, 6, 1, 5, 9, 
%    7, 2, 6, 1, 5, 9, 4, 8, 3,
%    1, 5, 9, 4, 8, 3, 7, 2, 6,
%    8, 3, 7, 2, 6, 1, 5, 9, 4,
%    2, 6, 1, 5, 9, 4, 8, 3, 7,
%    5, 9, 4, 8, 3, 7, 2, 6, 1,
%    3, 7, 2, 6, 1, 5, 9, 4, 8,
%    6, 1, 5, 9, 4, 8, 3, 7, 2,
%    9, 4, 8, 3, 7, 2, 6, 1, 5
% ]);
% ----------
% Finished in 126msec
