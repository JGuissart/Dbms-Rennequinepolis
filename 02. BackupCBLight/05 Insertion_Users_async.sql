-- Utilisateurs à ajouter pour test réplication asynchrone (dans CB)
INSERT INTO Users (LastName, FirstName, DateOfBirth) VALUES('Anzardi', 'David', TO_DATE('09/10/1991', 'dd/mm/yyyy'));
INSERT INTO Users (LastName, FirstName, DateOfBirth) VALUES('Closset', 'Audrey', TO_DATE('01/06/1995', 'dd/mm/yyyy'));
INSERT INTO Users (LastName, FirstName, DateOfBirth) VALUES('Modave', 'Regis', TO_DATE('18/10/1991', 'dd/mm/yyyy'));
COMMIT;