-- Cotes/avis à ajouter pour test réplication asynchrone (dans CB)
INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, idUser, idFilm) VALUES(NULL, 'Le film le plus naze que j''ai jamais vu ...', CURRENT_DATE, '911009ANZDAV', 104);
INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, idUser, idFilm) VALUES(NULL, 'Génial :)', CURRENT_DATE, '950601CLOAUD', 204);
INSERT INTO QuotationsOpinions (Quotation, Opinion, DateOfPost, idUser, idFilm) VALUES(NULL, 'Ce film ne casse pas trois pattes à un canard ...', CURRENT_DATE, '911018MODREG', 304);
COMMIT;