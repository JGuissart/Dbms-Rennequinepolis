CREATE OR REPLACE TRIGGER QuotationsOpinionsQuotaOpin BEFORE INSERT ON QuotationsOpinions
FOR EACH ROW
	DECLARE
		E_QuotaOpinNull EXCEPTION;
		V_Logs CB_RennequinepolisCBLight.R_Logs;
		V_Error CB_RennequinepolisCBLight.R_Logs;
	BEGIN
		IF (:NEW.Quotation IS NULL AND :NEW.Opinion IS NULL) THEN
			RAISE E_QuotaOpinNull;
		END IF;
		V_Logs.LogWhen := CURRENT_DATE;
		V_Logs.ErrorCode := NULL;
		V_Logs.LogWhat := 'Vérification de la cote et de l''avis effectué.';
		V_Logs.LogWhere := 'Trigger QuotationsOpinionsQuotaOpin';
		CB_RennequinepolisCBLight.AddLogs(V_Logs);
	EXCEPTION
		WHEN E_QuotaOpinNull THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := '-20003';
			V_Error.LogWhat := 'Il faut encoder un avis ou une cote ou les 2.';
			V_Error.LogWhere := 'Trigger QuotationsOpinionsQuotaOpin';
			CB_RennequinepolisCBLight.AddLogs(V_Error);
		WHEN OTHERS THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := SQLERRM;
			V_Error.LogWhere := 'Trigger QuotationsOpinionsQuotaOpin';
			CB_RennequinepolisCBLight.AddLogs(V_Error);
	END;