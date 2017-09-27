-------------------
-- SPECIFICATION --
-------------------

CREATE OR REPLACE PACKAGE AlimCC
IS
	PROCEDURE MovieCopy(P_IdMovie IN NUMBER);
	PROCEDURE JobAlimCC;
END;
/


----------
-- BODY --
----------

CREATE OR REPLACE PACKAGE BODY AlimCC AS
	PROCEDURE MovieCopy(P_IdMovie IN NUMBER) AS
		V_NombreCopiesDispo NUMBER;
		V_NombreCopiesTransfert NUMBER;
		V_DocumentXML XMLTYPE;
		TYPE T_Copies IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
		V_Copy T_Copies;
		V_Parcours NUMBER;
	BEGIN
		AddLogs('Début Procédure MovieCopy', 'AlimCC.MovieCopy', NULL);
		-- Génération du nombre de copie à envoyer sur base du nombre de copies présentes sur CB
		SELECT COUNT(*) INTO V_NombreCopiesDispo FROM Copies WHERE idMovie = P_IdMovie;
		V_NombreCopiesTransfert := FLOOR(dbms_random.value(0, V_NombreCopiesDispo/2));

		IF V_NombreCopiesTransfert > 0 THEN
			-- Generation des infos du Movies en XML
			SELECT XMLElement(	"movies", 
								XMLForest(	Movies.idMovie AS "idMovie", 
											Movies.title AS "title", 
											Movies.original_title AS "originalTitle",
											TO_CHAR(Movies.release_date, 'YYYY/MM/DD') AS "release_date",
											Movies.status AS "status",
											to_char(Movies.vote_average,'000.000') AS "vote_average",
											Movies.vote_count AS "vote_count",
											Movies.runtime AS "runtime",
											Movies.certification AS "certification",
											Movies.idPoster AS "idPoster",
											Movies.budget AS "budget",
											Movies.revenue AS "revenue",
											Movies.homepage AS "homepage",
											Movies.tagline AS "tagline",
											Movies.overview AS "overview"),
								XMLElement	("genres", (SELECT XMLAgg( XMLElement(	"genre",
																					XMLForest(genres.idGenre AS "idGenre", genres.Name AS "name")))
													FROM Movies
													INNER JOIN MovieGenre ON Movies.idMovie = MovieGenre.idMovie
													INNER JOIN genres ON MovieGenre.idGenre = Genres.idGenre
													WHERE Movies.idMovie = P_IdMovie
												)
											),
								XMLElement	("productions", (SELECT XMLAgg( XMLElement("production",
																						XMLForest(ProductionCompanies.idProductionCompany AS "idProductionCompany", ProductionCompanies.name AS "name")))
													FROM Movies
													INNER JOIN MovieProductionCompanies ON Movies.idMovie = MovieProductionCompanies.idMovie
													INNER JOIN ProductionCompanies ON MovieProductionCompanies.idProductionCompany = ProductionCompanies.idProductionCompany
													WHERE Movies.idMovie = P_IdMovie
												)
											),

								XMLElement	("languages", (SELECT XMLAgg( XMLElement("language",
																					XMLForest(SpokenLanguages.ISOSpokenLanguage AS "ISOSpokenLanguage", SpokenLanguages.name AS "name")))
													FROM Movies
													INNER JOIN MovieSpokenLanguages ON Movies.idMovie = MovieSpokenLanguages.idMovie
													INNER JOIN SpokenLanguages ON MovieSpokenLanguages.ISOSpokenLanguage = SpokenLanguages.ISOSpokenLanguage
													WHERE Movies.idMovie = P_IdMovie
												)
											),

								XMLElement	("listCountries", (SELECT XMLAgg( XMLElement("country",
																					XMLForest(ProductionCountries.ISOProductionCountry AS "ISOProductionCountry", ProductionCountries.name AS "name")))
													FROM Movies
													INNER JOIN MovieProductionCountries ON Movies.idMovie = MovieProductionCountries.idMovie
													INNER JOIN ProductionCountries ON MovieProductionCountries.ISOProductionCountry = ProductionCountries.ISOProductionCountry
													WHERE Movies.idMovie = P_IdMovie
												)
											),

								XMLElement	("actors", (SELECT XMLAgg( XMLElement("actor",
																				XMLForest(People.idPeople AS "idActor", People.name AS "name", MovieActor.characterName AS "characterName")))
													FROM Movies
													INNER JOIN MovieActor ON Movies.idMovie = MovieActor.idMovie
													INNER JOIN People ON MovieActor.idPeople = People.idPeople
													WHERE Movies.idMovie = P_IdMovie
												)
											),

								XMLElement	("directors", (SELECT XMLAgg( XMLElement("director",
																				XMLForest(People.idPeople AS "idDirector", People.name AS "name")))
													FROM Movies
													INNER JOIN MovieDirector ON Movies.idMovie = MovieDirector.idMovie
													INNER JOIN People ON MovieDirector.idPeople = People.idPeople
													WHERE Movies.idMovie = P_IdMovie
												)
											),

								XMLElement	("listOpinions", (SELECT XMLAgg( XMLElement("opinion",
																				XMLForest(QuotationsOpinions.Quotation AS "Quotation", QuotationsOpinions.Opinion AS "Opinion")))
													FROM Movies
													INNER JOIN QuotationsOpinions ON Movies.idMovie = QuotationsOpinions.idMovie
													WHERE Movies.idMovie = P_IdMovie
												)
											)
							)
			INTO V_DocumentXML
			FROM Movies
			WHERE idMovie = P_IdMovie;

			--Insertion du XML généré dans la table de communication avec CC
			INSERT INTO MovieTmp
			VALUES(V_DocumentXML);
			
			SELECT numCopy BULK COLLECT INTO V_Copy
			FROM (SELECT numCopy, ROWNUM FROM Copies WHERE idMovie = P_IdMovie)
			WHERE ROWNUM <= V_NombreCopiesTransfert;

			FOR V_Parcours IN V_Copy.FIRST..V_Copy.LAST LOOP
				SELECT XMLElement("copies", XMLForest(P_IdMovie AS "idMovie", V_Copy(V_Parcours) AS "numCopy")) INTO V_DocumentXML
				FROM DUAL;

				INSERT INTO CopyTmp VALUES(V_DocumentXML); --Insertion de la copie sélectionnée dans la table de communicaiton avec CC
				DELETE FROM Copies WHERE idMovie = P_IdMovie AND numCopy = V_Copy(V_Parcours); --Suppression sur CB de la copie envoyée
			END LOOP;
		END IF;
		AddLogs('Fin Procédure MovieCopy', 'AlimCC.MovieCopy', NULL);
	EXCEPTION
		WHEN OTHERS THEN 
		ROLLBACK;
		AddLogs('OTHERS : ' || SQLERRM, 'AlimCC.MovieCopy', SQLCODE);
	END;
	
	PROCEDURE JobAlimCC AS
		V_Movie Movies%ROWTYPE;
	BEGIN
		AddLogs('Début Procédure JobAlimCC', 'AlimCC.JobAlimCC', NULL);
		--Boucle sur tous les Moviess présents dans CB
		FOR V_Movie IN (SELECT * FROM Movies) LOOP
			MovieCopy(V_Movie.idMovie);
		END LOOP;

		COMMIT;

		RECEPTION@CC; --Demande à CC de lire la table remplie lors de MOVIE_COPY_GENERATOR
		AddLogs('Fin Procédure JobAlimCC', 'AlimCC.JobAlimCC', NULL);
	EXCEPTION
		WHEN OTHERS THEN 
		ROLLBACK;
		AddLogs('OTHERS : ' || SQLERRM, 'AlimCC.MovieCopy', SQLCODE);
	END;
END;