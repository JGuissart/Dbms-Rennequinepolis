CREATE OR REPLACE TRIGGER USERS_IdUser BEFORE INSERT ON Users
FOR EACH ROW
	DECLARE
		E_InvalidDate EXCEPTION;
		V_Logs CB_RennequinepolisCBLight.R_Logs;
		V_Error CB_RennequinepolisCBLight.R_Logs;
	BEGIN
		IF(:NEW.DateOfBirth > TO_DATE(CURRENT_DATE, 'DD/MM/YY')) THEN
			RAISE E_InvalidDate;
		END IF;
		:NEW.idUser := CB_RennequinepolisCBLight.GenerateIdUser(:NEW.LastName, :NEW.FirstName, :NEW.DateOfBirth);
		V_Logs.LogWhen := CURRENT_DATE;
		V_Logs.ErrorCode := NULL;
		V_Logs.LogWhat := 'Génération de l''identifiant pour ' || :NEW.LastName || ' ' || :NEW.FirstName || ' : ' || :NEW.idUser;
		V_Logs.LogWhere := 'Trigger USERS_IdUser';
		CB_RennequinepolisCBLight.AddLogs(V_Logs);
	EXCEPTION
		WHEN E_InvalidDate THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := '-20002';
			V_Error.LogWhat := 'La date de naissance doit être plus petite que la date du jour.';
			V_Error.LogWhere := 'Trigger USERS_IdUser';
			CB_RennequinepolisCBLight.AddLogs(V_Error);
		WHEN OTHERS THEN
			V_Error.LogWhen := CURRENT_DATE;
			V_Error.ErrorCode := SQLCODE;
			V_Error.LogWhat := SQLERRM;
			V_Error.LogWhere := 'Trigger USERS_IdUser';
			CB_RennequinepolisCBLight.AddLogs(V_Error); 
	END;