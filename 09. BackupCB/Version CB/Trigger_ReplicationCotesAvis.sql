create or replace TRIGGER ReplicationCotesAvis BEFORE INSERT OR UPDATE OR DELETE OF Quotation, Opinion ON QuotationsOpinions
FOR EACH ROW
WHEN (NEW.Token IS NULL) -- Token null => la cote et/ou l'avis du film n'a pas encore été répliquée sur CBB
	DECLARE
		V_CheckUser BOOLEAN;
	BEGIN
		:NEW.Token := 'OK';
		V_CheckUser := BackupCB.CheckUserToReplicate(:NEW.Login);
		AddLogs('Début réplication des cotes et avis de "' || :NEW.Login || '" pour le film ' || :NEW.idMovie, 'Trigger ReplicationCotesAvis', NULL);
		IF(V_CheckUser = TRUE) THEN -- Si la fonction a retourné TRUE, on réplique via le trigger
			IF INSERTING THEN
				INSERT INTO QuotationsOpinions@CBB VALUES(:NEW.Login, :NEW.idMovie, :NEW.Quotation, :NEW.Opinion, :NEW.DateOfPost, :NEW.Token);
				AddLogs('INSERT le tuple identifié par le couple Login/IdMovie ' || :OLD.Login || '/' || :OLD.idMovie || ' dans la table QuotationsOpinions de CBB', 'Trigger ReplicationCotesAvis', NULL);
			END IF;
			IF UPDATING THEN
				UPDATE QuotationsOpinions@CBB
				SET Quotation = :NEW.Quotation,	Opinion = :NEW.Opinion, Token = :NEW.Token
				WHERE Login = :OLD.Login AND idMovie = :OLD.idMovie;
				AddLogs('UPDATE le tuple identifié par le couple Login/IdMovie ' || :OLD.Login || '/' || :OLD.idMovie || ' dans la table QuotationsOpinions de CBB', 'Trigger ReplicationCotesAvis', NULL);
			END IF;
			IF DELETING THEN
				DELETE FROM QuotationsOpinions@CBB WHERE Login = :OLD.Login AND idMovie = :OLD.idMovie;
				AddLogs('DELETE le tuple identifié par le couple Login/IdMovie ' || :OLD.Login || '/' || :OLD.idMovie || ' dans la table QuotationsOpinions de CBB', 'Trigger ReplicationCotesAvis', NULL);
			END IF; 
		ELSE -- Sinon, la cote et/ou l'avis sera répliqué via le job
			UPDATE QuotationsOpinions
			SET Token = 'KO'
			WHERE Login = :NEW.Login AND IdMovie = :NEW.IdMovie;
		END IF;
		AddLogs('Fin réplication des cotes et avis de "' || :NEW.Login || '" pour le film ' || :NEW.idMovie, 'Trigger ReplicationCotesAvis', NULL);
	EXCEPTION
		WHEN OTHERS THEN
			AddLogs('OTHERS : ' || SQLERRM, 'BackupCB.Job_ReplicationAsyncn', SQLCODE);
END;