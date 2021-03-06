DROP TABLE MovieSpokenLanguages CASCADE CONSTRAINTS;
DROP TABLE SpokenLanguages CASCADE CONSTRAINTS;
DROP TABLE MovieProductionCountries CASCADE CONSTRAINTS;
DROP TABLE ProductionCountries CASCADE CONSTRAINTS;
DROP TABLE MovieProductionCompanies CASCADE CONSTRAINTS;
DROP TABLE ProductionCompanies CASCADE CONSTRAINTS;
DROP TABLE MovieDirector CASCADE CONSTRAINTS;
DROP TABLE MovieActor CASCADE CONSTRAINTS;
DROP TABLE People CASCADE CONSTRAINTS;
DROP TABLE MovieGenre CASCADE CONSTRAINTS;
DROP TABLE Genres CASCADE CONSTRAINTS;
DROP TABLE Copies CASCADE CONSTRAINTS;
DROP TABLE QuotationsOpinions CASCADE CONSTRAINTS;
DROP TABLE Movies CASCADE CONSTRAINTS;
DROP TABLE Posters CASCADE CONSTRAINTS;
DROP TABLE Users CASCADE CONSTRAINTS;
DROP TABLE Logs CASCADE CONSTRAINTS;
DROP SEQUENCE SEQLOGS;
DROP SEQUENCE SEQIDPOSTER;
DROP SEQUENCE SEQNUMCOPY;

CREATE SEQUENCE SEQNUMCOPY;
CREATE SEQUENCE SEQIDPOSTER;
CREATE SEQUENCE SEQLOGS;

CREATE TABLE Logs
(
	idLogs VARCHAR2(20) CONSTRAINT PKLogs PRIMARY KEY,
	LogWhen TIMESTAMP CONSTRAINT NN_LogsWhen NOT NULL,
	ErrorCode VARCHAR2(10),
	LogWhat VARCHAR2(4000) CONSTRAINT NN_LogsWhat NOT NULL, 
	Logwhere VARCHAR2(100) CONSTRAINT NN_LogsWhere NOT NULL
);

CREATE TABLE Users
(
	Login VARCHAR2(20) CONSTRAINT PK_Users PRIMARY KEY,
	Password VARCHAR2(20) CONSTRAINT NN_UsersPassword NOT NULL,
	LastName VARCHAR2(20) CONSTRAINT NN_Users_LastName NOT NULL,
	FirstName VARCHAR2(20) CONSTRAINT NN_Users_FirstName NOT NULL,
	DateOfBirth DATE CONSTRAINT NN_Users_DOB NOT NULL,
	Token VARCHAR2(2)
);

CREATE TABLE Posters
(
	idPoster NUMBER(7,0) CONSTRAINT PK_Affiche PRIMARY KEY,
	poster_path BLOB DEFAULT EMPTY_BLOB() CONSTRAINT NN_AfficheProfile NOT NULL
);

CREATE TABLE Movies
(
	idMovie VARCHAR2(6) CONSTRAINT PK_Movies PRIMARY KEY,
	title VARCHAR2(58 CHAR) CONSTRAINT NN_MoviesTitle NOT NULL,
	original_title VARCHAR2(59 CHAR) CONSTRAINT NN_MoviesOriginal NOT NULL,
	release_date DATE, -- Date inférieure à la date du jour.
	status VARCHAR2(15) CONSTRAINT CK_MoviesStatut CHECK(status IS NULL OR status IN('Post Production', 'Rumored', 'Released', 'In Production', 'Planned', 'Canceled')),
	vote_average NUMBER(3,1) CONSTRAINT CK_MoviesVote_average CHECK (vote_average BETWEEN 0 AND 10 AND vote_average IS NOT NULL),
	vote_count NUMBER(4,0) CONSTRAINT CK_MoviesVote_count CHECK (vote_count IS NOT NULL AND vote_count >= 0),
	runtime NUMBER(5,0) CONSTRAINT CK_MoviesRuntime CHECK (runtime > 0), 
	certification VARCHAR2(12),
	budget NUMBER(15,0) CONSTRAINT NN_MoviesBudget NOT NULL,
	revenue NUMBER(12,0) CONSTRAINT NN_MoviesRevenue NOT NULL,
	homepage VARCHAR2(122),
	tagline VARCHAR2(172 CHAR),
	overview VARCHAR2(949 CHAR),
	nombreCopies NUMBER CONSTRAINT CK_Movies_NombreCopies CHECK(nombreCopies IS NOT NULL AND nombreCopies > 0),
	idPoster NUMBER(7,0) CONSTRAINT FK_Movies_Posters REFERENCES Posters(idPoster),
	Token VARCHAR2(2)
);

CREATE TABLE QuotationsOpinions
(
	Login VARCHAR2(20) CONSTRAINT FK_QuotaOpin_Users REFERENCES Users(Login) ON DELETE CASCADE,
	idMovie VARCHAR2(6) CONSTRAINT FK_QuotaOpin_Movies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	Quotation NUMBER(2) CONSTRAINT CK_QuotaOpin_Quotation CHECK(Quotation >= 0 AND Quotation <= 10),
	Opinion VARCHAR2(100),
	DateOfPost TIMESTAMP CONSTRAINT NN_QuotaOpin_DateOfPost NOT NULL,
	Token VARCHAR2(8),
	CONSTRAINT PK_QuotationsOpinions PRIMARY KEY(Login, idMovie),
	CONSTRAINT CK_QuotationOpinion CHECK(Quotation IS NOT NULL OR Opinion IS NOT NULL)
);

CREATE TABLE Copies
(
	numCopy NUMBER CONSTRAINT CK_CopiesNumCopy CHECK(numCopy > 0),
	idMovie VARCHAR2(6) CONSTRAINT FK_Copies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	Token VARCHAR2(2),
	CONSTRAINT PK_Copies PRIMARY KEY(numCopy, idMovie)
);

CREATE TABLE Genres
(
	idGenre VARCHAR2(5) CONSTRAINT PK_Genres PRIMARY KEY,
	Name VARCHAR2(16 CHAR)
);

CREATE TABLE MovieGenre
(
	idMovie VARCHAR2(6) CONSTRAINT FK_MovieGenre_Movies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	idGenre VARCHAR2(5) CONSTRAINT FK_MovieGenre_Genres REFERENCES Genres(idGenre) ON DELETE CASCADE,
	CONSTRAINT PK_MovieGenre PRIMARY KEY (idMovie, idGenre)
);

CREATE TABLE People
(
	idPeople VARCHAR2(7) CONSTRAINT PK_People PRIMARY KEY,
	name VARCHAR2(22 CHAR) CONSTRAINT NN_PeopleName NOT NULL,
	idPoster NUMBER(7,0) CONSTRAINT FK_People_Affiche REFERENCES Posters(idPoster) ON DELETE CASCADE,
	Token VARCHAR2(2)
);

CREATE TABLE MovieActor
(
	idMovie VARCHAR2(6) CONSTRAINT FK_MovieActor_Movies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	idPeople VARCHAR2(7) CONSTRAINT FK_MovieActor_People REFERENCES People(idPeople) ON DELETE CASCADE,
	castId VARCHAR2(4) CONSTRAINT NN_MovieActorCastId NOT NULL,
	characterName VARCHAR2(36 CHAR),
	CONSTRAINT PK_MovieActor PRIMARY KEY (idMovie, idPeople, castId)
);

CREATE TABLE MovieDirector
(
	idMovie VARCHAR2(6) CONSTRAINT FK_MovieDirector_Movies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	idPeople VARCHAR2(7) CONSTRAINT FK_MovieDirector_People REFERENCES People(idPeople) ON DELETE CASCADE,
	CONSTRAINT PK_MovieDirector PRIMARY KEY (idMovie, idPeople)
);

CREATE TABLE ProductionCompanies
(
	idProductionCompany VARCHAR2(5) CONSTRAINT PK_ProductionsCompanies PRIMARY KEY,
	name VARCHAR2(44 CHAR) CONSTRAINT NN_PCName NOT NULL
);

CREATE TABLE MovieProductionCompanies
(
	idMovie VARCHAR2(6) CONSTRAINT FK_MPCompagnies_Movies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	idProductionCompany VARCHAR2(5) CONSTRAINT FK_MPC_ProductionCompanies REFERENCES ProductionCompanies(idProductionCompany) ON DELETE CASCADE,
	CONSTRAINT PK_MovieProductionCompanies PRIMARY KEY (idMovie, idProductionCompany)
);

CREATE TABLE ProductionCountries
(
	ISOProductionCountry VARCHAR2(2) CONSTRAINT PK_ProductionCountries PRIMARY KEY,
	name VARCHAR2(24 CHAR)
);

CREATE TABLE MovieProductionCountries
(
	idMovie VARCHAR2(6) CONSTRAINT FK_MPCountrie_Movies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	ISOProductionCountry VARCHAR2(2) CONSTRAINT FK_MPC_ProductionCountries REFERENCES ProductionCountries(ISOProductionCountry) ON DELETE CASCADE,
	CONSTRAINT PK_MovieProductionCountries PRIMARY KEY (idMovie, ISOProductionCountry)
);

CREATE TABLE SpokenLanguages
(
	ISOSpokenLanguage VARCHAR2(2) CONSTRAINT PK_Languages PRIMARY KEY,
	name VARCHAR2(16 CHAR)
);

CREATE TABLE MovieSpokenLanguages
(
	idMovie VARCHAR2(6) CONSTRAINT FK_MSL_Movies REFERENCES Movies(idMovie) ON DELETE CASCADE,
	ISOSpokenLanguage VARCHAR2(2) CONSTRAINT FK_MSL_SpokenLanguages REFERENCES SpokenLanguages(ISOSpokenLanguage) ON DELETE CASCADE,
	CONSTRAINT PK_MovieSpokenLanguages PRIMARY KEY (idMovie, ISOSpokenLanguage)
);