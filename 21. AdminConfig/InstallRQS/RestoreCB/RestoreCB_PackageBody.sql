create or replace PACKAGE BODY RestoreCB AS
	------------ CheckCB ------------------------------------------------------------
	-- *** IN : /
	-- *** OUT : /
	-- *** PROCESS : vérifie si CB est de nouveau disponible ou non
	---------------------------------------------------------------------------------------------------------
	PROCEDURE CheckCB AS
		V_AccountStatus dba_users.Account_status%TYPE;
		E_CB_Disponible EXCEPTION;
		BEGIN
			AddLogs('Vérification si CB est disponible ou non.', 'RestoreCB.CheckCB', NULL);
			SELECT Account_status INTO V_AccountStatus
			FROM dba_users
			WHERE Username = 'CB';
			
			IF(V_AccountStatus = 'OPEN') THEN
				RAISE E_CB_Disponible;
			END IF;
		EXCEPTION
			WHEN E_CB_Disponible THEN
				ROLLBACK;
				Restore; -- On restaure d'abord
				RAISE_APPLICATION_ERROR(-20999, 'CB est de nouveau disponible'); -- On prévient l'utilisateur ensuite
			WHEN OTHERS THEN
				AddLogs('OTHERS : ' || SQLERRM, 'RestoreCB.CheckCB', SQLCODE);
	END CheckCB;
	
	/****************************************************************************************************************************************/
	
	------------ Restore ------------------------------------------------------------
	-- *** IN : /
	-- *** OUT : /
	-- *** PROCESS : restore les données de CBB vers CB si CB est redevenu disponible
	---------------------------------------------------------------------------------------------------------
	
	PROCEDURE Restore AS
		V_QuotaOpin QuotationsOpinions%ROWTYPE;
		BEGIN
			AddLogs('Début de la restauration vers CB', 'RestoreCB.Restore', NULL);
			
			-- Users
			INSERT INTO Users@CB
			SELECT Login, Password, LastName, FirstName, DateOfBirth, 'OK'
			FROM Users
			WHERE Token IS NULL;
			
			UPDATE Users
			SET Token = 'OK'
			WHERE Token IS NULL;

			-- QuotationsOpinions
			FOR V_QuotaOpin IN(SELECT Login, IdMovie, Quotation, Opinion, DateOfPost, 'OK' FROM QuotationsOpinions WHERE Token = 'KO')
			LOOP
				MERGE INTO QuotationsOpinions@CB qo
				USING
				(SELECT V_QuotaOpin.Login, V_QuotaOpin.IdMovie, V_QuotaOpin.Quotation, V_QuotaOpin.Opinion, V_QuotaOpin.DateOfPost, 'OK' FROM DUAL)
				ON(qo.IdMovie = V_QuotaOpin.IdMovie AND qo.Login = V_QuotaOpin.Login)
				WHEN MATCHED THEN
					UPDATE SET qo.Quotation = V_QuotaOpin.Quotation, qo.Opinion = V_QuotaOpin.Opinion
				WHEN NOT MATCHED THEN
					INSERT VALUES V_QuotaOpin;
			END LOOP;

			UPDATE QuotationsOpinions SET Token = 'OK' WHERE Token IS NULL;
			
			AddLogs('Fin de la restauration vers CB', 'RestoreCB.Restore', NULL);
			COMMIT;
		EXCEPTION
			WHEN OTHERS THEN
				ROLLBACK;
				AddLogs('OTHERS : ' || SQLERRM, 'RestoreCB.Restore', SQLCODE);
	END Restore;
END RestoreCB;
/