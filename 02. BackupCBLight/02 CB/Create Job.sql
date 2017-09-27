BEGIN
dbms_scheduler.create_job
(
   job_name           =>  'ReplicationAsynchrone',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'BackupCBLight.Job_ReplicationAsync',
   start_date         =>  TO_TIMESTAMP_TZ('2015-10-19 21:18:17 UTC','YYYY-MM-DD HH24.MI.SS TZR'),
   repeat_interval    =>  'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0',
   enabled            =>  TRUE
);
END;
/