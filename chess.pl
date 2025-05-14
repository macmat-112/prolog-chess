% ruch_b([[w2, s2, g2, h2, k2, g2, s2, w2], [p2, p2, p2, p2, p2, p2, p2, p2], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [--, --, --, --, --, --, --, --], [p1, p1, p1, p1, p1, p1, p1, p1], [w1, s1, g1, h1, k1, g1, s1, w1]]).
ruch_b(P):- nl, write('Teraz bia³y: '), read(A), read(B), read(C), read(D), swap_elements(P, A, B, C, D, P1), wypisz_plansze(P1), ruch_c(P1).
ruch_c(P):- nl, write('Teraz czarny: '), read(A), read(B), read(C), read(D), swap_elements(P, A, B, C, D, P1), wypisz_plansze(P1), ruch_b(P1).
test(A, B, P):- idz_y(A, 1, B, P).
idz_y(X, Y, Y, [H|_]):- idz_x(1, X, H), !.
idz_y(X, Y, Z, [_|T]):- Y<Z, Y1 is Y+1, idz_y(X, Y1, Z, T).
idz_x(X, X, [H|_]):- write(H), !.
idz_x(X, Z, [_|T]):- X<Z, X1 is X+1, idz_x(X1, Z, T).

% G³ówna regu³a zamiany elementów
swap_elements(Matrix, Row1, Col1, Row2, Col2, Result) :-
    nth0(Row1, Matrix, Row1List),
    nth0(Col1, Row1List, Elem1),
    nth0(Row2, Matrix, Row2List),
    nth0(Col2, Row2List, Elem2),
    replace_element(Matrix, Row1, Col1, Elem2, TempMatrix),
    replace_element(TempMatrix, Row2, Col2, Elem1, Result).

% Zamiana elementu w macierzy
replace_element(Matrix, Row, Col, NewValue, Result) :-
    nth0(Row, Matrix, RowList, RestRows),
    replace_in_list(RowList, Col, NewValue, NewRowList),
    nth0(Row, Result, NewRowList, RestRows).

% Zamiana elementu w liœcie
replace_in_list(List, Index, NewValue, Result) :-
    nth0(Index, List, _, Rest),
    nth0(Index, Result, NewValue, Rest).

wypisz_plansze([]).
wypisz_plansze([H|T]):- write(H), nl, wypisz_plansze(T).

/*
print_2d(A, B, P):- goto_y(A, 1, B, P).
goto_y(X, Y, Y, [H|_]):- goto_x(1, X, H), !.
goto_y(X, Y, Z, [_|T]):- Y<Z, Y1 is Y+1, goto_y(X, Y1, Z, T).
goto_x(X, X, [H|_]):- write(H), !.
goto_x(X, Z, [_,T]):- X<Z, X1 is X+1, goto_x(X1, Z, T).

?- swap_elements([[1, 2, 3], [4, 5, 6], [7, 8, 9]], 0, 1, 2, 2, Result).
Result = [[1, 9, 3], [4, 5, 6], [7, 8, 2]].
*/
