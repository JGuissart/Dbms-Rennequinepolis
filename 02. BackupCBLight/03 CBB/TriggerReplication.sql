CREATE OR REPLACE TRIGGER ReplicationSync_BackupCBLight BEFORE INSERT OR UPDATE OR DELETE OF Quotation, Opinion ON QuotationsOpinions
FOR EACH ROW
WHEN (NEW.Token IS NULL) -- LOCAL UPDATE => REPLICATE
DECLARE
	V_Logs BackupCBLight.R_Logs;
	V_FuncReturn BOOLEAN;
BEGIN
	:NEW.Token := 'FROM_REP';
	BackupCBLight.VerificationQuotationOpinion(:NEW.Quotation, :NEW.Opinion);
	V_FuncReturn := BackupCBLight.CheckUsersToAdd(:NEW.idUser);
	
	IF(V_FuncReturn = TRUE) THEN -- Si la fonction a retourné TRUE, on ne réplique pas via le trigger ! Ce sera restauré via la procédure RESTORE
		IF INSERTING THEN
			INSERT INTO QuotaOpinToAdd(idUser, idFilm) VALUES(:NEW.idUser, :NEW.idFilm);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'INSERT le tuple identifié par le couple idUser/idFilm ' || :OLD.idUser || '/' || :OLD.idFilm || ' dans la table QuotaOpinToAdd';
			V_Logs.LogWhere := 'Trigger ReplicationSync_BackupCBLight';
		END IF;
		IF DELETING THEN
			DELETE FROM QuotaOpinToAdd WHERE idUser = :OLD.idUser AND idFilm = :OLD.idFilm;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'DELETE du tuple identifié par le couple idUser/idFilm ' || :OLD.idUser || '/' || :OLD.idFilm || ' de la table QuotaOpinToAdd';
			V_Logs.LogWhere := 'Trigger ReplicationSync_BackupCBLight';
		END IF; 
	ELSE
		IF INSERTING THEN
			INSERT INTO QuotationsOpinions@CB VALUES(:NEW.idUser, :NEW.idFilm, :NEW.Quotation, :NEW.Opinion, :NEW.DateOfPost, :NEW.Token);
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'INSERT le tuple identifié par le couple idUser/idFilm ' || :OLD.idUser || '/' || :OLD.idFilm || ' dans la table QuotationsOpinions de CBB';
			V_Logs.LogWhere := 'Trigger ReplicationSync_BackupCBLight';
		END IF;
		IF UPDATING THEN
			UPDATE QuotationsOpinions@CB
			SET Quotation = :NEW.Quotation,	Opinion = :NEW.Opinion, Token = :NEW.Token
			WHERE idUser = :OLD.idUser AND idFilm = :OLD.idFilm;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'UPDATE du tuple identifié par le couple idUser/idFilm ' || :OLD.idUser || '/' || :OLD.idFilm || ' de la table QuotationsOpinions de CBB';
			V_Logs.LogWhere := 'Trigger ReplicationSync_BackupCBLight';
		END IF;
		IF DELETING THEN
			DELETE FROM QuotationsOpinions@CB WHERE idUser = :OLD.idUser AND idFilm = :OLD.idFilm;
			V_Logs.LogWhen := CURRENT_DATE;
			V_Logs.ErrorCode := NULL;
			V_Logs.LogWhat := 'DELETE du tuple identifié par le couple idUser/idFilm ' || :OLD.idUser || '/' || :OLD.idFilm || ' de la table QuotationsOpinions de CBB';
			V_Logs.LogWhere := 'Trigger ReplicationSync_BackupCBLight';
		END IF; 
	END IF;
	CBB_RennequinepolisCBLight.AddLogs(V_Logs);
	:NEW.token := NULL;
END;