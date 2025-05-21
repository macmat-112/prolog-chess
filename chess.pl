% todo:
% back
% stop
% roszada
% promocja

start_game():-
	nl,
	print_board([[wc, sc, gc, hc, kc, gc, sc, wc], [pc, pc, pc, pc, pc, pc, pc, pc], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [pb, pb, pb, pb, pb, pb, pb, pb], [wb, sb, gb, hb, kb, gb, sb, wb]]),
	turn_w([[wc, sc, gc, hc, kc, gc, sc, wc], [pc, pc, pc, pc, pc, pc, pc, pc], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [pb, pb, pb, pb, pb, pb, pb, pb], [wb, sb, gb, hb, kb, gb, sb, wb]]).

turn_w(Board):- nl, write('Teraz bialy: '), nl, read(A), read(B), read(C), read(D), nl, move_w(Board, A, B, C, D, Result, BoardResult), next_turn(w, Result, Board, BoardResult).
turn_b(Board):- nl, write('Teraz czarny: '), nl, read(A), read(B), read(C), read(D), nl, move_b(Board, A, B, C, D, Result, BoardResult), next_turn(b, Result, Board, BoardResult).

move_w(Board, Row1, Col1, Row2, Col2, Result, BoardResult):-
	integer(Row1),
	integer(Col1),
	integer(Row2),
	integer(Col2),
	nth0(Row1, Board, Row1List),
	nth0(Col1, Row1List, PieceFrom),
	nth0(Row2, Board, Row2List),
	nth0(Col2, Row2List, PieceTo),
	decide_piece_w(Board, Row1, Row2, Row1List, Row2List, Col1, Col2, PieceFrom, PieceTo, Result, BoardResult).

move_w(Board, _, _, _, _, _, BoardResult):-
	write('Niepoprawne wspolrzedne! [X1, Y1, X2, Y2]'),
	nl,
	nl,
	next_turn(w, 0, Board, BoardResult).

move_b(Board, Row1, Col1, Row2, Col2, Result, BoardResult):-
	integer(Row1),
	integer(Col1),
	integer(Row2),
	integer(Col2),
	nth0(Row1, Board, Row1List),
	nth0(Col1, Row1List, PieceFrom),
	nth0(Row2, Board, Row2List),
	nth0(Col2, Row2List, PieceTo),
	decide_piece_b(Board, Row1, Row2, Row1List, Row2List, Col1, Col2, PieceFrom, PieceTo, Result, BoardResult).

move_b(Board, _, _, _, _, _, BoardResult):-
	write('Niepoprawne wspolrzedne! [X1, Y1, X2, Y2]'),
	nl,
	nl,
	next_turn(b, 0, Board, BoardResult).

% -------------------
% Ruchy białego piona
% -------------------

decide_piece_w(Board, Row1, Row2, Row1List, _, Col1, Col2, 'pb', '--', Result, BoardResult):-
	Row2 is Row1-2,
	Col2 is Col1,
	nth0(6, Board, Row1List),
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'pb', '--', Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1,
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1-1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1+1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

% ------------------
% Ruchy białej wieży
% ------------------

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'wb', '--', Result, BoardResult):-
	Row2 is Row1,
	Col2 =\= Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wb', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2<Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wb', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2>Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'wb', '--', Result, BoardResult):-
	Row2 =\= Row1,
	Col2 is Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wb', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2 is Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wb', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2 is Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
% ---------------------
% Ruchy białego skoczka
% ---------------------

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1+2,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1-2,
	Col2 is Col1+1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1-2,
	Col2 is Col1-1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1-2,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1-2,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1+2,
	Col2 is Col1-1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1+2,
	Col2 is Col1+1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sb', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1+2,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.

% -------------------
% Ruchy białego gońca
% -------------------

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'gb', '--', Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'gb', '--', Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'gb', '--', Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'gb', '--', Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gb', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gb', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gb', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gb', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

% ---------------------
% Ruchy białego hetmana
% ---------------------

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'hb', '--', Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'hb', '--', Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'hb', '--', Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'hb', '--', Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'hb', '--', Result, BoardResult):-
	Row2 is Row1,
	Col2 =\= Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2<Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2>Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, _, Col1, Col2, 'hb', '--', Result, BoardResult):-
	Row2 =\= Row1,
	Col2 is Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2 is Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hb', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2 is Col1,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

% -------------------
% Ruchy białego króla
% -------------------

decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2 is Col1+1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1+1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1-1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2 is Col1-1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1-1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_w(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kb', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1+1,
	empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.

% -----------------------------------
% Przypadek ogólny - zły ruch białego
% -----------------------------------

decide_piece_w(_, _, _, _, _, _, _, _, _, Result, _):-
	write('Niepoprawny ruch!'),
	nl,
	nl,
	Result is 0.

% --------------------
% Ruchy czarnego piona
% --------------------

decide_piece_b(Board, Row1, Row2, Row1List, _, Col1, Col2, 'pc', '--', Result, BoardResult):-
	Row2 is Row1+2,
	Col2 is Col1,
	nth0(1, Board, Row1List),
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'pc', '--', Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1,
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1-1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'pc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1+1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

% -------------------
% Ruchy czarnej wieży
% -------------------

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'wc', '--', Result, BoardResult):-
	Row2 is Row1,
	Col2 =\= Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wc', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2<Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wc', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2>Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'wc', '--', Result, BoardResult):-
	Row2 =\= Row1,
	Col2 is Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wc', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2 is Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2+1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'wc', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2 is Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2-1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

% ----------------------
% Ruchy czarnego skoczka
% ----------------------

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1+2,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1-2,
	Col2 is Col1+1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1-2,
	Col2 is Col1-1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1-2,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1-2,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1+2,
	Col2 is Col1-1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1+2,
	Col2 is Col1+1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'sc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1+2,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.

% --------------------
% Ruchy czarnego gońca
% --------------------

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'gc', '--', Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'gc', '--', Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'gc', '--', Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'gc', '--', Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gc', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2+1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gc', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2+1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gc', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2-1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'gc', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2-1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

% ----------------------
% Ruchy czarnego hetmana
% ----------------------

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'hc', '--', Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'hc', '--', Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'hc', '--', Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'hc', '--', Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2+1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2<Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol+DistRow =:= 0,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2>Col1,
	DistRow is Row2-Row1,
	DistCol is Col2-Col1,
	DistCol =:= DistRow,
	member(PieceTo, [wc, sc, gc, hc, pc]),
	check_empty(Board, Row1, Row2-1, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'hc', '--', Result, BoardResult):-
	Row2 is Row1,
	Col2 =\= Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2<Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2, Col1, Col2+1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2>Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2, Col1, Col2-1),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, _, Col1, Col2, 'hc', '--', Result, BoardResult):-
	Row2 =\= Row1,
	Col2 is Col1,
	check_empty(Board, Row1, Row2, Col1, Col2),
	swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult),
	Result is 1.

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2<Row1,
	Col2 is Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2+1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'hc', PieceTo, Result, BoardResult):-
	Row2>Row1,
	Col2 is Col1,
	member(PieceTo, [wb, sb, gb, hb, pb]),
	check_empty(Board, Row1, Row2-1, Col1, Col2),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult),
	Result is 1.

% --------------------
% Ruchy czarnego króla
% --------------------

decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2 is Col1+1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1+1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1-1,
	Col2 is Col1-1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1,
	Col2 is Col1-1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1-1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.
	
decide_piece_b(Board, Row1, Row2, _, Row2List, Col1, Col2, 'kc', PieceTo, Result, BoardResult):-
	Row2 is Row1+1,
	Col2 is Col1+1,
	empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, PieceTo, BoardResult),
	Result is 1.

% ------------------------------------
% Przypadek ogólny - zły ruch czarnego
% ------------------------------------

decide_piece_b(_, _, _, _, _, _, _, _, _, Result, _):-
	write('Niepoprawny ruch!'),
	nl,
	nl,
	Result is 0.

empty_or_not_w(Board, Row1, Col1, Row2, Col2, _, '--', BoardResult):- swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult).
empty_or_not_w(Board, Row1, Col1, Row2, Col2, Row2List, Piece, BoardResult):-
	member(Piece, [wc, sc, gc, hc, pc]),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult).

empty_or_not_b(Board, Row1, Col1, Row2, Col2, _, '--', BoardResult):- swap_pieces(Board, Row1, Col1, Row2, Col2, BoardResult).
empty_or_not_b(Board, Row1, Col1, Row2, Col2, Row2List, Piece, BoardResult):-
	member(Piece, [wb, sb, gb, hb, pb]),
	destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult).

destroy_and_swap(Board, Row1, Col1, Row2, Col2, Row2List, BoardResult):-
	destroy(Row2List, Col2, _, '--', NewRow2List),
	destroy(Board, Row2, _, NewRow2List, NewBoard),
	swap_pieces(NewBoard, Row1, Col1, Row2, Col2, BoardResult).

destroy(List, Index, OldElem, NewElem, NewList):-
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

next_turn(w, 1, _, BoardResult):-
	print_board(BoardResult),
	turn_b(BoardResult).

next_turn(w, 0, Board, _):-
	print_board(Board),
	turn_w(Board).

next_turn(b, 1, _, BoardResult):-
	print_board(BoardResult),
	turn_w(BoardResult).

next_turn(b, 0, Board, _):-
	print_board(Board),
	turn_b(Board).
