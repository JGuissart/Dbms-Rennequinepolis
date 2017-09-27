CREATE OR REPLACE PROCEDURE RetourCopie AS
	BEGIN
		AddLogs('Début procédure RetourCopie', 'Procédure RetourCopie', NULL);
		INSERT INTO Copies(numCopy, idMovie, Token) 
		SELECT EXTRACTVALUE(XML_COL , 'copies/numCopy'), EXTRACTVALUE(XML_COL , 'copies/idMovie') , NULL FROM CopyTmp@CC;

		DELETE FROM CopyTmp@CC;

		COMMIT;
    
		AddLogs('Fin procédure RetourCopie', 'Procédure RetourCopie', NULL);
	EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK;
		AddLogs('OTHERS : ' || SQLERRM, 'Procédure RetourCopie', SQLCODE);
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
	END;