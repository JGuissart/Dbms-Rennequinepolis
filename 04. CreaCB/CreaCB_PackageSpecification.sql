CREATE OR REPLACE PACKAGE STATMOVIES AS 
	TYPE R_Stat IS RECORD
	(
		Moyenne NUMBER(5,0),
		Ecart NUMBER(5,0),
		Median NUMBER(5,0),
		TailleMin NUMBER(5,0),
		TailleMax NUMBER(5,0),
		CountValeur NUMBER(7,0),
		CountNotNull NUMBER(7,0),
		CountNull NUMBER (7,0),
		CountZero NUMBER (7,0),
		q99 NUMBER(7,0),
		q9999 NUMBER(7,0)
	);

	type R_Logs IS RECORD
	(
		Id Logs.idLogs%TYPE,
		LogWhen Logs.LogWhen%TYPE,
		ErrorCode Logs.ErrorCode%TYPE,
		LogWhat Logs.LogWhat%TYPE,
		LogWhere Logs.LogWhere%TYPE
	);

	TYPE T_TabElement IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
	TYPE vc_arr IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
	TYPE T_TabGenres IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
	TYPE T_TabDirector IS TABLE OF VARCHAR(4000) INDEX BY BINARY_INTEGER;
	TYPE T_TabActor IS TABLE OF VARCHAR(4000) INDEX BY BINARY_INTEGER;
	TYPE T_TabProductionCompanies IS TABLE OF VARCHAR(4000) INDEX BY BINARY_INTEGER;
	TYPE T_TabProductionCountries IS TABLE OF VARCHAR(4000) INDEX BY BINARY_INTEGER;
	TYPE T_TabSpokenLanguages IS TABLE OF VARCHAR(4000) INDEX BY BINARY_INTEGER;

	PROCEDURE GENSTAT(P_Stat OUT R_Stat, P_TabElement OUT T_TabElement);
	PROCEDURE ECRITURECOURT(Label VARCHAR2 ,P_Stat IN R_Stat);
	PROCEDURE ECRITURELONG(Label VARCHAR2 ,P_Stat IN R_Stat, P_TabElement IN T_TabElement);
	PROCEDURE get_movie_genres(P_TabIdGenres IN OUT NESTEDCHAR, P_TabNameGenres IN OUT NESTEDCHAR);
	PROCEDURE get_movie_director(P_TabIdDirector  IN OUT NESTEDCHAR, P_TabNameDirector IN OUT NESTEDCHAR, P_TabPathDirector IN OUT NESTEDCHAR);
	PROCEDURE get_movie_actor(P_TabIdActor IN OUT NESTEDCHAR, P_TabNameActor IN OUT NESTEDCHAR, P_TabCastIdActor IN OUT NESTEDCHAR, P_TabCharacterActor IN OUT NESTEDCHAR, P_TabPathProfileActor IN OUT NESTEDCHAR);
	PROCEDURE get_movie_productionCompanies(P_TabIdProduction  IN OUT NESTEDCHAR, P_TabNameProduction IN OUT NESTEDCHAR);
	PROCEDURE get_movie_productionCountries(P_TabISOCountry IN OUT NESTEDCHAR, P_TabNameCountry IN OUT NESTEDCHAR);
	PROCEDURE get_movie_spokenLanguages(P_TabISOSpokenLanguages IN OUT NESTEDCHAR, P_TabNameSpokenLanguages IN OUT NESTEDCHAR);
	PROCEDURE AddLogs(ElemToAdd IN R_Logs);
END STATMOVIES;