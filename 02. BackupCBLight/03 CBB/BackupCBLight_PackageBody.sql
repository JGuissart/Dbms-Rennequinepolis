CREATE OR REPLACE PACKAGE BODY BackupCBLight AS
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
				V_Error.LogWhere := 'BackupCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT;
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'BackupCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT; 
	END AddLogs;
	
	PROCEDURE InsertUserToAdd(P_IDUSER Users.IdUser%TYPE) AS
		V_Logs R_Logs;
		V_Error R_Logs;
		E_ParamaterNull EXCEPTION;
		BEGIN
			INSERT INTO UsersToAdd(idUser) VALUES(P_IDUSER);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'INSERT du tuple identifié par ' || P_IDUSER || ' dans la table UsersToAdd';
			V_Logs.LogWhere := 'BackupCBLight.InsertUserToAdd';
			AddLogs(V_Logs);
		EXCEPTION
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := SQLERRM;
				V_Error.LogWhere := 'BackupCBLight.InsertUserToAdd';
				AddLogs(V_Error); 
	END InsertUserToAdd;
	
	FUNCTION CheckUsersToAdd(P_USERID Users.idUser%TYPE) RETURN BOOLEAN	AS
		V_Logs R_Logs;
		V_Error R_Logs;
		V_UserId UsersToAdd.idUser%TYPE;
		BEGIN
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'Je vérifie si l''utilisateur devra être restauré sur CB';
			V_Logs.LogWhere := 'BackupCBLight.CheckUsersToAdd';
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
				V_Error.LogWhere := 'BackupCBLight.CheckUsersToAdd';
				AddLogs(V_Error);
	END CheckUsersToAdd;
END BackupCBLight;
