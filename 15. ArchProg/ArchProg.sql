CREATE OR REPLACE PROCEDURE ArchProg AS
	TYPE T_Number IS TABLE OF number INDEX BY BINARY_INTEGER;
	V_TabId T_Number;
	V_Compteur number;
	V_TotalJours number;
	V_TotalSieges number;
	V_NombreCopies number;
	V_Archive XMLTYPE;
BEGIN
	AddLogs('Début procédure ArchProg', 'Procédure ArchProg', NULL);

	--Recuperation des films qui ont été programmé
	SELECT DISTINCT EXTRACTVALUE(OBJECT_VALUE, 'projections/idMovie') BULK COLLECT INTO V_TabId
	FROM Projections
	WHERE TO_TIMESTAMP_TZ(EXTRACTVALUE(OBJECT_VALUE, 'projections/debut')) < CURRENT_TIMESTAMP;

	--Pour chaque film
	FOR V_Compteur IN V_TabId.FIRST..V_TabId.LAST LOOP

		--On prend le nombre de places vendues
		SELECT SUM(EXTRACTVALUE(OBJECT_VALUE, 'projections/nbrSpectateurs')) INTO V_TotalSieges
		FROM projections
		WHERE EXTRACTVALUE(OBJECT_VALUE, 'projections/idMovie') = V_TabId(V_Compteur);

		--Nombre de jour à l'affiche
		SELECT COUNT(*) INTO V_TotalJours
		FROM
		(
			SELECT DISTINCT TO_CHAR(TO_TIMESTAMP_TZ(EXTRACTVALUE(OBJECT_VALUE, 'projections/debut')), 'DD-MM-YYYY')
			FROM Projections
			WHERE EXTRACTVALUE(OBJECT_VALUE, 'projections/idMovie') = V_TabId(V_Compteur)
		);

		--Nombre de copies ayant ete utilisees
		SELECT COUNT(*) INTO V_NombreCopies
		FROM 
		(	
			SELECT DISTINCT EXTRACTVALUE(OBJECT_VALUE, 'projections/numCopy')
			FROM projections 
			WHERE EXTRACTVALUE(OBJECT_VALUE, 'projections/idMovie') = V_TabId(V_Compteur)
		);

		SELECT XMLElement("archives", 
						 XMLForest(V_TabId(V_Compteur) AS "idMovie", 
						 V_TotalJours AS "totalJours", 
						 V_TotalSieges AS "totalSieges", 
						 V_NombreCopies AS "nombreCopies"))
		INTO V_Archive
		FROM DUAL;

		BEGIN
			INSERT INTO Archives VALUES(V_Archive);
		EXCEPTION
			WHEN DUP_VAL_ON_INDEX THEN
				UPDATE Archives 
				SET OBJECT_VALUE = V_Archive
				WHERE EXTRACTVALUE(OBJECT_VALUE, 'projections/idMovie') = V_TabId(V_Compteur);
			WHEN OTHERS THEN 
				AddLogs('OTHERS : ' || SQLERRM, 'Procédure ArchProg', SQLCODE);
		END;
	END LOOP;
	COMMIT;
	AddLogs('Fin procédure ArchProg', 'Procédure ArchProg', NULL);
EXCEPTION
	WHEN OTHERS THEN 
		ROLLBACK;
		AddLogs('OTHERS : ' || SQLERRM, 'Procédure ArchProg', SQLCODE);
END;
