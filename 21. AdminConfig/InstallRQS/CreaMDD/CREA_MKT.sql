DROP TABLE programmation;
DROP TABLE salle;
DROP TABLE complexe;
DROP TABLE movieActor;
DROP TABLE actor;
DROP TABLE moviePays;
DROP TABLE pays;
DROP TABLE movieGenre;
DROP TABLE genre;
DROP TABLE movie;
DROP TABLE Logs;
DROP SEQUENCE SEQLOGS;

CREATE SEQUENCE SEQLOGS;

CREATE TABLE Logs
(
	idLogs VARCHAR2(20) CONSTRAINT PKLogs PRIMARY KEY,
	LogWhen TIMESTAMP CONSTRAINT NN_LogsWhen NOT NULL,
	ErrorCode VARCHAR2(10),
	LogWhat VARCHAR2(4000) CONSTRAINT NN_LogsWhat NOT NULL, 
	Logwhere VARCHAR2(100) CONSTRAINT NN_LogsWhere NOT NULL
);

CREATE TABLE movie
(
	idMovie NUMBER CONSTRAINT PK_Movie PRIMARY KEY,
	coteMoy NUMBER NOT NULL 
);

CREATE TABLE genre
(
	idGenre NUMBER CONSTRAINT PK_Genre PRIMARY KEY,
	nom VARCHAR2(23) NOT NULL
);

CREATE TABLE movieGenre
(
	idMovie NUMBER CONSTRAINT FK_MovieGenre_idMovie REFERENCES movie(idMovie) ON DELETE CASCADE,
	idGenre NUMBER CONSTRAINT FK_MovieGenre_idGenre REFERENCES genre(idGenre) ON DELETE CASCADE,
	CONSTRAINT PK_MovieGenre PRIMARY KEY(idMovie,idGenre)
);

CREATE TABLE pays
(
	idPays NUMBER CONSTRAINT PK_Pays PRIMARY KEY,
	nom VARCHAR2(35) NOT NULL
);

CREATE TABLE moviePays
(
	idMovie NUMBER CONSTRAINT FK_MoviePays_idMovie REFERENCES movie(idMovie) ON DELETE CASCADE,
	idPays NUMBER CONSTRAINT FK_MoviePays_idGenre REFERENCES pays(idPays) ON DELETE CASCADE,
	CONSTRAINT PK_MoviePays PRIMARY KEY(idMovie,idPays)
);

CREATE TABLE actor
(
	idActor NUMBER CONSTRAINT PK_Actor PRIMARY KEY,
	nationalite VARCHAR2(35) NOT NULL
);

CREATE TABLE movieActor
(
	idMovie NUMBER CONSTRAINT FK_MovieActor_idMovie REFERENCES movie(idMovie) ON DELETE CASCADE,
	idActor NUMBER CONSTRAINT FK_MovieActor_idActor REFERENCES actor(idActor) ON DELETE CASCADE,
	CONSTRAINT PK_MovieActor PRIMARY KEY(idMovie,idActor)
);

CREATE TABLE complexe
(
	idComplexe VARCHAR2(100) CONSTRAINT PK_Complexe PRIMARY KEY
);

CREATE TABLE salle
(
	idSalle NUMBER CONSTRAINT PK_Salle PRIMARY KEY,
	placesTotales NUMBER NOT NULL,
	idComplexe VARCHAR2(100) CONSTRAINT FK_Salle_idComplexe REFERENCES complexe(idComplexe) ON DELETE CASCADE
);

CREATE TABLE programmation
(
	idMovie NUMBER CONSTRAINT FK_Programmation_idMovie REFERENCES movie(idMovie) ON DELETE CASCADE,
	debut TIMESTAMP NOT NULL,
	placesVendues NUMBER NOT NULL,
	idSalle NUMBER CONSTRAINT FK_Programmation_idSalle REFERENCES salle(idSalle) ON DELETE CASCADE,
	CONSTRAINT PK_programmation PRIMARY KEY(idMovie,idSalle)
);
