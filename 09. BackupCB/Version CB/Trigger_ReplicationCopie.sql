create or replace TRIGGER ReplicationCopie BEFORE INSERT ON Copies
FOR EACH ROW
WHEN(NEW.Token IS NULL) -- Token null => la copie du film n'a pas encore été répliquée sur CBB
	DECLARE
		V_CheckMovie BOOLEAN;
	BEGIN
		V_CheckMovie := BackupCB.CheckUserToReplicate(:NEW.idMovie);
		AddLogs('Début réplication de la copie ' || :NEW.NumCopy || ' pour le film ' || :NEW.idMovie, 'Trigger ReplicationCopie', NULL);
		IF(V_CheckMovie = TRUE) THEN
			:NEW.Token := 'OK';
			INSERT INTO Copies@CBB VALUES (:NEW.NumCopy, :NEW.idMovie, :NEW.Token);
		ELSE
			:NEW.Token := 'KO';
		END IF;
		AddLogs('Fin réplication de la copie ' || :NEW.NumCopy || ' pour le film ' || :NEW.idMovie, 'Trigger ReplicationCopie', NULL);
	EXCEPTION
		WHEN OTHERS THEN
			AddLogs(SQLERRM, 'Trigger ReplicationCopie', SQLCODE);
			RAISE;
	END;