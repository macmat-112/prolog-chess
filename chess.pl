% turn_w([[wc, sc, gc, hc, kc, gc, sc, wc], [pc, pc, pc, pc, pc, pc, pc, pc], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [pb, pb, pb, pb, pb, pb, pb, pb], [wb, sb, gb, hb, kb, gb, sb, wb]]).
turn_w(P):- nl, write('Teraz bia³y: '), read(A), read(B), read(C), read(D), move(P, A, B, C, D).
turn_b(P):- nl, write('Teraz czarny: '), read(A), read(B), read(C), read(D), move(P, A, B, C, D).

/*
test(A, B, P):- idz_y(A, 1, B, P).
idz_y(X, Y, Y, [H|_]):- idz_x(1, X, H), !.
idz_y(X, Y, Z, [_|T]):- Y<Z, Y1 is Y+1, idz_y(X, Y1, Z, T).
idz_x(X, X, [H|_]):- write(H), !.
idz_x(X, Z, [_|T]):- X<Z, X1 is X+1, idz_x(X1, Z, T).
*/

swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult) :-
    nth0(Row1, Board, Row1Get),
    nth0(Col1, Row1Get, Piece1),
    nth0(Row2, Board, Row2Get),
    nth0(Col2, Row2Get, Piece2),
    replace_piece(Board, Row1, Col1, Piece2, TempBoard),
    replace_piece(TempBoard, Row2, Col2, Piece1, BoardResult).

replace_piece(Board, Row, Col, Piece, ResultBoard) :-
    nth0(Row, Board, NewRow, RestRows),
    replace_in_row(NewRow, Col, Piece, ResultRow),
    nth0(Row, ResultBoard, ResultRow, RestRows).

replace_in_row(Row, Col, Piece, ResultRow):-
    nth0(Col, Row, _, Rest),
    nth0(Col, ResultRow, Piece, Rest).

move(Board, Row1, Col1, Row2, Col2):-
	nth0(Row1, Board, Row1Get),
	nth0(Col1, Row1Get, Piece),
	decide_piece(Board, Row1, Row2, Row1Get, Col1, Col2, Piece).

decide_piece(Board, Row1, Row2, Row1Get, Col1, Col2, 'pb'):-
	Row2 is Row1-2,
	nth0(6, Board, Row1Get),
	check_empty_col_up(Board, Row1, Row2, Col1),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	print_board(BoardResult),
	turn_b(BoardResult).

decide_piece(Board, Row1, Row2, _, Col1, Col2, 'pb'):-
	Row2 is Row1-1,
	check_empty_col_up(Board, Row1, Row2, Col1),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	print_board(BoardResult),
	turn_b(BoardResult).

decide_piece(Board, Row1, Row2, Row1Get, Col1, Col2, 'pc'):-
	Row2 is Row1+2,
	nth0(1, Board, Row1Get),
	check_empty_col_down(Board, Row1, Row2, Col1),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	print_board(BoardResult),
	turn_w(BoardResult).

decide_piece(Board, Row1, Row2, _, Col1, Col2, 'pc'):-
	Row2 is Row1+1,
	check_empty_col_down(Board, Row1, Row2, Col1),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	print_board(BoardResult),
	turn_w(BoardResult).

decide_piece(Board, _, _, _, _, _, Piece):-
	write('Niepoprawny ruch!'),
	nl,
	print_board(Board),
	repeat_move(Piece, Board).

repeat_move('pb', Board):- turn_w(Board).
repeat_move('pc', Board):- turn_b(Board).

check_empty_col_up(_, Row, Lim, _):- Row is Lim.

check_empty_col_up(Board, Row, Lim, Col):-
	Row>Lim,
	NextRow is Row-1,
	nth0(NextRow, Board, NextRowGet),
	nth0(Col, NextRowGet, '--'),
	check_empty_col_up(Board, NextRow, Lim, Col).

check_empty_col_down(_, Row, Lim, _):- Row is Lim.

check_empty_col_down(Board, Row, Lim, Col):-
	Row<Lim,
	NextRow is Row+1,
	nth0(NextRow, Board, NextRowGet),
	nth0(Col, NextRowGet, '--'),
	check_empty_col_up(Board, NextRow, Lim, Col).

go_to(Board, Row1, Col1):-
	nth0(Row1, Board, Row1Get),
	nth0(Col1, Row1Get, _).

print_board([]).
print_board([H|T]):- write(H), nl, print_board(T).




















/*
print_2d(A, B, P):- goto_y(A, 1, B, P).
goto_y(X, Y, Y, [H|_]):- goto_x(1, X, H), !.
goto_y(X, Y, Z, [_|T]):- Y<Z, Y1 is Y+1, goto_y(X, Y1, Z, T).
goto_x(X, X, [H|_]):- write(H), !.
goto_x(X, Z, [_,T]):- X<Z, X1 is X+1, goto_x(X1, Z, T).

?- swap_elements([[1, 2, 3], [4, 5, 6], [7, 8, 9]], 0, 1, 2, 2, Result).
Result = [[1, 9, 3], [4, 5, 6], [7, 8, 2]].
*/
