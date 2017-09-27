create or replace PACKAGE BackupCB AS
	FUNCTION CheckUserToReplicate(P_LOGIN IN Users.Login%TYPE) RETURN BOOLEAN;
	FUNCTION CheckMovieToReplicate(P_IDMOVIE IN Movies.IdMovie%TYPE) RETURN BOOLEAN;
	PROCEDURE Job_ReplicationAsync;
END BackupCB;