CREATE OR REPLACE PACKAGE BODY RestoreCBLight AS
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
				V_Error.LogWhere := 'RestoreCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT;
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RestoreCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT; 
	END AddLogs;
	
	FUNCTION GenerateIdUser(P_LASTNAME Users.LastName%TYPE, P_FIRSTNAME Users.FirstName%TYPE, P_DOB Users.DateOfBirth%TYPE) RETURN Users.idUser%TYPE AS
		V_Matricule Users.idUser%TYPE;
		BEGIN
			V_Matricule := TO_CHAR(P_DOB, 'YYMMDD') || UPPER(SUBSTR(P_LASTNAME, 1, 3)) || UPPER(SUBSTR(P_FIRSTNAME, 1, 3));
			RETURN V_Matricule;
		EXCEPTION
			WHEN OTHERS THEN RAISE;
				RETURN NULL;
	END GenerateIdUser;
	
	PROCEDURE VerificationQuotationOpinion(P_QUOTA QuotationsOpinions.Quotation%TYPE, P_OPIN QuotationsOpinions.Opinion%TYPE) AS
		E_QuotaOpinNull EXCEPTION;
		V_Logs RestoreCBLight.R_Logs;
		V_Error RestoreCBLight.R_Logs;
		BEGIN
			IF (P_QUOTA IS NULL AND P_OPIN IS NULL) THEN
			RAISE E_QuotaOpinNull;
		END IF;
		V_Logs.LogWhen := CURRENT_DATE;
		V_Logs.ErrorCode := NULL;
		V_Logs.LogWhat := 'Vérification de la cote et de l''avis effectué.';
		V_Logs.LogWhere := 'RestoreCBLight.VerificationQuotationOpinion';
		AddLogs(V_Logs);
	EXCEPTION
		WHEN E_QuotaOpinNull THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := '-20003';
			V_Error.LogWhat := 'Il faut encoder un avis ou une cote ou les 2.';
			V_Error.LogWhere := 'RestoreCBLight.VerificationQuotationOpinion';
			AddLogs(V_Error);
		WHEN OTHERS THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := SQLERRM;
			V_Error.LogWhere := 'RestoreCBLight.VerificationQuotationOpinion';
			AddLogs(V_Error);
	END VerificationQuotationOpinion;
	
	PROCEDURE InsertUserToAdd(P_IDUSER Users.IdUser%TYPE) AS
		V_Logs R_Logs;
		V_Error R_Logs;
		E_ParamaterNull EXCEPTION;
		BEGIN
			INSERT INTO UsersToAdd(idUser) VALUES(P_IDUSER);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'INSERT du tuple identifié par ' || P_IDUSER || ' dans la table UsersToAdd';
			V_Logs.LogWhere := 'RestoreCBLight.InsertUserToAdd';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := SQLERRM;
				V_Error.LogWhere := 'RestoreCBLight.InsertUserToAdd';
				AddLogs(V_Error); 
	END InsertUserToAdd;
	
	FUNCTION CheckUsersToAdd(P_USERID Users.idUser%TYPE) RETURN BOOLEAN	AS
		V_Logs R_Logs;
		V_Error R_Logs;
		V_UserId UsersToAdd.idUser%TYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Je vérifie si l''utilisateur va être répliqué sur CBB';
			V_Logs.LogWhere := 'RestoreCBLight.CheckUsersToAdd';
			AddLogs(V_Logs);
			
			SELECT idUser INTO V_UserId
			FROM UsersToAdd
			WHERE idUser = P_USERID;
			
			RETURN TRUE;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN FALSE;
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'RestoreCBLight.CheckUsersToAdd';
				AddLogs(V_Error);
	END CheckUsersToAdd;

	PROCEDURE Restore AS
		V_Logs R_Logs;
		V_Error R_Logs;
		V_TabUsers T_Users;
		V_TabQuotaOpin T_QuotationsOpinions;
		E_TabUsersVide EXCEPTION;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Je démarre la restauration vers CB';
			V_Logs.LogWhere := 'RestoreCBLight.Restore';
			AddLogs(V_Logs);
			
			SELECT * BULK COLLECT INTO V_TabUsers
			FROM Users
			WHERE idUser IN
			(
				SELECT idUser
				FROM UsersToAdd
			)
			FOR UPDATE;
			
			IF(V_TabUsers.COUNT = 0) THEN
				RAISE E_TabUsersVide;
			END IF;					
			
			SELECT * BULK COLLECT INTO V_TabQuotaOpin
			FROM QuotationsOpinions
			WHERE (idUser, idFilm) IN
			(
				SELECT idUser, idFilm
				FROM QuotaOpinToAdd
			)
			FOR UPDATE;
      
			FOR i IN V_TabUsers.FIRST .. V_TabUsers.LAST LOOP
				INSERT INTO Users@CB VALUES V_TabUsers(i);
			END LOOP;
			
			FOR j IN V_TabQuotaOpin.FIRST .. V_TabQuotaOpin.LAST LOOP
				INSERT INTO QuotationsOpinions@CB VALUES V_TabQuotaOpin(j);
			END LOOP;
			
			DELETE FROM UsersToAdd;
			DELETE FROM QuotaOpinToAdd;
			
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Je fini la restauration vers CB';
			V_Logs.LogWhere := 'RestoreCBLight.Restore';
			AddLogs(V_Logs);

			COMMIT;
		EXCEPTION
			WHEN E_TabUsersVide THEN
				ROLLBACK;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := '-20005';
				V_Error.LogWhat := 'Il n''y a rien à restaurer vers CB.';
				V_Error.LogWhere := 'RestoreCBLight.Restore';
				AddLogs(V_Error);
			WHEN OTHERS THEN
				ROLLBACK;
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := SQLERRM;
				V_Error.LogWhere := 'RestoreCBLight.Restore';
				AddLogs(V_Error);
	END Restore;
END RestoreCBLight;
