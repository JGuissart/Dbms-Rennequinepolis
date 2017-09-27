BEGIN
	DBMS_SCHEDULER.CREATE_JOB
	(
		JOB_NAME => 'ReplicationAsynchrone',
		JOB_TYPE => 'STORED_PROCEDURE',
		JOB_ACTION => 'BackupCB.Job_ReplicationAsync',
		START_DATE => SYSTIMESTAMP,
		REPEAT_INTERVAL => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0;',
		ENABLED => TRUE,
		COMMENTS => 'Backup des nouveaux utilisateurs et leurs évaluations du jour de leur création.'
	);
EXCEPTION
	WHEN OTHERS THEN
		AddLogs(SQLERRM, 'CREATE JOB', SQLCODE);
END;
/