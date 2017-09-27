INSERT INTO Users@CBB SELECT * FROM Users;
INSERT INTO Posters@CBB SELECT * FROM Posters;
INSERT INTO Movies@CBB SELECT * FROM Movies;
INSERT INTO Copies@CBB SELECT * FROM Copies;
INSERT INTO Genres@CBB SELECT * FROM Genres;
INSERT INTO MovieGenre@CBB SELECT * FROM MovieGenre;
INSERT INTO ProductionCompanies@CBB SELECT * FROM ProductionCompanies;
INSERT INTO MovieProductionCompanies@CBB SELECT * FROM MovieProductionCompanies;
INSERT INTO ProductionCountries@CBB SELECT * FROM ProductionCountries;
INSERT INTO MovieProductionCountries@CBB SELECT * FROM MovieProductionCountries;
INSERT INTO SpokenLanguages@CBB SELECT * FROM SpokenLanguages;
INSERT INTO MovieSpokenLanguages@CBB SELECT * FROM MovieSpokenLanguages;
INSERT INTO People@CBB SELECT *	FROM People;
INSERT INTO MovieActor@CBB SELECT * FROM MovieActor;
INSERT INTO MovieDirector@CBB SELECT * FROM MovieDirector;
INSERT INTO QuotationsOpinions@CBB SELECT * FROM QuotationsOpinions;
	
COMMIT;