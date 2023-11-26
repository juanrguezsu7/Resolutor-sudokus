% Formatea el sudoku resuelto para que sea más legible.
pretty_formatting([], _, _). % Caso base.
pretty_formatting([SolvedSudokuHead|SolvedSudokuTail], Stream, NumberIndex) :- % Si el índice es múltiplo de 9, se ha acabado la fila.
    NumberIndex \= 0,
    R is NumberIndex mod 9,
    R = 0,
    write(Stream, '\n'),
    write(Stream, SolvedSudokuHead),
    write(Stream, ' '),
    NewNumberIndex is NumberIndex + 1,
    pretty_formatting(SolvedSudokuTail, Stream, NewNumberIndex).
pretty_formatting([SolvedSudokuHead|SolvedSudokuTail], Stream, NumberIndex) :- % Caso general.
    NumberIndex mod 9 \= 0,
    write(Stream, SolvedSudokuHead),
    write(Stream, ' '),
    NewNumberIndex is NumberIndex + 1,
    pretty_formatting(SolvedSudokuTail, Stream, NewNumberIndex).

% Guarda en un fichero el sudoku resuelto con un formato más legible.
save_to_file(SolvedSudoku) :-
    open('sudoku_resuelto.txt', write, Stream),
    pretty_formatting(SolvedSudoku, Stream, 0),
    !,
    close(Stream).