create or replace PACKAGE BODY BackupCB AS
	------------ CheckUserToReplicate ------------------------------------------------------------
	-- *** IN : Users.Login%TYPE
	-- *** OUT : /
	-- *** PROCESS : vérifie si l'utilisateur a déjà été répliqué sur CB ou non
	---------------------------------------------------------------------------------------------------------
	FUNCTION CheckUserToReplicate(P_LOGIN IN Users.Login%TYPE) RETURN BOOLEAN AS
		V_User Users%ROWTYPE;
		BEGIN
			SELECT * INTO V_User
			FROM Users@CB
			WHERE Login = P_LOGIN;
			
			RETURN TRUE;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN FALSE;
			WHEN OTHERS THEN
				AddLogs('OTHERS : ' || SQLERRM, 'BackupCB.CheckUserToReplicate', SQLCODE);
	END CheckUserToReplicate;
END BackupCB;