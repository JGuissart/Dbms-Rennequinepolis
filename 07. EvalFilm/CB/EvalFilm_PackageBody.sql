CREATE OR REPLACE PACKAGE BODY EvalFilm AS
	------------ AddQuotationOpinion ------------------------------------------------------------
	-- *** IN : QuotationsOpinions.IdMovie%TYPE, QuotationsOpinions.Login%TYPE, QuotationsOpinions.Quotation%TYPE, QuotationsOpinions.Opinion%TYPE
	-- *** OUT : /
	-- *** PROCESS : Insert une cote et/ou un avis (ou met à jour s'il en existe déjà une) pour un film et un utilisateur
	---------------------------------------------------------------------------------------------------------
	PROCEDURE AddQuotationOpinion(P_IDMOVIE IN QuotationsOpinions.IdMovie%TYPE, P_LOGIN IN QuotationsOpinions.Login%TYPE, P_QUOTATION IN QuotationsOpinions.Quotation%TYPE, P_OPINION IN QuotationsOpinions.Opinion%TYPE) AS
		BEGIN
			AddLogs('Début procédure AddQuotationOpinion', 'EvalFilm.AddQuotationOpinion', NULL);
			MERGE INTO QuotationsOpinions qo
			USING 
			(SELECT P_IDMOVIE col_idMovie, P_LOGIN col_login, P_QUOTATION col_cote, P_OPINION col_avis FROM DUAL)
			ON (qo.idMovie = col_idMovie AND qo.Login = col_login)
			WHEN MATCHED THEN
				UPDATE SET qo.Quotation = col_cote, qo.Opinion = col_avis, Token = NULL
			WHEN NOT MATCHED THEN
				INSERT VALUES (col_login, col_idMovie, col_cote, col_avis, CURRENT_DATE, NULL);

			COMMIT;
			AddLogs('Fin procédure AddQuotationOpinion', 'EvalFilm.AddQuotationOpinion', NULL);
		EXCEPTION
			WHEN OTHERS THEN
				AddLogs('OTHERS : ' || SQLERRM, 'EvalFilm.AddQuotationOpinion', SQLCODE);
	END AddQuotationOpinion;
END EvalFilm;