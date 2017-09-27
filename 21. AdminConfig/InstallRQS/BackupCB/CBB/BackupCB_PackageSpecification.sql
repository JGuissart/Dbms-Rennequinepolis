create or replace PACKAGE BackupCB AS
	FUNCTION CheckUserToReplicate(P_LOGIN IN Users.Login%TYPE) RETURN BOOLEAN;
END BackupCB;
/