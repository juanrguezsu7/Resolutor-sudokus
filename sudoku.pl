% Se importa el módulo output.pl para poder redirigir la salida a un fichero.
:- [output].

% Se obtienen los elementos de la fila RowN empezando por 0 y deja la lista en [RowHead|RowTail].
row(_, _, 9, []). % Caso base.
row(Sudoku, RowN, RowOffset, [RowHead|RowTail]) :-
    NumberIndex is RowN * 9 + RowOffset, % Se obtiene el índice del elemento de la fila.
    nth0(NumberIndex, Sudoku, RowHead), % Se obtiene el elemento de la fila en el índice obtenido.
    NewRowOffset is RowOffset + 1, % Se incrementa el offset de la fila.
    row(Sudoku, RowN, NewRowOffset, RowTail). % Se obtiene el resto de la fila.

% Se obtienen los elementos de la columna N empezando por 0 y deja la lista en [ColumnHead|ColumnTail].
column(_, _, 9, []). % Caso base.
column(Sudoku, ColumnN, ColumnOffset, [ColumnHead|ColumnTail]) :-
    NumberIndex is ColumnOffset * 9 + ColumnN, % Se obtiene el índice del elemento de la columna.
    nth0(NumberIndex, Sudoku, ColumnHead), % Se obtiene el elemento de la columna en el índice obtenido.
    NewColumnOffset is ColumnOffset + 1, % Se incrementa el offset de la columna.
    column(Sudoku, ColumnN, NewColumnOffset, ColumnTail). % Se obtiene el resto de la columna.

% Se obtienen los elementos del cuadrado N empezando por 0 y deja la lista en [Left, Middle, Right|SquareTail].
square(_, _, 27, []). % Caso base.
square(Sudoku, SquareN, SquareOffset, [Left, Middle, Right|SquareTail]) :-
    SquareRow is SquareN // 3, % Se obtiene el offset de la fila del cuadrado.
    SquareColumn is SquareN mod 3, % Se obtiene el offset de la columna del cuadrado.
    NumberIndexLeft is SquareRow * 27 + SquareColumn * 3 + SquareOffset, 
    nth0(NumberIndexLeft, Sudoku, Left),
    NumberIndexMiddle is SquareRow * 27 + SquareColumn * 3 + SquareOffset + 1, 
    nth0(NumberIndexMiddle, Sudoku, Middle),
    NumberIndexRight is SquareRow * 27 + SquareColumn * 3 + SquareOffset + 2, 
    nth0(NumberIndexRight, Sudoku, Right),
    NewSquareOffset is SquareOffset + 9,
    square(Sudoku, SquareN, NewSquareOffset, SquareTail).

% Se comprueba que los elementos de una fila Row_N no se repiten.
check_rows(_, 9). % Caso base.
check_rows(SolvedSudoku, Row_N) :-
    row(SolvedSudoku, Row_N, 0, R), % Se obtiene la fila Row_N.
    is_set(R), % Se comprueba que no hay elementos repetidos.
    New_Row_N is Row_N + 1, % Se incrementa el número de fila.
    check_rows(SolvedSudoku, New_Row_N). % Se comprueba la siguiente fila.

% Se comprueba que los elementos de una columna Column_N no se repiten.
check_columns(_, 9). % Caso base.
check_columns(SolvedSudoku, Column_N) :-
    column(SolvedSudoku, Column_N, 0, C), % Se obtiene la columna Column_N.
    is_set(C), % Se comprueba que no hay elementos repetidos.
    New_Column_N is Column_N + 1, % Se incrementa el número de columna.
    check_columns(SolvedSudoku, New_Column_N). % Se comprueba la siguiente columna.

% Se comprueba que los elementos de un cuadrado Square_N no se repiten.
check_squares(_, 9). % Caso base.
check_squares(SolvedSudoku, Square_N) :-
    square(SolvedSudoku, Square_N, 0, S), % Se obtiene el cuadrado Square_N.
    is_set(S), % Se comprueba que no hay elementos repetidos.
    New_Square_N is Square_N + 1, % Se incrementa el número de cuadrado.
    check_squares(SolvedSudoku, New_Square_N). % Se comprueba el siguiente cuadrado.

% Comprueba que el número N cumple las restricciones del sudoku.
check(SolvedSudoku, N) :-
    between(1, 9, N), % Se comprueba que N esté entre 1 y 9. Este es el punto de resatisfacción principal. 
    check_rows(SolvedSudoku, 0), % Se comprueba que las filas no contienen números repetidos.
    check_columns(SolvedSudoku, 0), % Se comprueba que las columnas no contienen números repetidos.
    check_squares(SolvedSudoku, 0). % Se comprueba que los cuadrados no contienen números repetidos.

% Gramática para construir la lista del sudoku colocando variables donde haya 'x'.
program([H|T]) --> digit(H), program(T). % Producción principal.
program([]) --> []. % Caso base.
digit(N) --> [N], { number(N) }. % Si es un número, se deja tal cual
digit(_) --> [x]. % Si es una 'x', se sustituye por una variable.

% Predicado principal. Se encarga de llamar a la gramática y de comprobar que el sudoku
%   solucionado cumple las restricciones.
sudoku(Sudoku, SolvedSudoku) :-
    phrase(program(SolvedSudoku), Sudoku), % Se llama a la gramática para construir SolvedSudoku con variables y números.
    !, % Operador de corte para evitar que se reconstruya el sudoku en caso de resatisfacción (no cumpliría con las especificaciones del problema proporcionado).
    maplist(check(SolvedSudoku), SolvedSudoku), % Para cada elemento de SolvedSudoku, se comprueba que cumple las restricciones.
    save_to_file(SolvedSudoku).