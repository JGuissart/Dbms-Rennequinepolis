CREATE OR REPLACE PACKAGE BODY AlimDW IS
	PROCEDURE Load AS 
	BEGIN
		AddLogs('Début procédure Load', 'AlimDW.Load', NULL);
		LoadDimensions;
		--LoadFaits;
		AddLogs('Fin procédure Load', 'AlimDW.Load', NULL);
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			AddLogs('OTHERS : ' || SQLERRM, 'AlimDW.Load', SQLCODE);
			DBMS_OUTPUT.PUT_LINE(SQLERRM); 
	END;

	PROCEDURE LoadDimensions AS
		V_Heure NUMBER;
	BEGIN
		AddLogs('Début procédure LoadDimensions', 'AlimDW.LoadDimensions', NULL);
		MERGE INTO Dim_Genre T1 
		USING (SELECT Nom FROM Genre@MKT) T2 
		ON (T1.Genre = T2.Nom)
		WHEN NOT MATCHED THEN INSERT (T1.Genre) VALUES (T2.Nom);

		MERGE INTO Dim_Salle T1 
		USING (SELECT IDSalle FROM Salle@MKT) T2 
		ON (T1.Salle = T2.IDSalle)
		WHEN NOT MATCHED THEN INSERT (T1.Salle) VALUES (T2.IDSalle);

		MERGE INTO Dim_Complexe T1 
		USING (SELECT IDComplexe FROM Complexe@MKT) T2 
		ON (T1.Complexe = T2.IDComplexe)
		WHEN NOT MATCHED THEN INSERT (T1.Complexe) VALUES (T2.IDComplexe);

		MERGE INTO Dim_Pays T1 
		USING (SELECT Nom FROM Pays@MKT) T2 
		ON (T1.Pays = T2.Nom)
		WHEN NOT MATCHED THEN INSERT (T1.Pays) VALUES (T2.Nom);

		MERGE INTO Dim_Pays T1 
		USING (SELECT NATIONALITE FROM ACTOR@MKT) T2 
		ON (T1.Pays = T2.NATIONALITE)
		WHEN NOT MATCHED THEN INSERT (T1.Pays) VALUES (T2.NATIONALITE);

		MERGE INTO Dim_Film T1 
		USING (SELECT IDMovie  FROM Movie@MKT) T2 
		ON (T1.Movie = T2.IDMovie)
		WHEN NOT MATCHED THEN INSERT (T1.Movie) VALUES (T2.IDMovie);

		SELECT EXTRACT (HOUR FROM Debut) INTO V_Heure FROM Programmation@MKT;
		IF V_Heure < 12 THEN
			MERGE INTO Dim_Periode T1 
			USING (SELECT 'MATIN' FROM DUAL) T2 
			ON (T1.Periode = V_Heure)
			WHEN NOT MATCHED THEN INSERT (T1.Periode) VALUES ('MATIN');
		ELSIF V_Heure > 18 THEN
			MERGE INTO Dim_Periode T1 
			USING (SELECT 'SOIR' FROM DUAL) T2 
			ON (T1.Periode = V_Heure)
			WHEN NOT MATCHED THEN INSERT (T1.Periode) VALUES ('SOIR');
		ELSE
			MERGE INTO Dim_Periode T1 
			USING (SELECT 'APRES-MIDI' FROM DUAL) T2 
			ON (T1.Periode = V_Heure)
			WHEN NOT MATCHED THEN INSERT (T1.Periode) VALUES ('APRES-MIDI');
		END IF;

		MERGE INTO Dim_Jour T1 
		USING (SELECT EXTRACT(DAY FROM Debut) d FROM Programmation@MKT) T2 
		ON (T1.Jour = T2.d)
		WHEN NOT MATCHED THEN INSERT (T1.Jour) VALUES (T2.d);

		MERGE INTO Dim_Semaine T1 
		USING (SELECT TO_CHAR(Debut,'IW') d FROM Programmation@MKT) T2 
		ON (T1.Semaine = T2.d)
		WHEN NOT MATCHED THEN INSERT (T1.Semaine) VALUES (T2.d);

		MERGE INTO Dim_Mois T1 
		USING (SELECT (TO_DATE('01/' || EXTRACT(MONTH FROM Debut) || '/' || EXTRACT(YEAR FROM Debut), 'dd/mm/yyyy')) d FROM Programmation@MKT) T2 
		ON (T1.Mois = T2.d)
		WHEN NOT MATCHED THEN INSERT (T1.Mois) VALUES (T2.d);

		MERGE INTO Dim_Annee T1 
		USING (SELECT (TO_DATE('01/01' || EXTRACT(YEAR FROM Debut), 'dd/mm/yyyy')) d FROM Programmation@MKT) T2 
		ON (T1.Annee = T2.d)
		WHEN NOT MATCHED THEN INSERT (T1.Annee) VALUES (T2.d);

		COMMIT;
		AddLogs('Fin procédure LoadDimensions', 'AlimDW.LoadDimensions', NULL);
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			AddLogs('OTHERS : ' || SQLERRM, 'AlimDW.LoadDimensions', SQLCODE);
			DBMS_OUTPUT.PUT_LINE(SQLERRM); 
	END;
	
	--PROCEDURE LoadFaits AS
	--BEGIN
		--AddLogs('Début procédure LoadFaits', 'AlimDW.LoadFaits', NULL);
		--AddLogs('Fin procédure LoadFaits', 'AlimDW.LoadFaits', NULL);
	--EXCEPTION
		--WHEN OTHERS THEN AddLogs('OTHERS : ' || SQLERRM, 'AlimDW.LoadFaits', SQLCODE);
	--END;
END;
/

COMMIT;

