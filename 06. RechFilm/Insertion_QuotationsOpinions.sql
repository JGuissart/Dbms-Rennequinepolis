/* Insertion d'une cote aléatoire pour TOUS les films se trouvant sur le schéma CB */
DECLARE
  TYPE T_IDMOVIE IS TABLE OF Movies.IdMovie%TYPE INDEX BY PLS_INTEGER;
  V_Tab T_IDMOVIE;
  V_Cote NUMBER := 0;
BEGIN
  SELECT IDMOVIE BULK COLLECT INTO V_Tab
  FROM Movies;
  
  FOR i IN V_Tab.FIRST .. V_Tab.LAST LOOP
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, 'TERRIBLE !!!!', CURRENT_DATE, 'julien', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, 'Vraiment bien', CURRENT_DATE, 'adrien', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(NULL, 'Bon film', CURRENT_DATE, 'erwan', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, 'Plutôt bon comme film !', CURRENT_DATE, 'thibault', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(NULL, 'Pas mal', CURRENT_DATE, 'pierre', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, 'Moyenne tout juste', CURRENT_DATE, 'oceane', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, 'Bof', CURRENT_DATE, 'timon', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, NULL, CURRENT_DATE, 'nicolas', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, NULL, CURRENT_DATE, 'arnaud', V_Tab(i));
    V_Cote := ROUND(DBMS_RANDOM.NORMAL * 1.5 + 5);
    INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, Login, idMovie) VALUES(V_Cote, NULL, CURRENT_DATE, 'jerome', V_Tab(i));
    COMMIT;
  END LOOP;
END;