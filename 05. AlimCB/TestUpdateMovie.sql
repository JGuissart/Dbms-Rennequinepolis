DECLARE
	V_TabMoviesExt AlimCB.T_MoviesExt;
	V_MovieExt Movies_ext%ROWTYPE;
	V_NombreCopies NUMBER;
BEGIN
	SELECT NombreCopies INTO V_NombreCopies
	FROM Movies
	WHERE idMovie = '99875';

	SELECT * INTO V_MovieExt
	FROM Movies_ext
	WHERE id = 99875;

	DBMS_OUTPUT.PUT_LINE('Nombre de copies avant update = ' || V_NombreCopies);
	V_TabMoviesExt(1) := V_MovieExt;
	AlimCB.Parse(V_TabMoviesExt);

	SELECT NombreCopies INTO V_NombreCopies
	FROM Movies
	WHERE idMovie = '99875';
	DBMS_OUTPUT.PUT_LINE('Nombre de copies après update = ' || V_NombreCopies);
END;