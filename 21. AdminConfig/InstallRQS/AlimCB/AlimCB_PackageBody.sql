create or replace PACKAGE BODY AlimCB AS
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
				V_Error.LogWhere := 'AlimCB.AddLogs';
				AddLogs(V_Error);
				COMMIT;
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'AlimCB.AddLogs';
				AddLogs(V_Error);
				COMMIT; 
	END AddLogs;
	
	PROCEDURE GetMoviesExt(P_NOMBRE IN INTEGER) AS
		V_TabMoviesExt T_MoviesExt;
		E_TabVide EXCEPTION;
		V_Error Logs%ROWTYPE;
		BEGIN
			SELECT * BULK COLLECT INTO V_TabMoviesExt
			FROM
			(
				SELECT *
				FROM MOVIES_EXT
				ORDER BY DBMS_RANDOM.VALUE
			)
			WHERE ROWNUM BETWEEN 1 AND P_NOMBRE;
			
			IF(V_TabMoviesExt.COUNT = 0) THEN
				RAISE E_TabVide;
			END IF;
			Parse(V_TabMoviesExt);
		EXCEPTION
			WHEN OTHERS THEN --DBMS_OUTPUT.PUT_LINE('GetMoviesExt => ' || SQLERRM);
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'AlimCB.GetMoviesExt';
				AddLogs(V_Error);
	END GetMoviesExt;
	
	PROCEDURE Parse(P_MOVIES_EXT IN T_MoviesExt) AS
		V_Verif Movies%ROWTYPE;
		V_NombreCopies NUMBER := 0;
		V_Error Logs%ROWTYPE;
		BEGIN
			FOR i IN P_MOVIES_EXT.FIRST .. P_MOVIES_EXT.LAST LOOP
				DECLARE
					V_AlreadyIn BOOLEAN := TRUE;
					MovieToAdd R_MovieToAdd;
					V_Logs Logs%ROWTYPE;
				BEGIN
					V_Logs.LogWhen := CURRENT_DATE;
					V_Logs.ErrorCode := NULL;
					V_Logs.LogWhat := 'Debut Parse pour le film idMovie = ' || P_MOVIES_EXT(i).id;
					V_Logs.LogWhere := 'AlimCB.Parse';
					AddLogs(V_Logs);
					
					-- Bloc PL/SQL vérifiant si un film est déjà dans la base de données ou pas => Permet de seulement mettre à jour le nombre de copies sans parser le tuple
					-- Au final, pas terrible ce bloc, mais aucune raison valable ...
					
					BEGIN
						SELECT * INTO V_Verif
						FROM Movies
						WHERE idMovie = P_MOVIES_EXT(i).id;
						V_NombreCopies := V_Verif.NombreCopies;
					EXCEPTION
						WHEN NO_DATA_FOUND THEN 
							V_AlreadyIn := FALSE;
						WHEN OTHERS THEN RAISE;
					END;
					
					IF(V_AlreadyIn = FALSE) THEN
						IF(isMovieValid(P_MOVIES_EXT(i), MovieToAdd) = TRUE) THEN
							AddMovie(MovieToAdd);
						END IF;
					ELSE
						UpdateMovie(P_MOVIES_EXT(i).id, V_NombreCopies);
					END IF;
					DBMS_OUTPUT.PUT_LINE('On va faire un MovieCopy');
					AlimCC.MovieCopy(P_MOVIES_EXT(i).id); -- AJOUT D'ALIMCC ICI
					V_Logs.LogWhen := CURRENT_DATE;
					V_Logs.ErrorCode := NULL;
					V_Logs.LogWhat := 'Fin Parse pour le film idMovie = ' || P_MOVIES_EXT(i).id;
					V_Logs.LogWhere := 'AlimCB.Parse';
					AddLogs(V_Logs);
				EXCEPTION
					WHEN OTHERS THEN
						DBMS_OUTPUT.PUT_LINE('Parse 2e bloc imbriqué => ' || SQLERRM);
						ROLLBACK;
						V_Error.LogWhen := CURRENT_DATE;
						V_Error.ErrorCode := SQLCODE;
						V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
						V_Error.LogWhere := 'AlimCB.Parse 2e bloc imbriqué';
						AddLogs(V_Error);
				END;
				COMMIT;
			END LOOP;
			Reception@CC; -- Avertir CC de vérifier les tables temporaires
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Parse => ' || SQLERRM);
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'AlimCB.Parse';
				AddLogs(V_Error);
	END Parse;
	
	FUNCTION isMovieValid(P_MOVIES_EXT IN MOVIES_EXT%ROWTYPE, P_MOVIETOADD IN OUT R_MovieToAdd) RETURN BOOLEAN AS
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut isMovieValid pour le film idMovie = ' || P_MOVIES_EXT.id;
			V_Logs.LogWhere := 'AlimCB.isMovieValid';
			AddLogs(V_Logs);
			IF(ParseMovie(P_MOVIES_EXT, P_MOVIETOADD) = TRUE) THEN
				IF(ParseGenre(P_MOVIES_EXT.Genres, P_MOVIETOADD.TabGenres) = TRUE) THEN
					IF(ParseActor(P_MOVIES_EXT.Actors, P_MOVIETOADD.TabActors) = TRUE) THEN
						IF(ParseDirector(P_MOVIES_EXT.Directors, P_MOVIETOADD.TabDirectors) = TRUE) THEN
							IF(ParseProductionCompanies(P_MOVIES_EXT.production_companies, P_MOVIETOADD.TabProductionCompanies) = TRUE) THEN
								IF(ParseProductionCountries(P_MOVIES_EXT.production_countries, P_MOVIETOADD.TabProductionCountries) = TRUE) THEN
									IF(ParseSpokenLanguages(P_MOVIES_EXT.spoken_languages, P_MOVIETOADD.TabSpokenLanguages) = TRUE) THEN
										RETURN TRUE;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin isMovieValid pour le film idMovie = ' || P_MOVIES_EXT.id;
			V_Logs.LogWhere := 'AlimCB.isMovieValid';
			AddLogs(V_Logs);
			RETURN FALSE;
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('isMovieValid => ' || SQLERRM);
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'AlimCB.isMovieValid';
				AddLogs(V_Error);
	END isMovieValid;
	
	FUNCTION ParseMovie(P_MOVIES_EXT IN MOVIES_EXT%ROWTYPE, P_MOVIETOADD IN OUT R_MovieToAdd) RETURN BOOLEAN AS
		E_BadValue EXCEPTION;
		V_Error Logs%ROWTYPE;
		V_Logs Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut parseMovie pour le film idMovie = ' || P_MOVIES_EXT.id;
			V_Logs.LogWhere := 'AlimCB.ParseMovie';
			AddLogs(V_Logs);
			IF(LENGTH(TrimAlimCB(P_MOVIES_EXT.title)) > 112) THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := NULL;
				V_Error.LogWhat := '[' || P_MOVIES_EXT.id || '] => title ' || P_MOVIES_EXT.title || ' trop grand';
				V_Error.LogWhere := 'AlimCB.ParseMovie';
				AddLogs(V_Error);
				RAISE E_BadValue;
			ELSIF(LENGTH(TrimAlimCB(P_MOVIES_EXT.original_title)) > 113) THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := NULL;
				V_Error.LogWhat := '[' || P_MOVIES_EXT.id ||'] => original_title ' || P_MOVIES_EXT.original_title || ' trop grand';
				V_Error.LogWhere := 'AlimCB.ParseMovie';
				AddLogs(V_Error);
				RAISE E_BadValue;
			ELSIF(P_MOVIES_EXT.runtime IS NULL OR P_MOVIES_EXT.runtime <= 0) THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := NULL;
				IF(P_MOVIES_EXT.runtime IS NULL) THEN
					V_Error.LogWhat := '[' || P_MOVIES_EXT.id ||'] => runtime NULL';
				ELSIF(P_MOVIES_EXT.runtime <= 0) THEN
					V_Error.LogWhat := '[' || P_MOVIES_EXT.id ||'] => runtime = ' || P_MOVIES_EXT.runtime;
				END IF;
				V_Error.LogWhere := 'AlimCB.ParseMovie';
				AddLogs(V_Error);
				RAISE E_BadValue;
			ELSIF(LENGTH(TrimAlimCB(P_MOVIES_EXT.tagline)) > 872) THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := NULL;
				V_Error.LogWhat := '[' || P_MOVIES_EXT.id ||'] => tagline ' || P_MOVIES_EXT.tagline || ' trop grand';
				V_Error.LogWhere := 'AlimCB.ParseMovie';
				AddLogs(V_Error);
				RAISE E_BadValue;
			ELSIF(LENGTH(TrimAlimCB(P_MOVIES_EXT.overview)) > 1000) THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := NULL;
				V_Error.LogWhat := '[' || P_MOVIES_EXT.id ||'] => overview ' || P_MOVIES_EXT.overview || ' trop grand';
				V_Error.LogWhere := 'AlimCB.ParseMovie';
				AddLogs(V_Error);
				RAISE E_BadValue;
			ELSE
				IF(LENGTH(TrimAlimCB(P_MOVIES_EXT.title)) > 58) THEN
					P_MOVIETOADD.Title := SUBSTR(TrimAlimCB(P_MOVIES_EXT.title), 0, 58);
					V_Logs.LogWhen := CURRENT_DATE;
					V_Logs.ErrorCode := NULL;
					V_Logs.LogWhat := '[Title][Troncage]['|| LENGTH(TrimAlimCB(P_MOVIES_EXT.title)) ||'][' || LENGTH(P_MOVIETOADD.Title) || ']';
					V_Logs.LogWhere := 'AlimCB.ParseMovie';
					AddLogs(V_Logs);
				ELSE
					P_MOVIETOADD.Title := TrimAlimCB(P_MOVIES_EXT.title);
				END IF;
				
				IF(LENGTH(TrimAlimCB(P_MOVIES_EXT.original_title)) > 59) THEN
					P_MOVIETOADD.Original_title := SUBSTR(TrimAlimCB(P_MOVIES_EXT.Original_title), 0, 59);
					V_Logs.LogWhen := CURRENT_DATE;
					V_Logs.ErrorCode := NULL;
					V_Logs.LogWhat := '[Original_title][Troncage]['|| LENGTH(TrimAlimCB(P_MOVIES_EXT.original_title)) ||'][' || LENGTH(P_MOVIETOADD.original_title) || ']';
					V_Logs.LogWhere := 'AlimCB.ParseMovie';
					AddLogs(V_Logs);
				ELSE
					P_MOVIETOADD.Original_title := TrimAlimCB(P_MOVIES_EXT.Original_title);
				END IF;
				
				IF(LENGTH(TrimAlimCB(P_MOVIES_EXT.homepage)) > 122) THEN
					P_MOVIETOADD.Homepage := NULL;
					V_Logs.LogWhen := CURRENT_DATE;
					V_Logs.ErrorCode := NULL;
					V_Logs.LogWhat := '[Homepage][NULL]['|| LENGTH(TrimAlimCB(P_MOVIES_EXT.homepage)) ||']';
					V_Logs.LogWhere := 'AlimCB.ParseMovie';
					AddLogs(V_Logs);
				ELSE
					P_MOVIETOADD.Homepage := TrimAlimCB(P_MOVIES_EXT.homepage);
				END IF;
				
				IF(LENGTH(TrimAlimCB(P_MOVIES_EXT.tagline)) > 172) THEN
					P_MOVIETOADD.Tagline := SUBSTR(TrimAlimCB(P_MOVIES_EXT.tagline), 0, 172);
					V_Logs.LogWhen := CURRENT_DATE;
					V_Logs.ErrorCode := NULL;
					V_Logs.LogWhat := '[Tagline][Troncage]['|| LENGTH(TrimAlimCB(P_MOVIES_EXT.tagline)) ||'][' || LENGTH(P_MOVIETOADD.tagline) || ']';
					V_Logs.LogWhere := 'AlimCB.ParseMovie';
					AddLogs(V_Logs);
				ELSE
					P_MOVIETOADD.Tagline := TrimAlimCB(P_MOVIES_EXT.tagline);
				END IF;
				
				IF(LENGTH(TrimAlimCB(P_MOVIES_EXT.overview)) > 949) THEN
					P_MOVIETOADD.Overview := SUBSTR(TrimAlimCB(P_MOVIES_EXT.overview), 0, 949);
					V_Logs.LogWhen := CURRENT_DATE;
					V_Logs.ErrorCode := NULL; 
					V_Logs.LogWhat := '[Overview][Troncage]['|| LENGTH(TrimAlimCB(P_MOVIES_EXT.overview)) ||'][' || LENGTH(P_MOVIETOADD.overview) || ']';
					V_Logs.LogWhere := 'AlimCB.ParseMovie';
					AddLogs(V_Logs);
				ELSE
					P_MOVIETOADD.Overview := TrimAlimCB(P_MOVIES_EXT.overview);
				END IF;
				
				P_MOVIETOADD.idMovie := P_MOVIES_EXT.id;
				P_MOVIETOADD.Release_Date := P_MOVIES_EXT.Release_date;
				P_MOVIETOADD.Status := TrimAlimCB(P_MOVIES_EXT.Status);
				P_MOVIETOADD.Vote_Average := P_MOVIES_EXT.Vote_Average;
				P_MOVIETOADD.Vote_count := P_MOVIES_EXT.Vote_count;
				P_MOVIETOADD.Runtime := P_MOVIES_EXT.Runtime;
				P_MOVIETOADD.Certification := TrimAlimCB(P_MOVIES_EXT.Certification);
				P_MOVIETOADD.Budget := P_MOVIES_EXT.Budget;
				P_MOVIETOADD.Revenue := P_MOVIES_EXT.Revenue;
				P_MOVIETOADD.nombreCopies := 0;
				WHILE(P_MOVIETOADD.nombreCopies <= 0) LOOP
					P_MOVIETOADD.nombreCopies := ROUND(DBMS_RANDOM.NORMAL * 2 + 5);
				END LOOP;
				P_MOVIETOADD.idPoster := NULL;
				
				IF(P_MOVIES_EXT.poster_path IS NOT NULL) THEN
					P_MOVIETOADD.idPoster := SeqIdPoster.NEXTVAL;
					P_MOVIETOADD.poster_pathMovie := httpuritype('http://image.tmdb.org/t/p/w185' || P_MOVIES_EXT.poster_path).getblob();
				ELSE
					P_MOVIETOADD.idPoster := -1;
				END IF;
			END IF;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin parseMovie pour le film idMovie = ' || P_MOVIES_EXT.id;
			V_Logs.LogWhere := 'AlimCB.ParseMovie';
			AddLogs(V_Logs);
			RETURN TRUE;
		EXCEPTION
			WHEN E_BadValue THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := NULL;
				V_Error.LogWhat := 'Fin parseMovie pour le film idMovie = ' || P_MOVIES_EXT.id;
				V_Error.LogWhere := 'AlimCB.ParseMovie';
				AddLogs(V_Error);
				RETURN FALSE;
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('ParseMovie => ' || SQLERRM);
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'AlimCB.ParseMovie';
				AddLogs(V_Error);
				RETURN FALSE;
	END ParseMovie;
	
	FUNCTION ParseGenre(P_GENRES_EXT IN MOVIES_EXT.Genres%TYPE, P_GENRES IN OUT T_Genres) RETURN BOOLEAN AS
		V_GenresWithoutBrackets VARCHAR2(3996);
		V_Genre VARCHAR2(25);
		i INTEGER := 1;
		V_IndiceTableau INTEGER := 1;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut ParseGenre';
			V_Logs.LogWhere := 'AlimCB.ParseGenre';
			AddLogs(V_Logs);
			V_GenresWithoutBrackets := REGEXP_SUBSTR(P_GENRES_EXT, '^\[\[(.*)\]\]$', 1, 1, '', 1);
			IF(V_GenresWithoutBrackets IS NOT NULL) THEN
				LOOP
					V_Genre := REGEXP_SUBSTR(V_GenresWithoutBrackets, '(.*?)(\|\||$)', 1, i, '', 1);

					EXIT WHEN V_Genre IS NULL;
					P_GENRES(V_IndiceTableau).idGenre := TrimAlimCB(REGEXP_SUBSTR(V_Genre, '^(.*),{2,}(.*)$', 1, 1, '', 1));
					P_GENRES(V_IndiceTableau).Name := TrimAlimCB(REGEXP_SUBSTR(V_Genre, '^(.*),{2,}(.*)$', 1, 1, '', 2));
					i := i + 1;
					V_IndiceTableau := V_IndiceTableau + 1;
				END LOOP;
			END IF;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin ParseGenre';
			V_Logs.LogWhere := 'AlimCB.ParseGenre';
			AddLogs(V_Logs);
			RETURN TRUE;
		EXCEPTION
			WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('ParseGenre => ' || SQLERRM);
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.ParseGenre';
			AddLogs(V_Error);
			RETURN FALSE;
	END ParseGenre;
	
	FUNCTION ParseActor(P_ACTORS_EXT IN MOVIES_EXT.Actors%TYPE, P_ACTORS IN OUT T_Actors) RETURN BOOLEAN AS
		V_ActorsWithoutBrackets VARCHAR2(3996);
		V_Actor VARCHAR2(425);
		V_Name VARCHAR2(50);
		V_CharacterName VARCHAR2(50);
		i INTEGER := 1;
		V_IndiceTableau INTEGER := 1;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut ParseActor';
			V_Logs.LogWhere := 'AlimCB.ParseActor';
			AddLogs(V_Logs);
			
			V_ActorsWithoutBrackets := REGEXP_SUBSTR(P_ACTORS_EXT, '^\[\[(.*)\]\]$', 1, 1, '', 1);
			IF(V_ActorsWithoutBrackets IS NOT NULL) THEN
				LOOP
					V_Actor := REGEXP_SUBSTR(V_ActorsWithoutBrackets, '(.*?)(\|\||$)', 1, i, '', 1);

					EXIT WHEN V_Actor IS NULL;
					P_ACTORS(V_IndiceTableau).idPeople := TrimAlimCB(REGEXP_SUBSTR(V_Actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 1));
					V_Name := TrimAlimCB(REGEXP_SUBSTR(V_Actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 2));
					IF(LENGTH(V_Name) > 35) THEN
						P_ACTORS(V_IndiceTableau).Name := NULL;
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name][NULL]['|| LENGTH(V_Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseActor';
						AddLogs(V_Logs);
					ELSIF(LENGTH(V_Name) > 22) THEN
						P_ACTORS(V_IndiceTableau).Name := SUBSTR(V_Name, 0, 22);
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name]['|| LENGTH(V_Name) ||']['|| LENGTH(P_ACTORS(V_IndiceTableau).Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseActor';
						AddLogs(V_Logs);
					ELSE
						P_ACTORS(V_IndiceTableau).Name := V_Name;
					END IF;
					
					P_ACTORS(V_IndiceTableau).CastId := TrimAlimCB(REGEXP_SUBSTR(V_Actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 3));
					V_CharacterName := REGEXP_SUBSTR(V_Actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 4);
					IF(V_CharacterName IS NULL) THEN
						P_ACTORS(V_IndiceTableau).CharacterName := NULL;
					ELSE
						V_CharacterName := TrimAlimCB(V_CharacterName);
						IF(LENGTH(V_CharacterName) > 134) THEN
							P_ACTORS(V_IndiceTableau).CharacterName := NULL;
							V_Logs.LogWhen := CURRENT_DATE;
							V_Logs.ErrorCode := NULL;
							V_Logs.LogWhat := '[CharacterName][NULL]['|| LENGTH(V_Name) ||']';
							V_Logs.LogWhere := 'AlimCB.ParseActor';
							AddLogs(V_Logs);
						ELSIF(LENGTH(V_CharacterName) > 36) THEN
							P_ACTORS(V_IndiceTableau).CharacterName := SUBSTR(V_CharacterName, 0, 36);
							V_Logs.LogWhen := CURRENT_DATE;
							V_Logs.ErrorCode := NULL;
							V_Logs.LogWhat := '[CharacterName]['|| LENGTH(V_Name) ||']['|| LENGTH(P_ACTORS(V_IndiceTableau).CharacterName) ||']';
							V_Logs.LogWhere := 'AlimCB.ParseActor';
							AddLogs(V_Logs);
						ELSE
							P_ACTORS(V_IndiceTableau).CharacterName := V_CharacterName;
						END IF;
					END IF;
					
					IF(REGEXP_SUBSTR(V_Actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 5) IS NOT NULL) THEN
						P_ACTORS(V_IndiceTableau).idPoster := SeqIdPoster.NEXTVAL;
						P_ACTORS(V_IndiceTableau).poster_path := httpuritype('http://image.tmdb.org/t/p/w185' || REGEXP_SUBSTR(V_Actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 5)).getblob();
					END IF;
					i := i + 1;
					V_IndiceTableau := V_IndiceTableau + 1;
				END LOOP;
			END IF;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin ParseActor';
			V_Logs.LogWhere := 'AlimCB.ParseActor';
			AddLogs(V_Logs);
			RETURN TRUE;
		EXCEPTION
			WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('ParseActor => ' || SQLERRM);
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.ParseActor';
			AddLogs(V_Error);
			RETURN FALSE;
	END ParseActor;
	
	FUNCTION ParseDirector(P_DIRECTORS_EXT IN MOVIES_EXT.Directors%TYPE, P_DIRECTORS IN OUT T_People) RETURN BOOLEAN AS
		V_DirectorsWithoutBrackets VARCHAR2(3996);
		V_Director VARCHAR2(90);
		V_Name VARCHAR2(35);
		i INTEGER := 1;
		V_IndiceTableau INTEGER := 1;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut ParseDirector';
			V_Logs.LogWhere := 'AlimCB.ParseDirector';
			AddLogs(V_Logs);
			
			V_DirectorsWithoutBrackets := REGEXP_SUBSTR(P_DIRECTORS_EXT, '^\[\[(.*)\]\]$', 1, 1, '', 1);
			IF(V_DirectorsWithoutBrackets IS NOT NULL) THEN
				LOOP
					V_Director := REGEXP_SUBSTR(V_DirectorsWithoutBrackets, '(.*?)(\|\||$)', 1, i, '', 1);

					EXIT WHEN V_Director IS NULL;
					P_DIRECTORS(V_IndiceTableau).idPeople := REGEXP_SUBSTR(V_Director, '^(.*),{2,}(.*),{2,}(.*)$', 1,1,'',1);
					DBMS_OUTPUT.PUT_LINE('Valeur de idPeople = ' || P_DIRECTORS(V_IndiceTableau).idPeople);
					V_Name := TrimAlimCB(REGEXP_SUBSTR(V_Director, '^(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 2));
					IF(LENGTH(V_Name) > 34) THEN
						P_DIRECTORS(V_IndiceTableau).Name := NULL;
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name][NULL]['|| LENGTH(V_Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseDirector';
						AddLogs(V_Logs);
					ELSIF(LENGTH(V_Name) > 22) THEN
						P_DIRECTORS(V_IndiceTableau).Name := SUBSTR(V_Name, 0, 22);
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name]['|| LENGTH(V_Name) ||']['|| LENGTH(P_DIRECTORS(V_IndiceTableau).Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseDirector';
						AddLogs(V_Logs);
					ELSE
						P_DIRECTORS(V_IndiceTableau).Name := V_Name;
					END IF;
					IF(REGEXP_SUBSTR(V_Director, '^(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 3) IS NOT NULL) THEN
						P_DIRECTORS(V_IndiceTableau).idPoster := SeqIdPoster.NEXTVAL;
						P_DIRECTORS(V_IndiceTableau).poster_path := httpuritype('http://image.tmdb.org/t/p/w185' || REGEXP_SUBSTR(V_Director, '^(.*),{2,}(.*),{2,}(.*)$', 1, 1, '', 3)).getblob();
					END IF;
					i := i + 1;
					V_IndiceTableau := V_IndiceTableau + 1;
				END LOOP;
			END IF;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin ParseDirector';
			V_Logs.LogWhere := 'AlimCB.ParseDirector';
			AddLogs(V_Logs);
			RETURN TRUE;
		EXCEPTION
			WHEN OTHERS THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.ParseDirector';
			AddLogs(V_Error);
			RETURN FALSE;
	END ParseDirector;
	
	FUNCTION ParseProductionCompanies(P_PRODUCTIONCOMPANIES_EXT IN MOVIES_EXT.Production_companies%TYPE, P_PRODUCTIONCOMPANIES IN OUT T_ProductionCompanies) RETURN BOOLEAN AS
		V_ProducCompWithoutBrackets VARCHAR2(3996);
		V_ProductionCompanies VARCHAR2(140);
		V_Name VARCHAR2(128);
		i INTEGER := 1;
		V_IndiceTableau INTEGER := 1;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut ParseProductionCompanies';
			V_Logs.LogWhere := 'AlimCB.ParseProductionCompanies';
			AddLogs(V_Logs);
			
			V_ProducCompWithoutBrackets := REGEXP_SUBSTR(P_PRODUCTIONCOMPANIES_EXT, '^\[\[(.*)\]\]$', 1, 1, '', 1);
			IF(V_ProducCompWithoutBrackets IS NOT NULL) THEN
				LOOP
					V_ProductionCompanies := REGEXP_SUBSTR(V_ProducCompWithoutBrackets, '(.*?)(\|\||$)', 1, i, '', 1);

					EXIT WHEN V_ProductionCompanies IS NULL;
					P_PRODUCTIONCOMPANIES(V_IndiceTableau).idProductionCompany := REGEXP_SUBSTR(V_ProductionCompanies, '^(.*),{2,}(.*)$', 1,1,'',1);
					V_Name := TrimAlimCB(REGEXP_SUBSTR(V_ProductionCompanies, '^(.*),{2,}(.*)$', 1,1,'',2));
					IF(LENGTH(V_Name) > 84) THEN
						P_PRODUCTIONCOMPANIES(V_IndiceTableau).idProductionCompany := NULL;
						P_PRODUCTIONCOMPANIES(V_IndiceTableau).Name := NULL;
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name][NULL]['|| LENGTH(V_Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseProductionCompanies';
						AddLogs(V_Logs);
						-- On ne l'inserera pas
					ELSIF(LENGTH(V_Name) > 44) THEN
						P_PRODUCTIONCOMPANIES(V_IndiceTableau).Name := SUBSTR(V_Name, 0, 44);
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name]['|| LENGTH(V_Name) ||']['|| LENGTH(P_PRODUCTIONCOMPANIES(V_IndiceTableau).Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseProductionCompanies';
						AddLogs(V_Logs);
					ELSE
						P_PRODUCTIONCOMPANIES(V_IndiceTableau).Name := V_Name;
					END IF;
					i := i + 1;
					V_IndiceTableau := V_IndiceTableau + 1;
				END LOOP;
			END IF;
			
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin ParseProductionCompanies';
			V_Logs.LogWhere := 'AlimCB.ParseProductionCompanies';
			AddLogs(V_Logs);
			RETURN TRUE;
		EXCEPTION
			WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('ParseProductionCompanies => ' || SQLERRM);
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.ParseProductionCompanies';
			AddLogs(V_Error);
			RETURN FALSE;
	END ParseProductionCompanies;
	
	FUNCTION ParseProductionCountries(P_PRODUCTIONCOUNTRIES_EXT IN MOVIES_EXT.Production_countries%TYPE, P_PRODUCTIONCOUNTRIES IN OUT T_ProductionCountries) RETURN BOOLEAN AS
		V_ProducCountWithoutBrackets VARCHAR2(3996);
		V_ProductionCountries VARCHAR2(50);
		V_Name VARCHAR2(50);
		i INTEGER := 1;
		V_IndiceTableau INTEGER := 1;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut ParseProductionCountries';
			V_Logs.LogWhere := 'AlimCB.ParseProductionCountries';
			AddLogs(V_Logs);
			
			V_ProducCountWithoutBrackets := REGEXP_SUBSTR(P_PRODUCTIONCOUNTRIES_EXT, '^\[\[(.*)\]\]$', 1, 1, '', 1);
			IF(V_ProducCountWithoutBrackets IS NOT NULL) THEN
				LOOP
					V_ProductionCountries := REGEXP_SUBSTR(V_ProducCountWithoutBrackets, '(.*?)(\|\||$)', 1, i, '', 1);

					EXIT WHEN V_ProductionCountries IS NULL;
					P_PRODUCTIONCOUNTRIES(V_IndiceTableau).ISOProductionCountry := REGEXP_SUBSTR(V_ProductionCountries, '^(.*),{2,}(.*)$', 1,1,'',1);
					V_Name := TrimAlimCB(REGEXP_SUBSTR(V_ProductionCountries, '^(.*),{2,}(.*)$', 1,1,'',2));
					
					IF(LENGTH(V_Name) > 38) THEN
						P_PRODUCTIONCOUNTRIES(V_IndiceTableau).Name := NULL;
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name][NULL]['|| LENGTH(V_Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseProductionCountries';
						AddLogs(V_Logs);
					ELSIF(LENGTH(V_Name) > 24) THEN
						P_PRODUCTIONCOUNTRIES(V_IndiceTableau).Name := SUBSTR(V_Name, 0, 24);
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name]['|| LENGTH(V_Name) ||']['|| LENGTH(P_PRODUCTIONCOUNTRIES(V_IndiceTableau).Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseProductionCountries';
						AddLogs(V_Logs);
					ELSE
						P_PRODUCTIONCOUNTRIES(V_IndiceTableau).Name := V_Name;
					END IF;
					i := i + 1;
					V_IndiceTableau := V_IndiceTableau + 1;
				END LOOP;
			END IF;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin ParseProductionCountries';
			V_Logs.LogWhere := 'AlimCB.ParseProductionCountries';
			AddLogs(V_Logs);
			RETURN TRUE;
		EXCEPTION
			WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('ParseProductionCountries => ' || SQLERRM);
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.ParseProductionCountries';
			AddLogs(V_Error);
			RETURN FALSE;
	END ParseProductionCountries;
	
	FUNCTION ParseSpokenLanguages(P_SPOKENLANGUAGES_EXT IN MOVIES_EXT.Spoken_languages%TYPE, P_SPOKENLANGUAGES IN OUT T_SpokenLanguages) RETURN BOOLEAN AS
		V_SpokenLangWithoutBrackets VARCHAR2(3996);
		V_SpokenLanguages VARCHAR2(50);
		V_Name VARCHAR2(50);
		i INTEGER := 1;
		V_IndiceTableau INTEGER := 1;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut ParseSpokenLanguages';
			V_Logs.LogWhere := 'AlimCB.ParseSpokenLanguages';
			AddLogs(V_Logs);
			
			V_SpokenLangWithoutBrackets := REGEXP_SUBSTR(P_SPOKENLANGUAGES_EXT, '^\[\[(.*)\]\]$', 1, 1, '', 1);
			IF(V_SpokenLangWithoutBrackets IS NOT NULL) THEN
				LOOP
					V_SpokenLanguages := REGEXP_SUBSTR(V_SpokenLangWithoutBrackets, '(.*?)(\|\||$)', 1, i, '', 1);

					EXIT WHEN V_SpokenLanguages IS NULL;
					P_SPOKENLANGUAGES(V_IndiceTableau).ISOSpokenLanguage := REGEXP_SUBSTR(V_SpokenLanguages, '^(.*),{2,}(.*)$', 1,1,'',1);
					V_Name := TrimAlimCB(REGEXP_SUBSTR(V_SpokenLanguages, '^(.*),{2,}(.*)$', 1,1,'',2));
					IF(LENGTH(V_Name) > 16) THEN
						P_SPOKENLANGUAGES(V_IndiceTableau).Name := NULL;
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name][NULL]['|| LENGTH(V_Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseSpokenLanguages';
						AddLogs(V_Logs);
					ELSIF(LENGTH(V_Name) > 11) THEN
						P_SPOKENLANGUAGES(V_IndiceTableau).Name := SUBSTR(V_Name, 0, 11);
						V_Logs.LogWhen := CURRENT_DATE;
						V_Logs.ErrorCode := NULL;
						V_Logs.LogWhat := '[Name]['|| LENGTH(V_Name) ||']['|| LENGTH(P_SPOKENLANGUAGES(V_IndiceTableau).Name) ||']';
						V_Logs.LogWhere := 'AlimCB.ParseSpokenLanguages';
						AddLogs(V_Logs);
					ELSE
						P_SPOKENLANGUAGES(V_IndiceTableau).Name := V_Name;
					END IF;
					i := i + 1;
					V_IndiceTableau := V_IndiceTableau + 1;
				END LOOP;
			END IF;
			
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin ParseSpokenLanguages';
			V_Logs.LogWhere := 'AlimCB.ParseSpokenLanguages';
			AddLogs(V_Logs);
			RETURN TRUE;
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('ParseSpokenLanguages =>' || SQLERRM);
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.ParseSpokenLanguages';
			AddLogs(V_Error);
			RETURN FALSE;
	END ParseSpokenLanguages;
	
	PROCEDURE AddMovie(P_MOVIETOADD IN OUT R_MovieToAdd) AS
		V_Movies Movies%ROWTYPE;
		i INTEGER := 0;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Debut AddMovie pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddMovie';
			AddLogs(V_Logs);

			DBMS_OUTPUT.PUT_LINE('Avant insert movies');
			INSERT INTO Movies VALUES (P_MOVIETOADD.idMovie, P_MOVIETOADD.title, P_MOVIETOADD.original_title, P_MOVIETOADD.release_date, P_MOVIETOADD.status, P_MOVIETOADD.vote_average, P_MOVIETOADD.vote_count, P_MOVIETOADD.runtime, P_MOVIETOADD.certification, P_MOVIETOADD.budget, P_MOVIETOADD.revenue, P_MOVIETOADD.homepage, P_MOVIETOADD.tagline, P_MOVIETOADD.overview, P_MOVIETOADD.nombreCopies, NULL, NULL);
			DBMS_OUTPUT.PUT_LINE('Après insert movies');
			WHILE(i < P_MOVIETOADD.nombreCopies) LOOP
				INSERT INTO Copies VALUES(SeqNumCopy.NEXTVAL, P_MOVIETOADD.idMovie, NULL);
				i := i + 1;
			END LOOP;
			
			
			DBMS_OUTPUT.PUT_LINE('Avant insert poster');	
			IF(P_MOVIETOADD.idPoster IS NOT NULL) THEN
				DBMS_OUTPUT.PUT_LINE('Dans insert poster');
				INSERT INTO Posters VALUES(P_MOVIETOADD.idPoster, P_MOVIETOADD.poster_pathMovie);
				UPDATE Movies
				SET idPoster = P_MOVIETOADD.idPoster
				WHERE idMovie = P_MOVIETOADD.idMovie;
			END IF;
			DBMS_OUTPUT.PUT_LINE('Après insert poster');
			AddGenres(P_MOVIETOADD);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'FIN AddMovie: le film idMovie = ' || P_MOVIETOADD.idMovie || ' a été inséré.';
			V_Logs.LogWhere := 'AlimCB.AddMovie';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AddMovie => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.AddMovie';
			AddLogs(V_Error);
	END AddMovie;
	
	PROCEDURE UpdateMovie(P_MOVIE_ID IN MOVIES_EXT.id%TYPE, P_NOMBRECOPIES IN NUMBER) AS
		V_NombreCopies NUMBER := 0;
		V_NewNombre NUMBER := 0;
		i INTEGER := 0;
		V_NumCopy NUMBER;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Début UpdateMovie pour le film idMovie = ' || P_MOVIE_ID;
			V_Logs.LogWhere := 'AlimCB.UpdateMovie';
			AddLogs(V_Logs);
			WHILE(V_NombreCopies <= 0) LOOP
				V_NombreCopies := ROUND(DBMS_RANDOM.NORMAL * 2 + 5);
			END LOOP;
			UPDATE Movies
			SET NombreCopies = NombreCopies + V_NombreCopies
			WHERE idMovie = P_MOVIE_ID;
			WHILE(i < V_NombreCopies) LOOP
				INSERT INTO Copies(NumCopy, idMovie) VALUES(SeqNumCopy.NEXTVAL, P_MOVIE_ID);
				i := i + 1;
			END LOOP;
			V_NewNombre := P_NOMBRECOPIES + V_NombreCopies;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Le nombre de copies du film idMovie = ' || P_MOVIE_ID || ' est passé de ' || P_NOMBRECOPIES || ' a ' || V_NewNombre || '.';
			V_Logs.LogWhere := 'AlimCB.UpdateMovie';
			AddLogs(V_Logs);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin UpdateMovie pour le film idMovie = ' || P_MOVIE_ID;
			V_Logs.LogWhere := 'AlimCB.UpdateMovie';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('UpdateMovie => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.UpdateMovie';
			AddLogs(V_Error);
	END UpdateMovie;
	
	PROCEDURE AddGenres(P_MOVIETOADD IN OUT R_MovieToAdd) AS
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Début AddGenres pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddGenres';
			AddLogs(V_Logs);
			IF(P_MOVIETOADD.TabGenres.COUNT <> 0) THEN
				FORALL i IN P_MOVIETOADD.TabGenres.FIRST .. P_MOVIETOADD.TabGenres.LAST
					MERGE INTO Genres
					USING 
					(SELECT P_MOVIETOADD.TabGenres(i).idGenre, P_MOVIETOADD.TabGenres(i).Name FROM DUAL) 
					ON (Genres.idGenre = P_MOVIETOADD.TabGenres(i).idGenre)
					WHEN NOT MATCHED THEN
						INSERT VALUES (P_MOVIETOADD.TabGenres(i).idGenre, P_MOVIETOADD.TabGenres(i).Name);
						
				FORALL i IN P_MOVIETOADD.TabGenres.FIRST .. P_MOVIETOADD.TabGenres.LAST
					INSERT INTO MovieGenre VALUES(P_MOVIETOADD.idMovie, P_MOVIETOADD.TabGenres(i).idGenre);
			END IF;
			AddActors(P_MOVIETOADD);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin AddGenres pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddGenres';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AddGenres => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.AddGenres';
			AddLogs(V_Error);
	END AddGenres;
	
	PROCEDURE AddActors(P_MOVIETOADD IN OUT R_MovieToAdd) AS
		V_People People%ROWTYPE;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Début AddActors pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddActors';
			AddLogs(V_Logs);
			
			IF(P_MOVIETOADD.TabActors.COUNT <> 0) THEN
				FORALL i IN P_MOVIETOADD.TabActors.FIRST .. P_MOVIETOADD.TabActors.LAST
					MERGE INTO People
					USING
					(SELECT P_MOVIETOADD.TabActors(i).idPeople, P_MOVIETOADD.TabActors(i).Name FROM DUAL)
					ON(People.idPeople = P_MOVIETOADD.TabActors(i).idPeople)
					WHEN NOT MATCHED THEN
						INSERT VALUES (P_MOVIETOADD.TabActors(i).idPeople, P_MOVIETOADD.TabActors(i).Name, NULL, NULL);
				
				FOR i IN P_MOVIETOADD.TabActors.FIRST .. P_MOVIETOADD.TabActors.LAST LOOP
					SELECT * INTO V_People
					FROM People
					WHERE idPeople = P_MOVIETOADD.TabActors(i).idPeople;
					
					IF(V_People.idPoster IS NULL AND P_MOVIETOADD.TabActors(i).idPoster IS NOT NULL) THEN
						INSERT INTO Posters VALUES(P_MOVIETOADD.TabActors(i).idPoster, P_MOVIETOADD.TabActors(i).poster_path);
						UPDATE People
						SET idPoster = P_MOVIETOADD.TabActors(i).idPoster
						WHERE idPeople = P_MOVIETOADD.TabActors(i).idPeople;
					END IF;
				END LOOP;					
			
				FOR i IN P_MOVIETOADD.TabActors.FIRST .. P_MOVIETOADD.TabActors.LAST LOOP
					INSERT INTO MovieActor VALUES (P_MOVIETOADD.idMovie, P_MOVIETOADD.TabActors(i).idPeople, P_MOVIETOADD.TabActors(i).CastId, P_MOVIETOADD.TabActors(i).CharacterName);
				END LOOP;
			END IF;
			AddDirectors(P_MOVIETOADD);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin AddActors pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddActors';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AddActors => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.AddActors';
			AddLogs(V_Error);
	END AddActors;
	
	PROCEDURE AddDirectors(P_MOVIETOADD IN OUT R_MovieToAdd) AS
		V_People People%ROWTYPE;
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Début AddDirectors pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddDirectors';
			AddLogs(V_Logs);
			IF(P_MOVIETOADD.TabDirectors.COUNT <> 0) THEN
				FORALL i IN P_MOVIETOADD.TabDirectors.FIRST .. P_MOVIETOADD.TabDirectors.LAST
					MERGE INTO People
					USING
					(SELECT P_MOVIETOADD.TabDirectors(i).idPeople, P_MOVIETOADD.TabDirectors(i).Name FROM DUAL)
					ON(People.idPeople = P_MOVIETOADD.TabDirectors(i).idPeople)
					WHEN NOT MATCHED THEN
						INSERT VALUES (P_MOVIETOADD.TabDirectors(i).idPeople, P_MOVIETOADD.TabDirectors(i).Name, NULL, NULL);
				
				FOR i IN P_MOVIETOADD.TabDirectors.FIRST .. P_MOVIETOADD.TabDirectors.LAST LOOP
					SELECT * INTO V_People
					FROM People
					WHERE idPeople = P_MOVIETOADD.TabDirectors(i).idPeople;
					
					IF(V_People.idPoster IS NULL AND P_MOVIETOADD.TabDirectors(i).idPoster IS NOT NULL) THEN
						INSERT INTO Posters VALUES(P_MOVIETOADD.TabDirectors(i).idPoster, P_MOVIETOADD.TabDirectors(i).poster_path);
						UPDATE People
						SET idPoster = P_MOVIETOADD.TabDirectors(i).idPoster
						WHERE idPeople = P_MOVIETOADD.TabDirectors(i).idPeople;
					END IF;
				END LOOP;
					
				FORALL i IN P_MOVIETOADD.TabDirectors.FIRST .. P_MOVIETOADD.TabDirectors.LAST
					INSERT INTO MovieDirector VALUES (P_MOVIETOADD.idMovie, P_MOVIETOADD.TabDirectors(i).idPeople);
			END IF;
			AddProductionCompanies(P_MOVIETOADD);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin AddDirectors pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddDirectors';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AddDirectors => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.AddDirectors';
			AddLogs(V_Error);
	END AddDirectors;
	
	PROCEDURE AddProductionCompanies(P_MOVIETOADD IN OUT R_MovieToAdd) AS
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Début AddProductionCompanies pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddProductionCompanies';
			AddLogs(V_Logs);
			IF(P_MOVIETOADD.TabProductionCompanies.COUNT <> 0) THEN
				FOR i IN P_MOVIETOADD.TabProductionCompanies.FIRST .. P_MOVIETOADD.TabProductionCompanies.LAST LOOP
					IF(P_MOVIETOADD.TabProductionCompanies(i).idProductionCompany IS NOT NULL AND P_MOVIETOADD.TabProductionCompanies(i).Name IS NOT NULL) THEN
						MERGE INTO ProductionCompanies
						USING
						(SELECT P_MOVIETOADD.TabProductionCompanies(i).idProductionCompany, P_MOVIETOADD.TabProductionCompanies(i).Name FROM DUAL)
						ON(ProductionCompanies.idProductionCompany = P_MOVIETOADD.TabProductionCompanies(i).idProductionCompany)
						WHEN NOT MATCHED THEN
							INSERT VALUES (P_MOVIETOADD.TabProductionCompanies(i).idProductionCompany, P_MOVIETOADD.TabProductionCompanies(i).Name);
					
						INSERT INTO MovieProductionCompanies VALUES (P_MOVIETOADD.idMovie, P_MOVIETOADD.TabProductionCompanies(i).idProductionCompany);
					END IF;
				END LOOP;
			END IF;
			AddProductionCountries(P_MOVIETOADD);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin AddProductionCompanies pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddProductionCompanies';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AddProductionCompanies => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.AddProductionCompanies';
			AddLogs(V_Error);
	END AddProductionCompanies;
	
	PROCEDURE AddProductionCountries(P_MOVIETOADD IN OUT R_MovieToAdd) AS
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Début AddProductionCountries pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddProductionCountries';
			AddLogs(V_Logs);
			IF(P_MOVIETOADD.TabProductionCountries.COUNT <> 0) THEN
				FOR i IN P_MOVIETOADD.TabProductionCountries.FIRST .. P_MOVIETOADD.TabProductionCountries.LAST LOOP
					IF(P_MOVIETOADD.TabProductionCountries(i).ISOProductionCountry IS NOT NULL) THEN
						MERGE INTO ProductionCountries
						USING
						(SELECT P_MOVIETOADD.TabProductionCountries(i).ISOProductionCountry, P_MOVIETOADD.TabProductionCountries(i).Name FROM DUAL)
						ON(ProductionCountries.ISOProductionCountry = P_MOVIETOADD.TabProductionCountries(i).ISOProductionCountry)
						WHEN NOT MATCHED THEN
							INSERT VALUES (P_MOVIETOADD.TabProductionCountries(i).ISOProductionCountry, P_MOVIETOADD.TabProductionCountries(i).Name);
							
						INSERT INTO MovieProductionCountries VALUES (P_MOVIETOADD.idMovie, P_MOVIETOADD.TabProductionCountries(i).ISOProductionCountry);
					END IF;
				END LOOP;
			END IF;
			AddSpokenLanguages(P_MOVIETOADD);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin AddProductionCountries pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddProductionCountries';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AddProductionCountries => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.AddProductionCountries';
			AddLogs(V_Error);
	END AddProductionCountries;
	
	PROCEDURE AddSpokenLanguages(P_MOVIETOADD IN OUT R_MovieToAdd) AS
		V_Logs Logs%ROWTYPE;
		V_Error Logs%ROWTYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Début AddSpokenLanguages pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddSpokenLanguages';
			AddLogs(V_Logs);
			IF(P_MOVIETOADD.TabSpokenLanguages.COUNT <> 0) THEN
				FOR i IN P_MOVIETOADD.TabSpokenLanguages.FIRST .. P_MOVIETOADD.TabSpokenLanguages.LAST LOOP
					IF(P_MOVIETOADD.TabSpokenLanguages(i).ISOSpokenLanguage IS NOT NULL) THEN
						MERGE INTO SpokenLanguages
						USING
						(SELECT P_MOVIETOADD.TabSpokenLanguages(i).ISOSpokenLanguage, P_MOVIETOADD.TabSpokenLanguages(i).Name FROM DUAL)
						ON(SpokenLanguages.ISOSpokenLanguage = P_MOVIETOADD.TabSpokenLanguages(i).ISOSpokenLanguage)
						WHEN NOT MATCHED THEN
							INSERT VALUES (P_MOVIETOADD.TabSpokenLanguages(i).ISOSpokenLanguage, P_MOVIETOADD.TabSpokenLanguages(i).Name);
					
						INSERT INTO MovieSpokenLanguages VALUES (P_MOVIETOADD.idMovie, P_MOVIETOADD.TabSpokenLanguages(i).ISOSpokenLanguage);
					END IF;
				END LOOP;
			END IF;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Fin AddSpokenLanguages pour le film idMovie = ' || P_MOVIETOADD.idMovie;
			V_Logs.LogWhere := 'AlimCB.AddSpokenLanguages';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('AddSpokenLanguages => ' || SQLERRM);
			ROLLBACK;
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.AddSpokenLanguages';
			AddLogs(V_Error);
	END AddSpokenLanguages;
	
	FUNCTION TrimAlimCB(P_PARAM IN VARCHAR2) RETURN VARCHAR2 AS
		V_Error Logs%ROWTYPE;
		BEGIN
			RETURN TRIM(TRANSLATE(P_PARAM, chr(10) || chr(11) || chr(13), ' '));
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('TrimAlimCB => ' || SQLERRM);
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
			V_Error.LogWhere := 'AlimCB.TrimAlimCB';
			AddLogs(V_Error);
	END TrimAlimCB;
END AlimCB;