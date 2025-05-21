% turn_w([[wc, sc, gc, hc, kc, gc, sc, wc], [pc, pc, pc, pc, pc, pc, pc, pc], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [pb, pb, pb, pb, pb, pb, pb, pb], [wb, sb, gb, hb, kb, gb, sb, wb]]).
turn_w(Board):- nl, write('Teraz biały: '), read(A), read(B), read(C), read(D), move_w(Board, A, B, C, D, Result, BoardResult), print_board(BoardResult), next_turn(w, Result, BoardResult).
turn_b(Board):- nl, write('Teraz czarny: '), read(A), read(B), read(C), read(D), move_b(Board, A, B, C, D, Result, BoardResult), print_board(BoardResult), next_turn(b, Result, BoardResult).

move_w(Board, Row1, Col1, Row2, Col2, Result, BoardResult):-
	nth0(Row1, Board, Row1List),
	nth0(Col1, Row1List, PieceFrom),
	nth0(Row2, Board, Row2List),
	nth0(Col2, Row2List, PieceTo),
	decide_piece_w(Board, Row1, Row2, Row1List, Row2List, Col1, Col2, PieceFrom, PieceTo, Result, BoardResult).

move_b(Board, Row1, Col1, Row2, Col2, Result, BoardResult):-
	nth0(Row1, Board, Row1List),
	nth0(Col1, Row1List, PieceFrom),
	nth0(Row2, Board, Row2List),
	nth0(Col2, Row2List, PieceTo),
	decide_piece_b(Board, Row1, Row2, Row1List, Row2List, Col1, Col2, PieceFrom, PieceTo, Result, BoardResult).

decide_piece_w(Board, Row1, Row2, Row1List, _, Col1, Col2, 'pb', '--', Result, BoardResult):-
	Row2 is Row1-2,
	Col2 is Col1,
	nth0(6, Board, Row1List),
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result=0.

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'pb', '--', Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1,
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result=1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1-1,
	PieceTo is not '--',
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result=1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1+1,
	PieceTo is not '--',
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result=1.

decide_piece_b(Board, Row1, Row2, Row1List, _, Col1, Col2, 'pc', '--', Result, BoardResult):-
	Row2 is Row1+2,
	Col2 is Col1,
	nth0(1, Board, Row1List),
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult)
	Result=1.

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'pc', '--', Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1,
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result=1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1-1,
	PieceTo is not '--',
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result=1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1+1,
	PieceTo is not '--',
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result=1.

decide_piece(Board, _, _, _, _, _, _, _, _, Result, BoardResult):-
	nl,
	write('Niepoprawny ruch!'),
	nl,
	Result=0,
	BoardResult is Board.

destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult):-
	replace(Row2List, Col2, _, '--', NewRow2List),
	replace(Board, Row2, _, NewRow2List, NewBoard),
	swap_pieces(NewBoard, Row1, Col1, Row2, Col2, BoardResult).

replace(List, Index, OldElem, NewElem, NewList):-
	nth0(Index,List,OldElem,Transfer),
	nth0(Index,NewList,NewElem,Transfer).

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

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1 is Row2,
	Col1>Col2,
	NewCol1 is Col1-1,
	nth0(Row1, Board, Row1List),
	nth0(NewCol1, Row1List, '--'),
	check_empty(Board, Row1, Row2, NewCol1, Col2).

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1 is Row2,
	Col1<Col2,
	NewCol1 is Col1+1,
	nth0(Row1, Board, Row1List),
	nth0(NewCol1, Row1List, '--'),
	check_empty(Board, Row1, Row2, NewCol1, Col2).

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1>Row2,
	Col1 is Col2,
	NewRow1 is Row1-1,
	nth0(NewRow1, Board, NewRow1List),
	nth0(Col1, NewRow1List, '--'),
	check_empty(Board, NewRow1, Row2, Col1, Col2).

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1<Row2,
	Col1 is Col2,
	NewRow1 is Row1+1,
	nth0(NewRow1, Board, NewRow1List),
	nth0(Col1, NewRow1List, '--'),
	check_empty(Board, NewRow1, Row2, Col1, Col2).

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1>Row2,
	Col1>Col2,
	NewRow1 is Row1-1,
	NewCol1 is Col1-1,
	nth0(NewRow1, Board, NewRow1List),
	nth0(NewCol1, NewRow1List, '--'),
	check_empty(Board, NewRow1, Row2, Col1, Col2).

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1<Row2,
	Col1>Col2,
	NewRow1 is Row1+1,
	NewCol1 is Col1-1,
	nth0(NewRow1, Board, NewRow1List),
	nth0(NewCol1, NewRow1List, '--'),
	check_empty(Board, NewRow1, Row2, Col1, Col2).

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1>Row2,
	Col1<Col2,
	NewRow1 is Row1-1,
	NewCol1 is Col1+1,
	nth0(NewRow1, Board, NewRow1List),
	nth0(NewCol1, NewRow1List, '--'),
	check_empty(Board, NewRow1, Row2, Col1, Col2).

check_empty(Board, Row1, Row2, Col1, Col2):-
	Row1<Row2,
	Col1<Col2,
	NewRow1 is Row1+1,
	NewCol1 is Col1+1,
	nth0(NewRow1, Board, NewRow1List),
	nth0(NewCol1, NewRow1List, '--'),
	check_empty(Board, NewRow1, Row2, Col1, Col2).

check_empty(_, Row1, Row2, Col1, Col2):-
	Row1 is Row2,
	Col1 is Col2.

print_board([]).
print_board([H|T]):- write(H), nl, print_board(T).

next_turn(w, 1, Board):- turn_b(Board).
next_turn(w, 0, Board):- turn_w(Board).
next_turn(b, 1, Board):- turn_w(Board).
next_turn(b, 0, Board):- turn_b(Board).
