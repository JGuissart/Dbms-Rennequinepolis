CREATE OR REPLACE PACKAGE BODY CBB_RennequinepolisCBLight AS
	PROCEDURE AddLogs(ElemToAdd IN R_Logs) AS
		PRAGMA AUTONOMOUS_TRANSACTION ; -- Procédure autonome niveau transactionnel
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
				V_Error.LogWhere := 'CBB_RennequinepolisCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT;
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'CBB_RennequinepolisCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT; 
	END AddLogs;
	
	FUNCTION GenerateIdUser(P_LASTNAME Users.LastName%TYPE, P_FIRSTNAME Users.FirstName%TYPE, P_DOB Users.DateOfBirth%TYPE) RETURN Users.idUser%TYPE AS
		V_Matricule Users.idUser%TYPE;
		V_Error R_Logs;
		BEGIN
			V_Matricule := TO_CHAR(P_DOB, 'YYMMDD') || UPPER(SUBSTR(P_LASTNAME, 1, 3)) || UPPER(SUBSTR(P_FIRSTNAME, 1, 3));
			RETURN V_Matricule;
		EXCEPTION
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'CBB_RennequinepolisCBLight.AddLogs';
				AddLogs(V_Error);
				RETURN NULL;
	END GenerateIdUser;
	
	PROCEDURE VerificationQuotationOpinion(P_QUOTA QuotationsOpinions.Quotation%TYPE, P_OPIN QuotationsOpinions.Opinion%TYPE) AS
		E_QuotaOpinNull EXCEPTION;
		V_Logs R_Logs;
		V_Error R_Logs;
		BEGIN
			IF (P_QUOTA IS NULL AND P_OPIN IS NULL) THEN
			RAISE E_QuotaOpinNull;
		END IF;
		V_Logs.LogWhen := CURRENT_DATE;
		V_Logs.ErrorCode := NULL;
		V_Logs.LogWhat := 'Vérification de la cote et de l''avis effectué.';
		V_Logs.LogWhere := 'CBB_RennequinepolisCBLight.VerificationQuotationOpinion';
		AddLogs(V_Logs);
	EXCEPTION
		WHEN E_QuotaOpinNull THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := '-20003';
			V_Error.LogWhat := 'Il faut encoder un avis ou une cote ou les 2.';
			V_Error.LogWhere := 'CBB_RennequinepolisCBLight.VerificationQuotationOpinion';
			AddLogs(V_Error);
		WHEN OTHERS THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := SQLERRM;
			V_Error.LogWhere := 'CBB_RennequinepolisCBLight.VerificationQuotationOpinion';
			AddLogs(V_Error);
	END VerificationQuotationOpinion;
END CBB_RennequinepolisCBLight;
