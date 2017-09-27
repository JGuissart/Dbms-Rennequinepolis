CREATE OR REPLACE PROCEDURE Reception AS 
BEGIN
	AddLogs('Début procédure Reception', 'Procédure reception', NULL);
	INSERT INTO CopyTmp SELECT * from Copies c
						WHERE NOT EXISTS
							(
								SELECT *
								FROM Projections p
								WHERE extractvalue(c.object_value, 'copies/idMovie') = extractvalue(p.object_value,'projections/idMovie')
								AND extractvalue(c.object_value, 'copies/numCopy') = extractvalue(p.object_value, 'projections/numCopy')
								AND current_timestamp < to_timestamp_tz(extractvalue(p.object_value,'projections/debut'))
							);
	DELETE FROM Copies	
	WHERE EXTRACTVALUE(object_value, 'copies/idMovies') IN (SELECT EXTRACTVALUE(XML_COL, 'copies/idMovies') FROM CopyTmp)
	AND EXTRACTVALUE(object_value,'copies/numCopy') IN (SELECT EXTRACTVALUE(XML_COL,'copies/numCopy') FROM CopyTmp);
	INSERT INTO MOVIES SELECT * FROM MovieTmp@CB
	WHERE EXTRACTVALUE(XML_COL,'movies/idMovie') NOT IN (SELECT extractvalue(object_value,'movies/idMovie') FROM MOVIES);
	INSERT INTO Copies SELECT * FROM CopyTmp@CB;
	DELETE FROM MovieTmp@CB;
	DELETE FROM CopyTmp@CB;
  
	COMMIT;

	BEGIN 
		RetourCopie@CB;
	EXCEPTION
		WHEN OTHERS THEN 
			AddLogs('CB indisponible, passage à CBB', 'Procédure reception', NULL);
			DBMS_OUTPUT.PUT_LINE('[Reception] : CB indisponible, passage à CBB');
		RetourCopie@CBB;
	END;
	
	AddLogs('Fin procédure Reception', 'Procédure reception', NULL);
EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK;
	AddLogs('OTHERS : ' || SQLERRM, 'Procédure reception', SQLCODE);
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;