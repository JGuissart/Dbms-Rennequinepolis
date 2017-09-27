CREATE OR REPLACE PACKAGE BODY AlimMKT IS
	PROCEDURE AlimentationMKT AS
        BEGIN
            AddLogs('Début procédure AlimentationMKT', 'AlimMKT.AlimentationMKT', NULL);
            MergeMovie;
            InsertPays;
            InsertActors;
            InsertGenres;
            MergeMoviePaysActorsGenres;
            MergeComplexe;
            MergeSalle;
            InsertProgrammations;
            COMMIT;
            AddLogs('Fin procédure AlimentationMKT', 'AlimMKT.AlimentationMKT', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.AlimentationMKT', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
	END;
    
	PROCEDURE MergeMovie AS
        BEGIN
            AddLogs('Début procédure MergeMovie', 'AlimMKT.MergeMovie', NULL);
            FOR cpt IN 1..30 LOOP
                MERGE INTO Movie
                USING (SELECT cpt AS idMov, ROUND(DBMS_RANDOM.VALUE(0, 10), 1) AS cote FROM DUAL)
                ON (Movie.IdMovie = idMov)
                WHEN MATCHED THEN UPDATE SET Movie.coteMoy = cote
                WHEN NOT MATCHED THEN INSERT (IdMovie, cotemoy) VALUES(idMov, cote);
            END LOOP;
            AddLogs('Fin procédure MergeMovie', 'AlimMKT.MergeMovie', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.MergeMovie', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END MergeMovie;

	PROCEDURE InsertPays AS
        BEGIN
            AddLogs('Début procédure InsertPays', 'AlimMKT.InsertPays', NULL);
            INSERT INTO Pays (IdPays, Nom) VALUES (1, 'Allemagne');
            INSERT INTO Pays (IdPays, Nom) VALUES (2, 'Norvège');
            INSERT INTO Pays (IdPays, Nom) VALUES (3, 'Australie');
            INSERT INTO Pays (IdPays, Nom) VALUES (4, 'Autriche');
            INSERT INTO Pays (IdPays, Nom) VALUES (5, 'Belgique');
            INSERT INTO Pays (IdPays, Nom) VALUES (6, 'Brésil');
            INSERT INTO Pays (IdPays, Nom) VALUES (7, 'Bulgarie');
            INSERT INTO Pays (IdPays, Nom) VALUES (8, 'Canada');
            INSERT INTO Pays (IdPays, Nom) VALUES (9, 'Chili');
            INSERT INTO Pays (IdPays, Nom) VALUES (10, 'Chine');
            INSERT INTO Pays (IdPays, Nom) VALUES (11, 'Chypre');
            INSERT INTO Pays (IdPays, Nom) VALUES (12, 'Royaume-Unis');
            INSERT INTO Pays (IdPays, Nom) VALUES (13, 'Croatie');
            INSERT INTO Pays (IdPays, Nom) VALUES (14, 'Danemark');
            INSERT INTO Pays (IdPays, Nom) VALUES (15, 'Espagne');
            INSERT INTO Pays (IdPays, Nom) VALUES (16, 'Etats-Unis');
            INSERT INTO Pays (IdPays, Nom) VALUES (17, 'Finlande');
            INSERT INTO Pays (IdPays, Nom) VALUES (18, 'France');
            INSERT INTO Pays (IdPays, Nom) VALUES (19, 'Grèce');
            INSERT INTO Pays (IdPays, Nom) VALUES (20, 'Hongrie');
            INSERT INTO Pays (IdPays, Nom) VALUES (21, 'Inde');
            INSERT INTO Pays (IdPays, Nom) VALUES (22, 'Irlande');
            INSERT INTO Pays (IdPays, Nom) VALUES (23, 'Italie');
            INSERT INTO Pays (IdPays, Nom) VALUES (24, 'Japon');
            INSERT INTO Pays (IdPays, Nom) VALUES (25, 'Pays-Bas');
            INSERT INTO Pays (IdPays, Nom) VALUES (26, 'Nouvelle-Zélande');
            INSERT INTO Pays (IdPays, Nom) VALUES (27, 'Malte');
            INSERT INTO Pays (IdPays, Nom) VALUES (28, 'Suède');
            INSERT INTO Pays (IdPays, Nom) VALUES (29, 'Mexique');
            INSERT INTO Pays (IdPays, Nom) VALUES (30, 'Monaco');
            AddLogs('Fin procédure InsertPays', 'AlimMKT.InsertPays', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.InsertPays', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END InsertPays;
    
    PROCEDURE InsertActors AS
        BEGIN
            AddLogs('Début procédure InsertActors', 'AlimMKT.InsertActors', NULL);
            INSERT INTO Actor (IdActor, Nationalite) VALUES (1, 'Belgique');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (2, 'Etats-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (3, 'Espagne');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (4, 'France');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (5, 'Canada');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (6, 'Etats-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (7, 'Italie');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (8, 'Royaume-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (9, 'Etats-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (10, 'Royaume-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (11, 'Royaume-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (12, 'Canada');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (13, 'Etats-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (14, 'Royaume-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (15, 'Allemagne');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (16, 'Royaume-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (17, 'Etats-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (18, 'Italie');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (19, 'Royaume-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (20, 'Etats-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (21, 'Canada');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (22, 'Chine');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (23, 'France');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (24, 'Belgique');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (25, 'Etats-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (26, 'Canada');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (27, 'Royaume-Unis');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (28, 'Canada');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (29, 'Pologne');
            INSERT INTO Actor (IdActor, Nationalite) VALUES (30, 'Allemagne');
            AddLogs('Fin procédure InsertActors', 'AlimMKT.InsertActors', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.InsertActors', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END InsertActors;
    
    PROCEDURE InsertGenres AS
        BEGIN
            AddLogs('Début procédure InsertGenres', 'AlimMKT.InsertGenres', NULL);
            INSERT INTO Genre (IdGenre, Nom) VALUES (1, 'Action');
            INSERT INTO Genre (IdGenre, Nom) VALUES (2, 'Animation');
            INSERT INTO Genre (IdGenre, Nom) VALUES (3, 'Aventure');
            INSERT INTO Genre (IdGenre, Nom) VALUES (4, 'Biographique');
            INSERT INTO Genre (IdGenre, Nom) VALUES (5, 'Catastrophe');
            INSERT INTO Genre (IdGenre, Nom) VALUES (6, 'Comédie');
            INSERT INTO Genre (IdGenre, Nom) VALUES (7, 'Comédie dramatique');
            INSERT INTO Genre (IdGenre, Nom) VALUES (8, 'Comédie musicale');
            INSERT INTO Genre (IdGenre, Nom) VALUES (9, 'Comédie Policière');
            INSERT INTO Genre (IdGenre, Nom) VALUES (10, 'Comédie romantique');
            INSERT INTO Genre (IdGenre, Nom) VALUES (11, 'Court métrage');
            INSERT INTO Genre (IdGenre, Nom) VALUES (12, 'Dessin animé');
            INSERT INTO Genre (IdGenre, Nom) VALUES (13, 'Documentaire');
            INSERT INTO Genre (IdGenre, Nom) VALUES (14, 'Drame');
            INSERT INTO Genre (IdGenre, Nom) VALUES (15, 'Drame psychologique');
            INSERT INTO Genre (IdGenre, Nom) VALUES (16, 'Epouvante');
            INSERT INTO Genre (IdGenre, Nom) VALUES (17, 'Erotique');
            INSERT INTO Genre (IdGenre, Nom) VALUES (18, 'Espionnage');
            INSERT INTO Genre (IdGenre, Nom) VALUES (19, 'Fantastique');
            INSERT INTO Genre (IdGenre, Nom) VALUES (20, 'Guerre');
            INSERT INTO Genre (IdGenre, Nom) VALUES (21, 'Historique');
            INSERT INTO Genre (IdGenre, Nom) VALUES (22, 'Horreur');
            INSERT INTO Genre (IdGenre, Nom) VALUES (23, 'Manga');
            INSERT INTO Genre (IdGenre, Nom) VALUES (24, 'Mélodrame');
            INSERT INTO Genre (IdGenre, Nom) VALUES (25, 'Muet');
            INSERT INTO Genre (IdGenre, Nom) VALUES (26, 'Policier');
            INSERT INTO Genre (IdGenre, Nom) VALUES (27, 'Romance');
            INSERT INTO Genre (IdGenre, Nom) VALUES (28, 'Science fiction');
            INSERT INTO Genre (IdGenre, Nom) VALUES (29, 'Thriller');
            INSERT INTO Genre (IdGenre, Nom) VALUES (30, 'Western');
            AddLogs('Fin procédure InsertGenres', 'AlimMKT.InsertGenres', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.InsertGenres', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END InsertGenres;
    
    PROCEDURE MergeMoviePaysActorsGenres AS
        BEGIN
            AddLogs('Début procédure MergeMoviePaysActorsGenres', 'AlimMKT.MergeMoviePaysActorsGenres', NULL);
            FOR cpt IN 1..30 LOOP
                MERGE INTO MoviePays USING (SELECT cpt AS idMov, FLOOR(DBMS_RANDOM.VALUE(1, 30)) AS idPa FROM DUAL)
                ON (MoviePays.IdMovie = idMov)
                WHEN MATCHED THEN UPDATE SET MoviePays.IdPays = idPa
                WHEN NOT MATCHED THEN INSERT (IdMovie, IdPays) VALUES(idMov, idPa);

                MERGE INTO MovieActor USING (SELECT cpt AS idMov, FLOOR(DBMS_RANDOM.VALUE(1, 30)) AS idAct FROM DUAL)
                ON (MovieActor.IdMovie = idMov)
                WHEN MATCHED THEN UPDATE SET MovieActor.IdActor = idAct
                WHEN NOT MATCHED THEN INSERT (IdMovie, IdActor) VALUES(idMov, idAct);

                MERGE INTO MovieGenre USING (SELECT cpt AS idMov, FLOOR(DBMS_RANDOM.VALUE(1, 30)) AS idGen FROM DUAL)
                ON (MovieGenre.IdMovie = idMov)
                WHEN MATCHED THEN UPDATE SET MovieGenre.IdGenre = idGen
                WHEN NOT MATCHED THEN INSERT (IdMovie, IdGenre) VALUES(idMov, idGen);
            END LOOP;
            AddLogs('Fin procédure MergeMoviePaysActorsGenres', 'AlimMKT.MergeMoviePaysActorsGenres', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.MergeMoviePaysActorsGenres', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END MergeMoviePaysActorsGenres;
    
    PROCEDURE MergeComplexe AS
        BEGIN
            AddLogs('Début procédure MergeComplexe', 'AlimMKT.MergeComplexe', NULL);
            FOR cpt IN 1..30 LOOP
                MERGE INTO Complexe USING (SELECT 'CC' || cpt AS idComp FROM DUAL)
                ON (Complexe.IdComplexe = idComp)
                WHEN NOT MATCHED THEN INSERT (IdComplexe) VALUES(idComp);
            END LOOP;
            AddLogs('Fin procédure MergeComplexe', 'AlimMKT.MergeComplexe', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.MergeComplexe', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END MergeComplexe;
    
    PROCEDURE MergeSalle AS
        BEGIN
            AddLogs('Début procédure InsertSalles', 'AlimMKT.InsertSalles', NULL);
            FOR cpt IN 1..30 LOOP
                MERGE INTO Salle USING (SELECT cpt AS idSal, 300 AS placesTot, 'CC' || cpt AS IdComp FROM DUAL)
                ON (Salle.IdSalle = idSal)
                WHEN MATCHED THEN UPDATE SET Salle.PlacesTotales = placesTot, Salle.IdComplexe = IdComp
                WHEN NOT MATCHED THEN INSERT (IdSalle, PlacesTotales, IdComplexe) VALUES(idSal, placesTot, IdComp);
            END LOOP;
            AddLogs('Fin procédure InsertSalles', 'AlimMKT.InsertSalles', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.InsertSalles', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END MergeSalle;
    
    PROCEDURE InsertProgrammations AS
        BEGIN
            AddLogs('Début procédure InsertProgrammations', 'AlimMKT.InsertProgrammations', NULL);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (1, TO_TIMESTAMP('16/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (2, TO_TIMESTAMP('16/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (3, TO_TIMESTAMP('16/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (4, TO_TIMESTAMP('17/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (5, TO_TIMESTAMP('17/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (6, TO_TIMESTAMP('17/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (7, TO_TIMESTAMP('18/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (8, TO_TIMESTAMP('18/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (9, TO_TIMESTAMP('18/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 1);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (10, TO_TIMESTAMP('16/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 2);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (11, TO_TIMESTAMP('17/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 2);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (12, TO_TIMESTAMP('18/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 2);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (13, TO_TIMESTAMP('19/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 2);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (14, TO_TIMESTAMP('20/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 2);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (15, TO_TIMESTAMP('21/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 2);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (16, TO_TIMESTAMP('22/12/15 13:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 2);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (17, TO_TIMESTAMP('16/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 3);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (18, TO_TIMESTAMP('17/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 3);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (19, TO_TIMESTAMP('18/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 3);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (20, TO_TIMESTAMP('19/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 3);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (21, TO_TIMESTAMP('20/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 3);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (22, TO_TIMESTAMP('21/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 3);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (23, TO_TIMESTAMP('22/12/15 21:00:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 3);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (24, TO_TIMESTAMP('16/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 4);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (25, TO_TIMESTAMP('17/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 4);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (26, TO_TIMESTAMP('18/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 4);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (27, TO_TIMESTAMP('19/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 4);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (28, TO_TIMESTAMP('20/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 4);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (29, TO_TIMESTAMP('21/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 4);
            INSERT INTO Programmation (IdMovie, Debut, PlacesVendues, IdSalle) VALUES (30, TO_TIMESTAMP('22/12/15 18:30:00','DD/MM/RR HH24:MI:SSXFF'), FLOOR(DBMS_RANDOM.VALUE(0, 300)), 4);
            AddLogs('Fin procédure InsertProgrammations', 'AlimMKT.InsertProgrammations', NULL);
        EXCEPTION
            WHEN OTHERS THEN 
                ROLLBACK;
                AddLogs('OTHERS : ' || SQLERRM, 'AlimMKT.InsertProgrammations', SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM); 
    END InsertProgrammations;
    
END;
/

COMMIT;

