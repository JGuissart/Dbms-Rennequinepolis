create or replace PACKAGE BODY RechFilm AS
	PROCEDURE AddLogs(ElemToAdd IN R_Logs) AS
		PRAGMA AUTONOMOUS_TRANSACTION; -- Procédure autonome niveau transactionnel
		V_Error R_Logs;
		E_ParamaterNull EXCEPTION;
		BEGIN
			IF (ElemToAdd.LogWhen IS NULL) THEN 
			RAISE E_ParamaterNull; 
			END IF;

			INSERT INTO Logs VALUES (seqLogs.NextVal, ElemToAdd.LogWhen, ElemToAdd.ErrorCode, ElemToAdd.LogWhat, ElemToAdd.LogWhere);
			COMMIT;
		EXCEPTION
			WHEN E_ParamaterNull THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := '-20001';
				V_Error.LogWhat := 'Parametre recu null';
				V_Error.LogWhere := 'RechFilm.AddLogs';
				AddLogs(V_Error);
				COMMIT;
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.AddLogs';
				AddLogs(V_Error);
				COMMIT; 
	END AddLogs;
	
	/****************************************************************************************************************************************/
	
	------------ Connexion ------------------------------------------------------------
	-- *** IN : Un Users.Login%TYPE
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : Récupère les informations du login passé en paramètre
	---------------------------------------------------------------------------------------------------------
	
	FUNCTION Connexion(P_LOGIN IN Users.Login%TYPE) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Un utilisateur tente de se connecter avec le login ' || P_LOGIN;
			V_Logs.LogWhere := 'RechFilm.Connexion';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT Password
			FROM Users
			WHERE Login = P_LOGIN;
			
			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.Connexion';
				AddLogs(V_Error);
				RETURN NULL;
	END Connexion;
	
	/****************************************************************************************************************************************/
	
	------------ GetMovie ------------------------------------------------------------
	-- *** IN : Movies.idMovie%TYPE
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : Récupère les informations du film dont l'identifiant est passé en paramètre
	---------------------------------------------------------------------------------------------------------
	
	FUNCTION GetMovie(P_IDMOVIE IN Movies.idMovie%TYPE) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Recherche d''un film via son identifiant : ' || P_IDMOVIE;
			V_Logs.LogWhere := 'RechFilm.GetMovie';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT idMovie, Title, COALESCE(Release_Date, CURRENT_DATE), Runtime, Overview, vote_average, vote_count, Poster_path
			FROM Movies INNER JOIN Posters USING(idPoster)
			WHERE idMovie = P_IDMOVIE;
			
			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.GetMovie';
				AddLogs(V_Error);
				RETURN NULL;
	END GetMovie;
	
	/****************************************************************************************************************************************/
	
	------------ GetMovies ------------------------------------------------------------
	-- *** IN : Movies.Title%TYPE, T_ARRAY_NAME, T_ARRAY_NAME, VARCHAR2, IN VARCHAR2
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : Récupère le(s) films dont les informations passées en paramètre correspondent
	---------------------------------------------------------------------------------------------------------

	FUNCTION GetMovies(P_TITLE IN Movies.Title%TYPE, P_ACTORS IN T_ARRAY_NAME, P_DIRECTORS IN T_ARRAY_NAME, P_ANNEEAVANT IN VARCHAR2, P_ANNEEAPRES IN VARCHAR2) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Recherche de films via plusieurs critères';
			V_Logs.LogWhere := 'RechFilm.GetMovies';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT idMovie, Title, COALESCE(Release_Date, CURRENT_DATE), idPoster
			FROM Movies
			WHERE P_TITLE IS NULL
			OR
			UPPER(Title) LIKE UPPER('%' || P_TITLE || '%') -- Case insensitive
			INTERSECT
			SELECT idMovie, Title, COALESCE(Release_Date, CURRENT_DATE), idPoster
			FROM Movies
			WHERE P_ACTORS IS NULL
			OR
			idMovie IN
			(
				SELECT idMovie
				FROM People INNER JOIN MovieActor USING(idPeople) 
				WHERE UPPER(Name) IN(SELECT UPPER(column_value) FROM TABLE(P_ACTORS)) -- Case insensitive
			)
			INTERSECT
			SELECT idMovie, Title, COALESCE(Release_Date, CURRENT_DATE), idPoster
			FROM Movies
			WHERE P_DIRECTORS IS NULL
			OR
			idMovie IN
			(
				SELECT idMovie
				FROM People INNER JOIN MovieDirector USING(idPeople)
				WHERE UPPER(Name) IN(SELECT UPPER(column_value) FROM TABLE(P_DIRECTORS)) -- Case insensitive
			)
			INTERSECT
			SELECT idMovie, Title, COALESCE(Release_Date, CURRENT_DATE), idPoster
			FROM Movies
			WHERE
			(
				(P_ANNEEAVANT IS NULL AND P_ANNEEAPRES IS NULL)
				OR
				(
					(P_ANNEEAVANT IS NOT NULL AND P_ANNEEAPRES IS NOT NULL)
					AND
					(
						(P_ANNEEAPRES = P_ANNEEAVANT AND EXTRACT(YEAR FROM Release_date) = P_ANNEEAVANT)
						OR
						(P_ANNEEAPRES <> P_ANNEEAVANT AND EXTRACT(YEAR FROM Release_date) BETWEEN P_ANNEEAPRES AND P_ANNEEAVANT)
					)
				)
				OR
				(
					(P_ANNEEAVANT IS NOT NULL AND P_ANNEEAPRES IS NULL)
					AND
					(EXTRACT(YEAR FROM Release_date) < P_ANNEEAVANT)
				)
				OR
				(
					(P_ANNEEAVANT IS NULL AND P_ANNEEAPRES IS NOT NULL)
					AND
					(EXTRACT(YEAR FROM Release_date) > P_ANNEEAPRES)
				)
			);
			
			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.GetMovies';
				AddLogs(V_Error);
				RETURN NULL;
	END GetMovies;
	
	/****************************************************************************************************************************************/
	
	------------ GetActorsFromMovie ------------------------------------------------------------
	-- *** IN : Movies.Title%TYPE
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : récupère les acteurs du film dont l'identifiant est passé en paramètre
	---------------------------------------------------------------------------------------------------------
	
	FUNCTION GetActorsFromMovie(P_IDMOVIE IN Movies.idMovie%TYPE) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Récupération des acteurs pour le film : ' || P_IDMOVIE;
			V_Logs.LogWhere := 'RechFilm.GetActorsFromMovie';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT idMovie, LISTAGG(Name, '; ') WITHIN GROUP(ORDER BY idMovie, Name)
			FROM People INNER JOIN MovieActor USING(idPeople) INNER JOIN Movies USING(idMovie)
			WHERE idMovie = P_IDMOVIE
			GROUP BY idMovie
			ORDER BY idMovie;
			
			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.GetActorsFromMovie';
				AddLogs(V_Error);
				RETURN NULL;
	END GetActorsFromMovie;
	
	/****************************************************************************************************************************************/
	
	------------ GetDirectorsFromMovie ------------------------------------------------------------
	-- *** IN : Movies.Title%TYPE
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : récupère les réalisateurs du film dont l'identifiant est passé en paramètre
	---------------------------------------------------------------------------------------------------------
	
	FUNCTION GetDirectorsFromMovie(P_IDMOVIE IN Movies.idMovie%TYPE) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Récupération des réalisateurs pour le film : ' || P_IDMOVIE;
			V_Logs.LogWhere := 'RechFilm.GetDirectorsFromMovie';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT idMovie, LISTAGG(Name, '; ') WITHIN GROUP(ORDER BY idMovie, Name)
			FROM People INNER JOIN MovieDirector USING(idPeople) INNER JOIN Movies USING(idMovie)
			WHERE idMovie = P_IDMOVIE
			GROUP BY idMovie
			ORDER BY idMovie;
			
			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.GetMovies';
				AddLogs(V_Error);
				RETURN NULL;
	END GetDirectorsFromMovie;
	
	/****************************************************************************************************************************************/
	
	------------ GetPoster ------------------------------------------------------------
	-- *** IN : Posters.idPoster%TYPE
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : récupère le poster dont l'identifiant est passé en paramètre
	---------------------------------------------------------------------------------------------------------
	
	FUNCTION GetPoster(P_IDPOSTER IN Posters.idPoster%TYPE) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Récupération du poster : ' || P_IDPOSTER;
			V_Logs.LogWhere := 'RechFilm.GetPoster';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT Poster_path
			FROM Posters
			WHERE idPoster = P_IDPOSTER;
			
			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.GetPoster';
				AddLogs(V_Error);
				RETURN NULL;
	END GetPoster;
	
	/****************************************************************************************************************************************/	
	
	------------ GetQuotationsOpinionsFromRQS ------------------------------------------------------------
	-- *** IN : Movies.idMovie%TYPE
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : récupère la moyenne des cotes, le nombre de cote et le nombre d'avis d'un film posté par les utilisateurs de RQS dont l'identifiant est passé en paramètre
	---------------------------------------------------------------------------------------------------------

	FUNCTION GetQuotationsOpinionsFromRQS(P_IDMOVIE IN Movies.idMovie%TYPE) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Récupération du nombres d''avis et de la moyenne des cotes des utilisateurs de RQS pour le film : ' || P_IDMOVIE;
			V_Logs.LogWhere := 'RechFilm.GetQuotationsOpinionsFromRQS';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT ROUND(COALESCE(AVG(Quotation), 0), 2), COUNT(Quotation), COUNT(*)
			FROM QuotationsOpinions
			WHERE idMovie = P_IDMOVIE;

			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.GetQuotationsOpinionsFromRQS';
				AddLogs(V_Error);
				RETURN NULL;
	END GetQuotationsOpinionsFromRQS;
	
	/****************************************************************************************************************************************/	
	
	------------ GetQuotationsOpinionsFromRQS ------------------------------------------------------------
	-- *** IN : Movies.idMovie%TYPE, INTEGER
	-- *** OUT : SYS_REFCURSOR
	-- *** PROCESS : récupère les avis d'un film posté par les utilisateurs de RQS 5 par 5 dont l'identifiant est passé en paramètre
	---------------------------------------------------------------------------------------------------------
  
	FUNCTION GetQuotationsOpinionsFromRQS(P_IDMOVIE IN Movies.idMovie%TYPE, P_PAGE IN INTEGER) RETURN SYS_REFCURSOR AS
		V_RefCursor SYS_REFCURSOR;
		V_Error R_Logs;
		V_Logs R_Logs;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Récupération des avis et des cotes des utilisateurs de RQS pour le film : ' || P_IDMOVIE;
			V_Logs.LogWhere := 'RechFilm.GetQuotationsOpinionsFromRQS';
			AddLogs(V_Logs);
			OPEN V_RefCursor FOR SELECT login, quotation, opinion, dateOfPost
			FROM
			(
				SELECT QuotationsOpinions.*, ROW_NUMBER() OVER (ORDER BY 1) R
				FROM QuotationsOpinions
				WHERE IdMovie = P_IDMOVIE
			)
			WHERE R BETWEEN (5 * P_PAGE) + 1 AND ((5 * P_PAGE) + 5);

			RETURN V_RefCursor;
		EXCEPTION
			WHEN OTHERS THEN
				IF(V_RefCursor%ISOPEN) THEN
					CLOSE V_RefCursor;
				END IF;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RechFilm.GetQuotationsOpinionsFromRQS';
				AddLogs(V_Error);
				RETURN NULL;
	END GetQuotationsOpinionsFromRQS;
END RechFilm;