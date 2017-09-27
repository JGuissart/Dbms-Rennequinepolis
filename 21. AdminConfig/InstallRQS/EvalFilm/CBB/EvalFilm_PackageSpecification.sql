create or replace PACKAGE EvalFilm AS 
	PROCEDURE AddQuotationOpinion(P_IDMOVIE IN QuotationsOpinions.IdMovie%TYPE, P_LOGIN IN QuotationsOpinions.Login%TYPE, P_QUOTATION IN QuotationsOpinions.Quotation%TYPE, P_OPINION IN QuotationsOpinions.Opinion%TYPE);
END EvalFilm;
/