CREATE OR REPLACE PACKAGE RestoreCBLight AS
	/* TYPES RECORDS */
	
	type R_Logs IS RECORD
	(
		Id Logs.idLogs%TYPE,
		LogWhen Logs.LogWhen%TYPE,
		ErrorCode Logs.ErrorCode%TYPE,
		LogWhat Logs.LogWhat%TYPE,
		LogWhere Logs.LogWhere%TYPE
	);
	
	/* TYPES TABLEAUX */
  
	TYPE T_Users IS TABLE OF Users%ROWTYPE INDEX BY PLS_INTEGER;
	TYPE T_QuotationsOpinions IS TABLE OF QuotationsOpinions%ROWTYPE INDEX BY PLS_INTEGER;

	/* FONCTIONNALITES */ 
	
	PROCEDURE AddLogs(ElemToAdd IN R_Logs);
	FUNCTION GenerateIdUser(P_LASTNAME Users.LastName%TYPE, P_FIRSTNAME Users.FirstName%TYPE, P_DOB Users.DateOfBirth%TYPE) RETURN Users.idUser%TYPE;
	PROCEDURE VerificationQuotationOpinion(P_QUOTA QuotationsOpinions.Quotation%TYPE, P_OPIN QuotationsOpinions.Opinion%TYPE);
	PROCEDURE InsertUserToAdd(P_IDUSER Users.IdUser%TYPE);
	FUNCTION CheckUsersToAdd(P_USERID Users.idUser%TYPE) RETURN BOOLEAN;
	PROCEDURE Restore;
END RestoreCBLight;