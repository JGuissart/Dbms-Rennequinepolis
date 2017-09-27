create or replace PACKAGE ALIMCB AS

	TYPE R_Logs IS RECORD
	(
		Id Logs.idLogs%TYPE,
		LogWhen Logs.LogWhen%TYPE,
		ErrorCode Logs.ErrorCode%TYPE,
		LogWhat Logs.LogWhat%TYPE,
		LogWhere Logs.LogWhere%TYPE
	);

	TYPE R_Actors IS RECORD
	(
		idPeople MovieActor.idPeople%TYPE,
		Name People.Name%TYPE,
		CastId MovieActor.CastId%TYPE,
		CharacterName MovieActor.CharacterName%TYPE,
		idPoster People.idPoster%TYPE,
		poster_path Posters.poster_path%TYPE
	);
	
	TYPE R_Directors IS RECORD
	(
		idPeople MovieActor.idPeople%TYPE,
		Name People.Name%TYPE,
		idPoster People.idPoster%TYPE,
		poster_path Posters.poster_path%TYPE
	);
	
	TYPE T_Actors IS TABLE OF R_Actors INDEX BY PLS_INTEGER;
	TYPE T_Genres IS TABLE OF Genres%ROWTYPE INDEX BY PLS_INTEGER;
	TYPE T_People IS TABLE OF R_Directors INDEX BY PLS_INTEGER;
	TYPE T_Posters IS TABLE OF Posters%ROWTYPE INDEX BY PLS_INTEGER;
	TYPE T_ProductionCompanies IS TABLE OF ProductionCompanies%ROWTYPE INDEX BY PLS_INTEGER;
	TYPE T_ProductionCountries IS TABLE OF ProductionsCountries%ROWTYPE INDEX BY PLS_INTEGER;
	TYPE T_SpokenLanguages IS TABLE OF SpokenLanguages%ROWTYPE INDEX BY PLS_INTEGER;

	TYPE R_MovieToAdd IS RECORD
	(
		idMovie Movies.idMovie%TYPE,
		title Movies.title%TYPE,
		original_title Movies.original_title%TYPE,
		release_date Movies.release_date%TYPE,
		status Movies.status%TYPE,
		vote_average Movies.vote_average%TYPE,
		vote_count Movies.vote_count%TYPE,
		runtime Movies.runtime%TYPE,
		certification Movies.certification%TYPE,
		budget Movies.budget%TYPE,
		revenue Movies.revenue%TYPE,
		homepage Movies.homepage%TYPE,
		tagline Movies.tagline%TYPE,
		overview Movies.overview%TYPE,
		nombreCopies Movies.nombreCopies%TYPE,
		idPoster Movies.idPoster%TYPE,
		poster_pathMovie Posters.poster_path%TYPE,
		TabGenres T_Genres,
		TabActors T_Actors,
		TabDirectors T_People,
		TabProductionCompanies T_ProductionCompanies,
		TabProductionCountries T_ProductionCountries,
		TabSpokenLanguages T_SpokenLanguages
	);
	
	TYPE T_MoviesExt IS TABLE OF MOVIES_EXT%ROWTYPE INDEX BY PLS_INTEGER;
	
	PROCEDURE AddLogs(ElemToAdd IN R_Logs);
	PROCEDURE GetMoviesExt(P_NOMBRE IN INTEGER);
	PROCEDURE Parse(P_MOVIES_EXT IN T_MoviesExt);
	FUNCTION isMovieValid(P_MOVIES_EXT IN MOVIES_EXT%ROWTYPE, P_MOVIETOADD IN OUT R_MovieToAdd) RETURN BOOLEAN;
	FUNCTION ParseMovie(P_MOVIES_EXT IN MOVIES_EXT%ROWTYPE, P_MOVIETOADD IN OUT R_MovieToAdd) RETURN BOOLEAN;
	FUNCTION ParseGenre(P_GENRES_EXT IN MOVIES_EXT.Genres%TYPE, P_GENRES IN OUT T_Genres) RETURN BOOLEAN;
	FUNCTION ParseActor(P_ACTORS_EXT IN MOVIES_EXT.Actors%TYPE, P_ACTORS IN OUT T_Actors) RETURN BOOLEAN;
	FUNCTION ParseDirector(P_DIRECTORS_EXT IN MOVIES_EXT.Directors%TYPE, P_DIRECTORS IN OUT T_People) RETURN BOOLEAN;
	FUNCTION ParseProductionCompanies(P_PRODUCTIONCOMPANIES_EXT IN MOVIES_EXT.Production_companies%TYPE, P_PRODUCTIONCOMPANIES IN OUT T_ProductionCompanies) RETURN BOOLEAN;
	FUNCTION ParseProductionCountries(P_PRODUCTIONCOUNTRIES_EXT IN MOVIES_EXT.Production_countries%TYPE, P_PRODUCTIONCOUNTRIES IN OUT T_ProductionCountries) RETURN BOOLEAN;
	FUNCTION ParseSpokenLanguages(P_SPOKENLANGUAGES_EXT IN MOVIES_EXT.Spoken_languages%TYPE, P_SPOKENLANGUAGES IN OUT T_SpokenLanguages) RETURN BOOLEAN;
	PROCEDURE AddMovie(P_MOVIETOADD IN OUT R_MovieToAdd);
	PROCEDURE UpdateMovie(P_MOVIE_ID IN MOVIES_EXT.id%TYPE, P_NOMBRECOPIES IN NUMBER);
	PROCEDURE AddGenres(P_MOVIETOADD IN OUT R_MovieToAdd);
	PROCEDURE AddActors(P_MOVIETOADD IN OUT R_MovieToAdd);
	PROCEDURE AddDirectors(P_MOVIETOADD IN OUT R_MovieToAdd);
	PROCEDURE AddProductionCompanies(P_MOVIETOADD IN OUT R_MovieToAdd);
	PROCEDURE AddProductionCountries(P_MOVIETOADD IN OUT R_MovieToAdd);
	PROCEDURE AddSpokenLanguages(P_MOVIETOADD IN OUT R_MovieToAdd);
	
	FUNCTION TrimAlimCB(P_PARAM IN VARCHAR2) RETURN VARCHAR2;
END ALIMCB;