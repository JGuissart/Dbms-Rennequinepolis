CREATE OR REPLACE PACKAGE BackupCBLight AS
	TYPE R_Logs IS RECORD
	(
		Id Logs.idLogs%TYPE,
		LogWhen Logs.LogWhen%TYPE,
		ErrorCode Logs.ErrorCode%TYPE,
		LogWhat Logs.LogWhat%TYPE,
		LogWhere Logs.LogWhere%TYPE
	);
	
	PROCEDURE AddLogs(ElemToAdd IN R_Logs);
	PROCEDURE InsertUserToAdd(P_IDUSER Users.IdUser%TYPE);
	FUNCTION CheckUsersToAdd(P_USERID Users.idUser%TYPE) RETURN BOOLEAN;
	PROCEDURE Job_ReplicationAsync;
END BackupCBLight;