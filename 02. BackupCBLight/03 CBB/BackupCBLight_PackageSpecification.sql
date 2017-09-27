CREATE OR REPLACE PACKAGE CBB_RennequinepolisCBLight AS
	/* TYPES RECORDS */
	
	type R_Logs IS RECORD
	(
		Id Logs.idLogs%TYPE,
		LogWhen Logs.LogWhen%TYPE,
		ErrorCode Logs.ErrorCode%TYPE,
		LogWhat Logs.LogWhat%TYPE,
		LogWhere Logs.LogWhere%TYPE
	);

	/* FONCTIONNALITES */ 
	
	PROCEDURE AddLogs(ElemToAdd IN R_Logs);
	PROCEDURE InsertUserToAdd(P_IDUSER Users.IdUser%TYPE);
	FUNCTION CheckUsersToAdd(P_USERID Users.idUser%TYPE) RETURN BOOLEAN;
END CBB_RennequinepolisCBLight;