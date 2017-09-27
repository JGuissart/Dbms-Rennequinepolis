CREATE SEQUENCE SEQLOGS;
BEGIN
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
	SCHEMAURL => 'http://XSD/movies.xsd',
	SCHEMADOC => BFILENAME('REPXML', 'XSD/movies.xsd'),
	LOCAL => TRUE, GENTYPES => TRUE, GENTABLES => FALSE,
	CSID => NLS_CHARSET_ID('AL32UTF8'));
END;
/

CREATE TABLE Movies OF XMLTYPE
XMLTYPE STORE AS OBJECT RELATIONAL
XMLSCHEMA "http://XSD/movies.xsd"
ELEMENT "movies"
VARRAY "XMLDATA"."LIST_GENRE"."GENRE"
	STORE AS TABLE GENRES ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)))
VARRAY "XMLDATA"."LIST_PRODUCTIONS"."PRODUCTION"
	STORE AS TABLE PRODUCTIONS ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)))
VARRAY "XMLDATA"."LIST_COUNTRIES"."COUNTRY"
	STORE AS TABLE COUNTRIES ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)))
VARRAY "XMLDATA"."LIST_ACTORS"."ACTOR"
	STORE AS TABLE ACTORS ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)))
VARRAY "XMLDATA"."LIST_DIRECTORS"."DIRECTOR"
	STORE AS TABLE DIRECTORS ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)))
VARRAY "XMLDATA"."LIST_LANGUAGES"."LANGUAGE"
	STORE AS TABLE LANGUAGES ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)))
VARRAY "XMLDATA"."LIST_OPINIONS"."OPINION"
	STORE AS TABLE OPINIONS ((PRIMARY KEY (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$)));

BEGIN
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
	SCHEMAURL => 'http://XSD/archives.xsd',
	SCHEMADOC => BFILENAME('REPXML', 'XSD/archives.xsd'),
	LOCAL => TRUE, GENTYPES => TRUE, GENTABLES => FALSE,
	CSID => NLS_CHARSET_ID('AL32UTF8'));
END;
/

CREATE TABLE Archives OF XMLTYPE
XMLTYPE STORE AS OBJECT RELATIONAL
XMLSCHEMA "http://XSD/archives.xsd"
ELEMENT "archives";

BEGIN
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
	SCHEMAURL => 'http://XSD/copies.xsd',
	SCHEMADOC => BFILENAME('REPXML', 'XSD/copies.xsd'),
	LOCAL => TRUE, GENTYPES => TRUE, GENTABLES => FALSE,
	CSID => NLS_CHARSET_ID('AL32UTF8'));
END;
/

CREATE TABLE Copies OF XMLTYPE
XMLTYPE STORE AS OBJECT RELATIONAL
XMLSCHEMA "http://XSD/copies.xsd"
ELEMENT "copies";

BEGIN
	DBMS_XMLSCHEMA.REGISTERSCHEMA(
	SCHEMAURL => 'http://XSD/projections.xsd',
	SCHEMADOC => BFILENAME('REPXML', 'XSD/projections.xsd'),
	LOCAL => TRUE, GENTYPES => TRUE, GENTABLES => FALSE,
	CSID => NLS_CHARSET_ID('AL32UTF8'));
END;
/

CREATE TABLE Projections OF XMLTYPE
XMLTYPE STORE AS OBJECT RELATIONAL
XMLSCHEMA "http://XSD/projections.xsd"
ELEMENT "projections";

CREATE TABLE CopyTmp (xml_col XMLTYPE)
XMLTYPE xml_col STORE AS BINARY XML;

CREATE TABLE Logs
(
	idLogs VARCHAR2(20) CONSTRAINT PKLogs PRIMARY KEY,
	LogWhen TIMESTAMP CONSTRAINT NN_LogsWhen NOT NULL,
	ErrorCode VARCHAR2(10),
	LogWhat VARCHAR2(4000) CONSTRAINT NN_LogsWhat NOT NULL, 
	Logwhere VARCHAR2(100) CONSTRAINT NN_LogsWhere NOT NULL
);


--Clé primaire
ALTER TABLE Archives ADD CONSTRAINT PKArchives PRIMARY KEY(XMLDATA."IDMOVIE");
ALTER TABLE Copies ADD CONSTRAINT PKCopies PRIMARY KEY(XMLDATA."NUMCOPY", XMLDATA."IDMOVIE");
ALTER TABLE Movies ADD CONSTRAINT PKMovies PRIMARY KEY(XMLDATA."IDMOVIE");
ALTER TABLE Projections ADD CONSTRAINT PKProjections PRIMARY KEY(XMLDATA."IDMOVIE",XMLDATA."NUMCOPY",XMLDATA."DEBUT");


--Clé étrangère
ALTER TABLE Archives ADD CONSTRAINT FKArchives FOREIGN KEY (XMLDATA."IDMOVIE") REFERENCES Movies (XMLDATA."IDMOVIE");
ALTER TABLE Copies ADD CONSTRAINT FKCopies FOREIGN KEY (XMLDATA."IDMOVIE") REFERENCES Movies (XMLDATA."IDMOVIE");
ALTER TABLE Projections ADD CONSTRAINT FKProjectionMo FOREIGN KEY (XMLDATA."IDMOVIE") REFERENCES Movies(XMLDATA."IDMOVIE");

COMMIT;