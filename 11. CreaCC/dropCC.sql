DROP TABLE Copies CASCADE CONSTRAINTS;
DROP TABLE Projections CASCADE CONSTRAINTS;
DROP TABLE Archives CASCADE CONSTRAINTS;
DROP TABLE Movies CASCADE CONSTRAINTS;
DROP TABLE CopyTmp CASCADE CONSTRAINTS;

BEGIN
	DBMS_XMLSCHEMA.DELETESCHEMA('http://XSD/archives.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
END;
/

BEGIN
	DBMS_XMLSCHEMA.DELETESCHEMA('http://XSD/copies.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
END;
/

BEGIN
	DBMS_XMLSCHEMA.DELETESCHEMA('http://XSD/movies.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
END;
/

BEGIN
	DBMS_XMLSCHEMA.DELETESCHEMA('http://XSD/projections.xsd',DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
END;
/