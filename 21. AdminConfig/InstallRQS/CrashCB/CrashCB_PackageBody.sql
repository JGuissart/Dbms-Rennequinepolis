create or replace PACKAGE BODY CrashCB AS
	------------ GetInfos ------------------------------------------------------------
	-- *** IN : VARCHAR2
	-- *** OUT : /
	-- *** PROCESS : Récupère dans un tableau associatif tous les SID et serial# pour un username donné
	---------------------------------------------------------------------------------------------------------
	PROCEDURE GetInfos(P_USERNAME IN VARCHAR2) AS
    V_Tab T_CRASH;
		BEGIN
			SELECT s.sid, s.serial# BULK COLLECT INTO V_Tab
			FROM gv$session s JOIN gv$process p ON (p.addr = s.paddr AND p.inst_id = s.inst_id)
			WHERE s.type != 'BACKGROUND ' AND s.username = P_USERNAME;
			DisconnectSession(P_USERNAME, V_Tab);
	END GetInfos;
	
	------------ DisconnectSession ------------------------------------------------------------
	-- *** IN : VARCHAR2, T_CRASH
	-- *** OUT : /
	-- *** PROCESS : kill les sessions en fonction des SID et serial# passé en paramètre dans le tableau
	---------------------------------------------------------------------------------------------------------
	
	PROCEDURE DisconnectSession(P_USERNAME IN VARCHAR2, P_TABCRASH T_CRASH) AS
		V_InstructionDynamique VARCHAR2(512);
		BEGIN
			IF(P_TABCRASH.COUNT <> 0) THEN
				FOR i IN P_TABCRASH.FIRST .. P_TABCRASH.LAST LOOP
					V_InstructionDynamique := 'ALTER SYSTEM DISCONNECT SESSION ''' || P_TABCRASH(i).SID || ',' || P_TABCRASH(i).SERIALNUMBER || ''' IMMEDIATE';
					EXECUTE IMMEDIATE(V_InstructionDynamique);
					DBMS_OUTPUT.PUT_LINE('DisconnectSession OK');
					LockAccount(P_USERNAME);
				END LOOP;
			END IF;
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
	END DisconnectSession;
	
	------------ LockAccount ------------------------------------------------------------
	-- *** IN : VARCHAR2
	-- *** OUT : /
	-- *** PROCESS : vérouille le compte passé en paramètre
	---------------------------------------------------------------------------------------------------------
	
	PROCEDURE LockAccount(P_USERNAME IN VARCHAR2) AS
		V_InstructionDynamique VARCHAR2(512);
		BEGIN
			V_InstructionDynamique := 'ALTER USER ' || P_USERNAME || ' ACCOUNT LOCK';
			EXECUTE IMMEDIATE(V_InstructionDynamique);
			DBMS_OUTPUT.PUT_LINE('LockAccount OK');
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
	END LockAccount;
	
	------------ UnlockAccount ------------------------------------------------------------
	-- *** IN : VARCHAR2
	-- *** OUT : /
	-- *** PROCESS : déverouille le compte passé en paramètre
	---------------------------------------------------------------------------------------------------------
  
	PROCEDURE UnlockAccount(P_USERNAME IN VARCHAR2) AS
		V_InstructionDynamique VARCHAR2(512);
		BEGIN
			V_InstructionDynamique := 'ALTER USER ' || P_USERNAME || ' ACCOUNT UNLOCK';
			EXECUTE IMMEDIATE(V_InstructionDynamique);
			DBMS_OUTPUT.PUT_LINE('UnlockAccount OK');
		EXCEPTION
			WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
	END UnlockAccount;
END CrashCB;
/