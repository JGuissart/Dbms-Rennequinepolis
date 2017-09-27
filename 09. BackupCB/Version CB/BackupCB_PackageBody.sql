create or replace PACKAGE BODY BackupCB AS
	------------ CheckUserToReplicate ------------------------------------------------------------
	-- *** IN : Users.Login%TYPE
	-- *** OUT : /
	-- *** PROCESS : vérifie si l'utilisateur a déjà été répliqué sur CBB ou non
	---------------------------------------------------------------------------------------------------------
	FUNCTION CheckUserToReplicate(P_LOGIN IN Users.Login%TYPE) RETURN BOOLEAN AS
		V_User Users%ROWTYPE;
		BEGIN
			SELECT * INTO V_User
			FROM Users@CBB
			WHERE Login = P_LOGIN;
			
			RETURN TRUE;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN FALSE;
			WHEN OTHERS THEN
				AddLogs('OTHERS : ' || SQLERRM, 'BackupCB.CheckUserToReplicate', SQLCODE);
	END CheckUserToReplicate;
	
	------------ CheckMovieToReplicate ------------------------------------------------------------
	-- *** IN : Movies.IdMovie%TYPE
	-- *** OUT : /
	-- *** PROCESS : vérifie si le film a déjà été répliqué sur CBB ou non
	---------------------------------------------------------------------------------------------------------
	
	FUNCTION CheckMovieToReplicate(P_IDMOVIE IN Movies.IdMovie%TYPE) RETURN BOOLEAN AS
		V_Movie Movies%ROWTYPE;
		BEGIN
			SELECT * INTO V_Movie
			FROM Movies@CBB
			WHERE IdMovie = P_IDMOVIE;
			
			RETURN TRUE;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN FALSE;
			WHEN OTHERS THEN
				AddLogs('OTHERS : ' || SQLERRM, 'BackupCB.CheckMovieToReplicate', SQLCODE);
	END CheckMovieToReplicate;
	
	------------ Job_ReplicationAsync ------------------------------------------------------------
	-- *** IN : /
	-- *** OUT : /
	-- *** PROCESS : procédure qui va répliquer les données sur CBB
	---------------------------------------------------------------------------------------------------------
	
	PROCEDURE Job_ReplicationAsync AS
		BEGIN
			AddLogs('Début procédure Job_ReplicationAsync', 'BackupCB.Job_ReplicationAsync', NULL);
			
			-- Réplication des utilisateurs
			INSERT INTO Users@CBB
				SELECT Login, Password, LastName, FirstName, DateOfBirth, 'OK'
				FROM Users
				WHERE Token IS NULL;

			-- Réplication des posters de films
			INSERT INTO Posters@CBB
				SELECT idPoster, Poster_path
				FROM Movies NATURAL JOIN Posters
				WHERE Token IS NULL;
				
			-- Réplication des posters de personnes
			INSERT INTO Posters@CBB
				SELECT idPoster, Poster_path
				FROM People NATURAL JOIN Posters
				WHERE Token IS NULL;

			-- Réplication des films
			INSERT INTO Movies@CBB
				SELECT IDMOVIE, TITLE, ORIGINAL_TITLE, RELEASE_DATE, STATUS, VOTE_AVERAGE, VOTE_COUNT, RUNTIME, CERTIFICATION, BUDGET, REVENUE, HOMEPAGE, TAGLINE, OVERVIEW, NOMBRECOPIES, IDPOSTER, 'OK'
				FROM Movies
				WHERE Token IS NULL;

			-- Réplication des copies des films
			INSERT INTO Copies@CBB
				SELECT NumCopy, idMovie, 'OK'
				FROM Copies
				WHERE TOKEN = 'KO';

			-- Réplication des genres des films répliqués (il faut suivre ...)
			INSERT INTO MovieGenre@CBB
				SELECT idMovie, idGenre
				FROM MovieGenre NATURAL JOIN Movies
				WHERE Token IS NULL;

			-- Réplication des compagnies de production des films répliqués
			INSERT INTO MovieProductionCompanies@CBB
				SELECT idMovie, IdProductionCompany
				FROM MovieProductionCompanies NATURAL JOIN Movies
				WHERE Token IS NULL;
				
			-- Réplication des pays de production des films répliqués
			INSERT INTO MovieProductionCountries@CBB
				SELECT idMovie, ISOProductionCountry
				FROM MovieProductionCountries NATURAL JOIN Movies
				WHERE Token IS NULL;

			-- Réplication des langues des films répliqués 
			INSERT INTO MovieSpokenLanguages@CBB
				SELECT idMovie, ISOSpokenLanguage
				FROM MovieSpokenLanguages NATURAL JOIN Movies
				WHERE Token IS NULL;
				
			-- Réplication des personnes liées aux films répliqués
			INSERT INTO People@CBB
				SELECT *
				FROM People
				WHERE Token IS NULL;

			-- Réplication des acteurs jouant dans les films répliqués
			INSERT INTO MovieActor@CBB
				SELECT idMovie, idPeople, CastId, CharacterName
				FROM MovieActor NATURAL JOIN Movies
				WHERE Token IS NULL;

			-- Réplication des évaluations des films répliqués
			INSERT INTO QuotationsOpinions@CBB
				SELECT LOGIN, IDMOVIE, QUOTATION, OPINION, DATEOFPOST, 'OK'
				FROM QuotationsOpinions
				WHERE TOKEN = 'KO';
				
			-- MAJ des tokens
			UPDATE QuotationsOpinions SET TOKEN = 'OK' WHERE TOKEN = 'KO';
			UPDATE Copies SET TOKEN = 'OK' WHERE TOKEN = 'KO';
			UPDATE Users SET TOKEN = 'OK' WHERE TOKEN IS NULL;
			UPDATE Movies SET TOKEN = 'OK' WHERE TOKEN IS NULL;
			UPDATE People SET TOKEN = 'OK' WHERE TOKEN IS NULL;

			COMMIT;
			AddLogs('Fin procédure Job_ReplicationAsync', 'BackupCB.Job_ReplicationAsync', NULL);
		EXCEPTION
			WHEN OTHERS THEN
				ROLLBACK;
				AddLogs('OTHERS : ' || SQLERRM, 'BackupCB.Job_ReplicationAsyncn', SQLCODE);
	END Job_ReplicationAsync;
END BackupCB;