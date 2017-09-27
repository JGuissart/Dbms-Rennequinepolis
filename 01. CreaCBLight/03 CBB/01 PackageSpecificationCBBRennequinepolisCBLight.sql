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
	FUNCTION GenerateIdUser(P_LASTNAME Users.LastName%TYPE, P_FIRSTNAME Users.FirstName%TYPE, P_DOB Users.DateOfBirth%TYPE) RETURN Users.idUser%TYPE;
	PROCEDURE VerificationQuotationOpinion(P_QUOTA QuotationsOpinions.Quotation%TYPE, P_OPIN QuotationsOpinions.Opinion%TYPE);
END CBB_RennequinepolisCBLight;