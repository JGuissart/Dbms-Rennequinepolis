create or replace
PACKAGE BODY STATMOVIES AS
  PROCEDURE GENSTAT(P_Stat OUT R_Stat, P_TabElement OUT T_TabElement) AS
  fid   utl_file.file_type;
  genresId NESTEDCHAR := NESTEDCHAR();
  genresName NESTEDCHAR := NESTEDCHAR();
  directorId NESTEDCHAR := NESTEDCHAR();
  directorName NESTEDCHAR := NESTEDCHAR();
  directorPath NESTEDCHAR := NESTEDCHAR();
  actorId NESTEDCHAR := NESTEDCHAR();
  actorName NESTEDCHAR := NESTEDCHAR();
  actorCastId NESTEDCHAR := NESTEDCHAR(); 
  actorCharacter NESTEDCHAR := NESTEDCHAR();
  actorPath NESTEDCHAR := NESTEDCHAR();
  companyId NESTEDCHAR := NESTEDCHAR();
  companyName NESTEDCHAR := NESTEDCHAR();
  countryISO NESTEDCHAR := NESTEDCHAR();
  countryName NESTEDCHAR := NESTEDCHAR();
  languageISO NESTEDCHAR := NESTEDCHAR();
  languageName NESTEDCHAR := NESTEDCHAR();
  
  V_Logs R_Logs;
  
  BEGIN
    fid := utl_file.fopen ('MOVIES', 'Resultat.txt', 'W');
    utl_file.fclose (fid);
    
    --ID
    SELECT AVG(LENGTH(ID)), STDDEV(LENGTH(ID)), MEDIAN(LENGTH(ID)), MIN(LENGTH(ID)), MAX(LENGTH(ID)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(ID)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(ID)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE ID IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE ID IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(ID) = 0;
    
    ECRITURECOURT('ID', P_Stat);
    
    --TITLE
    SELECT AVG(LENGTH(TITLE)), STDDEV(LENGTH(TITLE)), MEDIAN(LENGTH(TITLE)), MIN(LENGTH(TITLE)), MAX(LENGTH(TITLE)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(title)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(title)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE title IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE title IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(title) = 0;
    
    ECRITURECOURT('TITLE', P_Stat);
    
    --ORIGINAL_TITLE
    SELECT AVG(LENGTH(ORIGINAL_TITLE)), STDDEV(LENGTH(ORIGINAL_TITLE)), MEDIAN(LENGTH(ORIGINAL_TITLE)), MIN(LENGTH(ORIGINAL_TITLE)), MAX(LENGTH(ORIGINAL_TITLE)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(ORIGINAL_TITLE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(ORIGINAL_TITLE)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE ORIGINAL_TITLE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE ORIGINAL_TITLE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(ORIGINAL_TITLE) = 0;
    
    ECRITURECOURT('ORIGINAL_TITLE', P_Stat);
    
    --RELEASE_DATE
    SELECT AVG(LENGTH(RELEASE_DATE)), STDDEV(LENGTH(RELEASE_DATE)), MEDIAN(LENGTH(RELEASE_DATE)), MIN(LENGTH(RELEASE_DATE)), MAX(LENGTH(RELEASE_DATE)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(RELEASE_DATE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(RELEASE_DATE)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE RELEASE_DATE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE RELEASE_DATE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(RELEASE_DATE) = 0;
    
    ECRITURECOURT('RELEASE_DATE', P_Stat);

    --STATUS
    SELECT AVG(LENGTH(STATUS)), STDDEV(LENGTH(STATUS)), MEDIAN(LENGTH(STATUS)), MIN(LENGTH(STATUS)), MAX(LENGTH(STATUS)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(STATUS)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(STATUS)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE STATUS IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE STATUS IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(STATUS) = 0;
    
    SELECT DISTINCT STATUS BULK COLLECT INTO P_TabElement 
    FROM movies_ext;
    
    ECRITURELONG('STATUS', P_Stat, P_TabElement);
    
    --VOTE_AVERAGE
    SELECT AVG(LENGTH(VOTE_AVERAGE)), STDDEV(LENGTH(VOTE_AVERAGE)), MEDIAN(LENGTH(VOTE_AVERAGE)), MIN(LENGTH(VOTE_AVERAGE)), MAX(LENGTH(VOTE_AVERAGE)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(VOTE_AVERAGE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(VOTE_AVERAGE)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE VOTE_AVERAGE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE VOTE_AVERAGE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(VOTE_AVERAGE) = 0;
    
    ECRITURECOURT('VOTE_AVERAGE', P_Stat);
    
    --VOTE_COUNT
    SELECT AVG(LENGTH(VOTE_COUNT)), STDDEV(LENGTH(VOTE_COUNT)), MEDIAN(LENGTH(VOTE_COUNT)), MIN(LENGTH(VOTE_COUNT)), MAX(LENGTH(VOTE_COUNT)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(VOTE_COUNT)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(VOTE_COUNT)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE VOTE_COUNT IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE VOTE_COUNT IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(VOTE_COUNT) = 0;
    
    ECRITURECOURT('VOTE_COUNT', P_Stat);
    
    --RUNTIME
    SELECT AVG(LENGTH(RUNTIME)), STDDEV(LENGTH(RUNTIME)), MEDIAN(LENGTH(RUNTIME)), MIN(LENGTH(RUNTIME)), MAX(LENGTH(RUNTIME)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(RUNTIME)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(RUNTIME)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE RUNTIME IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE RUNTIME IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(RUNTIME) = 0;
    
    ECRITURECOURT('RUNTIME', P_Stat);
        
    --CERTIFICATION
    SELECT AVG(LENGTH(CERTIFICATION)), STDDEV(LENGTH(CERTIFICATION)), MEDIAN(LENGTH(CERTIFICATION)), MIN(LENGTH(CERTIFICATION)), MAX(LENGTH(CERTIFICATION)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(CERTIFICATION)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(CERTIFICATION)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE CERTIFICATION IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE CERTIFICATION IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(CERTIFICATION) = 0;
    
    SELECT DISTINCT CERTIFICATION BULK COLLECT INTO P_TabElement 
    FROM movies_ext;
    
    ECRITURELONG('CERTIFICATION', P_Stat, P_TabElement);
    
    --POSTER_PATH
    SELECT AVG(LENGTH(POSTER_PATH)), STDDEV(LENGTH(POSTER_PATH)), MEDIAN(LENGTH(POSTER_PATH)), MIN(LENGTH(POSTER_PATH)), MAX(LENGTH(POSTER_PATH)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(POSTER_PATH)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(POSTER_PATH)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE POSTER_PATH IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE POSTER_PATH IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(POSTER_PATH) = 0;
    
    ECRITURECOURT('POSTER_PATH', P_Stat);
    
    --BUDGET
    SELECT AVG(LENGTH(BUDGET)), STDDEV(LENGTH(BUDGET)), MEDIAN(LENGTH(BUDGET)), MIN(LENGTH(BUDGET)), MAX(LENGTH(BUDGET)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(BUDGET)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(BUDGET)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE BUDGET IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE BUDGET IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(BUDGET) = 0;
    
    ECRITURECOURT('BUDGET', P_Stat);
    
    --REVENUE
    SELECT AVG(LENGTH(REVENUE)), STDDEV(LENGTH(REVENUE)), MEDIAN(LENGTH(REVENUE)), MIN(LENGTH(REVENUE)), MAX(LENGTH(REVENUE)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(REVENUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(REVENUE)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE REVENUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE REVENUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(REVENUE) = 0;
    
    ECRITURECOURT('REVENUE', P_Stat);
    
    --HOMEPAGE
    SELECT AVG(LENGTH(HOMEPAGE)), STDDEV(LENGTH(HOMEPAGE)), MEDIAN(LENGTH(HOMEPAGE)), MIN(LENGTH(HOMEPAGE)), MAX(LENGTH(HOMEPAGE)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(HOMEPAGE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(HOMEPAGE)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE HOMEPAGE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE HOMEPAGE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(HOMEPAGE) = 0;
    
    ECRITURECOURT('HOMEPAGE', P_Stat);
    
    --TAGLINE
    SELECT AVG(LENGTH(TAGLINE)), STDDEV(LENGTH(TAGLINE)), MEDIAN(LENGTH(TAGLINE)), MIN(LENGTH(TAGLINE)), MAX(LENGTH(TAGLINE)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(TAGLINE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(TAGLINE)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE TAGLINE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE TAGLINE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(TAGLINE) = 0;
    
    ECRITURECOURT('TAGLINE', P_Stat);
    
    --OVERVIEW
    SELECT AVG(LENGTH(OVERVIEW)), STDDEV(LENGTH(OVERVIEW)), MEDIAN(LENGTH(OVERVIEW)), MIN(LENGTH(OVERVIEW)), MAX(LENGTH(OVERVIEW)), COUNT(*),0,0,0,PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(OVERVIEW)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(OVERVIEW)) INTO P_Stat
    FROM movies_ext;
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM movies_ext WHERE OVERVIEW IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM movies_ext WHERE OVERVIEW IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM movies_ext WHERE LENGTH(OVERVIEW) = 0;
    
    ECRITURECOURT('OVERVIEW', P_Stat);
    
    --GENRE
    get_movie_genres(genresId , genresName);
    
    --GENRE_ID
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(genresId);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(genresId) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(genresId) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(genresId) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('GENRES_ID', P_Stat);
    
    --GENRE_NAME
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(genresName);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(genresName) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(genresName) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(genresName) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    SELECT DISTINCT column_value BULK COLLECT INTO P_TabElement 
    FROM TABLE(genresName);
    
    ECRITURELONG('GENRES_NAME', P_Stat, P_TabElement );
    
    --DIRECTORS
    get_movie_director(directorId, directorName, directorPath);
    
    --DIRECTORS_ID
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(directorId);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(directorId) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(directorId) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(directorId) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('DIRECTORS_ID', P_Stat);
    
    --DIRECTORS_NAME
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(directorName);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(directorName) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(directorName) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(directorName) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('DIRECTORS_NAME', P_Stat);
    
    --DIRECTORS_PATH
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(directorPath);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(directorPath) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(directorPath) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(directorPath) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('DIRECTORS_PATH', P_Stat);
    
    --ACTORS    
    get_movie_actor(actorId, actorName, actorCastId, actorCharacter, actorPath);
    
    --ACTORS_ID
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(actorId);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(actorId) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(actorId) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(actorId) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('ACTORS_ID', P_Stat);
    
    --ACTORS_NAME
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(actorName);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(actorName) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(actorName) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(actorName) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('ACTORS_NAME', P_Stat);

    --ACTORS_CAST
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(actorCastId);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(actorCastId) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(actorCastId) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(actorCastId) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('ACTORS_CAST', P_Stat);
    
    --ACTORS_CHARACTER
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(actorCharacter);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(actorCharacter) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(actorCharacter) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(actorCharacter) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('ACTORS_CHARACTER', P_Stat);
    
    --ACTORS_PATH
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(actorPath);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(actorPath) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(actorPath) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(actorPath) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('ACTORS_PATH', P_Stat);
    
    --PRODUCTION_COMPANIES
    get_movie_productionCompanies(companyId, companyName);
    
    --COMPANY_ID
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(companyId);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(companyId) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(companyId) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(companyId) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('COMPANY_ID', P_Stat);
    
    --COMPANY_NAME
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(companyName);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(companyName) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(companyName) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(companyName) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('COMPANY_NAME', P_Stat);
    
    --PRODUCTION_COUNTRIES
    get_movie_productionCountries(countryISO, countryName);
    
    --COUNTRY_ISO
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(countryISO);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(countryISO) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(countryISO) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(countryISO) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('COUNTRY_ISO', P_Stat);
    
    --COUNTRY_NAME
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(countryName);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(countryName) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(countryName) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(countryName) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('COUNTRY_NAME', P_Stat);
    
    --SPOKEN_LANGUAGES
    get_movie_spokenLanguages(languageISO, languageName);
    
    --LANGUAGE_ISO
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(languageISO);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(languageISO) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(languageISO) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(languageISO) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('LANGUAGE_ISO', P_Stat);
    
    --LANGUAGE_NAME
    SELECT AVG(LENGTH(COLUMN_VALUE)), STDDEV(LENGTH(COLUMN_VALUE)), MEDIAN(LENGTH(COLUMN_VALUE)), MIN(LENGTH(COLUMN_VALUE)), MAX(LENGTH(COLUMN_VALUE)) ,COUNT(*),0,0,0, PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)), PERCENTILE_CONT(0.9999) WITHIN GROUP(ORDER BY LENGTH(COLUMN_VALUE)) INTO P_Stat FROM TABLE(languageName);
    
    SELECT count(*) INTO P_Stat.CountNotNull FROM TABLE(languageName) WHERE COLUMN_VALUE IS NOT NULL;
    
    SELECT count(*) INTO P_Stat.CountNull FROM TABLE(languageName) WHERE COLUMN_VALUE IS NULL;
    
    SELECT count(*) INTO P_Stat.CountZero FROM TABLE(languageName) WHERE LENGTH(COLUMN_VALUE) = 0;
    
    ECRITURECOURT('LANGUAGE_NAME', P_Stat);
    
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
      V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Pas de données trouvées';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
      if utl_file.is_open(fid) then
        utl_file.fclose (fid);
      end if;
      
      when others then
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
        if utl_file.is_open(fid) then
        utl_file.fclose (fid);
      end if;
  END GENSTAT;
  
  PROCEDURE ECRITURECOURT(Label VARCHAR2 ,P_Stat IN R_Stat) AS
  fid   utl_file.file_type;
  V_Logs R_Logs;
  BEGIN
    fid := utl_file.fopen ('MOVIES', 'Resultat.txt', 'A');
    utl_file.put_line (fid, Label);
    utl_file.put_line (fid, '-----');
    utl_file.put_line (fid, 'MOYENNE : ' ||P_Stat.Moyenne);
    utl_file.put_line (fid, 'ECART-TYPE : '||P_Stat.Ecart);
    utl_file.put_line (fid, 'MEDIAN : '||P_Stat.Median);
    utl_file.put_line (fid, 'MIN : '||P_Stat.TailleMin);
    utl_file.put_line (fid, 'MAX : '||P_Stat.TailleMax);
    utl_file.put_line (fid, 'COUNT : '||P_Stat.CountValeur);
    utl_file.put_line (fid, 'COUNT NOT NULL : '||P_Stat.CountNotNull);
    utl_file.put_line (fid, 'COUNT NULL : '||P_Stat.CountNull);
    utl_file.put_line (fid, 'COUNT ZERO : '||P_Stat.CountZero);
    utl_file.put_line (fid, '99e 100-quantile : '||P_Stat.q99);
    utl_file.put_line (fid, '9999e 10000-quantile : '||P_Stat.q9999);
    utl_file.put_line (fid,'');
    utl_file.fclose (fid);
    
    EXCEPTION 
      when others then
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
        if utl_file.is_open(fid) then
        utl_file.fclose (fid);
      end if;
  END ECRITURECOURT;
  
  PROCEDURE ECRITURELONG(Label VARCHAR2 ,P_Stat IN R_Stat, P_TabElement IN T_TabElement) AS
  fid   utl_file.file_type;
  V_Logs R_Logs;
  BEGIN
    fid := utl_file.fopen ('MOVIES', 'Resultat.txt', 'A');
    utl_file.put_line (fid, Label);
    utl_file.put_line (fid, '-----');
    utl_file.put_line (fid, 'MOYENNE : ' ||P_Stat.Moyenne);
    utl_file.put_line (fid, 'ECART-TYPE : '||P_Stat.Ecart);
    utl_file.put_line (fid, 'MEDIAN : '||P_Stat.Median);
    utl_file.put_line (fid, 'MIN : '||P_Stat.TailleMin);
    utl_file.put_line (fid, 'MAX : '||P_Stat.TailleMax);
    utl_file.put_line (fid, 'COUNT : '||P_Stat.CountValeur);
    utl_file.put_line (fid, 'COUNT NOT NULL : '||P_Stat.CountNotNull);
    utl_file.put_line (fid, 'COUNT NULL : '||P_Stat.CountNull);
    utl_file.put_line (fid, 'COUNT ZERO : '||P_Stat.CountZero);
    utl_file.put_line (fid, '99e 100-quantile : '||P_Stat.q99);
    utl_file.put_line (fid, '9999e 10000-quantile : '||P_Stat.q9999);
    utl_file.put_line (fid, 'Eléments : ');
    for i IN P_TabElement.FIRST..P_TabElement.LAST LOOP
    utl_file.put_line (fid, P_TabElement(i));
    END LOOP;
    utl_file.put_line (fid,'');
    utl_file.fclose (fid);
    
    EXCEPTION 
      when others then
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
        if utl_file.is_open(fid) then
        utl_file.fclose (fid);
      end if;
  END ECRITURELONG;
  
  PROCEDURE get_movie_genres(P_TabIdGenres  IN OUT NESTEDCHAR, P_TabNameGenres IN OUT NESTEDCHAR) 
  is
    genres_s T_TabGenres;
    genre varchar2(4000);
    res vc_arr;
    i integer := 1;
    cpt integer := 1;
    V_Logs R_Logs;
  
  begin
        select regexp_substr(genres, '^\[\[(.*)\]\]$', 1, 1, '', 1) BULK COLLECT into genres_s 
        from movies_ext;

      FOR cpt IN genres_s.FIRST..genres_s.LAST 
      loop
        if LENGTH(genres_s(cpt)) >0 THEN
          loop
            genre := regexp_substr(genres_s(cpt), '(.*?)(\|\||$)', 1, i, '', 1);
            
            exit when genre is null;
            res(1) := regexp_substr(genre, '^(.*),{2,}(.*)$', 1,1,'',1);
            res(2) := regexp_substr(genre, '^(.*),{2,}(.*)$', 1,1,'',2);
            
            if res(2) IS NOT NULL then
                P_TabIdGenres.extend;
                P_TabNameGenres.extend;
                P_TabIdGenres(P_TabIdGenres.count) := res(1);
                P_TabNameGenres(P_TabNameGenres.count) := res(2);
            end if;
            i := i +1;
          end loop;
        end if; 
        i := 1;
      end loop;
      
      EXCEPTION
      WHEN OTHERS THEN 
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
  end get_movie_genres;
  
  PROCEDURE get_movie_director(P_TabIdDirector  IN OUT NESTEDCHAR, P_TabNameDirector IN OUT NESTEDCHAR, P_TabPathDirector IN OUT NESTEDCHAR) 
  is
    director_s T_TabDirector;
    director varchar2(4000);
    res vc_arr;
    i integer := 1;
    cpt integer := 1;
    V_Logs R_Logs;
  
  begin
        select regexp_substr(directors, '^\[\[(.*)\]\]$', 1, 1, '', 1) BULK COLLECT into director_s 
        from movies_ext;

      FOR cpt IN director_s.FIRST..director_s.LAST 
      loop
        if LENGTH(director_s(cpt)) >0 THEN
          loop
            director := regexp_substr(director_s(cpt), '(.*?)(\|\||$)', 1, i, '', 1);
            
            exit when director is null;
            res(1) := regexp_substr(director, '^(.*),{2,}(.*),{2,}(.*)$', 1,1,'',1);
            res(2) := regexp_substr(director, '^(.*),{2,}(.*),{2,}(.*)$', 1,1,'',2);
            res(3) := regexp_substr(director, '^(.*),{2,}(.*),{2,}(.*)$', 1,1,'',3);
            
            if res(3) IS NOT NULL then
                P_TabIdDirector.extend;
                P_TabNameDirector.extend;
                P_TabPathDirector.extend;
                P_TabIdDirector(P_TabIdDirector.count) := res(1);
                P_TabNameDirector(P_TabNameDirector.count) := res(2);
                P_TabPathDirector(P_TabPathDirector.count) := res(3);
            end if;
            i := i +1;
          end loop;
        end if; 
        i := 1;
      end loop;
      
      EXCEPTION
      WHEN OTHERS THEN
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
  end get_movie_director;
  
  PROCEDURE get_movie_actor(P_TabIdActor IN OUT NESTEDCHAR, P_TabNameActor IN OUT NESTEDCHAR, P_TabCastIdActor IN OUT NESTEDCHAR, P_TabCharacterActor IN OUT NESTEDCHAR, P_TabPathProfileActor IN OUT NESTEDCHAR) 
  is
    actors_s T_TabActor;
    actor varchar2(4000);
    res vc_arr;
    i integer := 1;
    cpt integer := 1;
    V_Logs R_Logs;
    
  begin
        select regexp_substr(actors, '^\[\[(.*)\]\]$', 1, 1, '', 1) BULK COLLECT into actors_s 
        from movies_ext;

      FOR cpt IN actors_s.FIRST..actors_s.LAST 
      loop
        if LENGTH(actors_s(cpt)) >0 THEN
          loop
            actor := regexp_substr(actors_s(cpt), '(.*?)(\|\||$)', 1, i, '', 1);
            
            exit when actor is null;
            res(1):= regexp_substr(actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1,1,'',1);
            res(2):= regexp_substr(actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1,1,'',2);
            res(3):= regexp_substr(actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1,1,'',3);
            res(4):= regexp_substr(actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1,1,'',4);
            res(5):= regexp_substr(actor, '^(.*),{2,}(.*),{2,}(.*),{2,}(.*),{2,}(.*)$', 1,1,'',5);

            if res(5) IS NOT NULL then
                P_TabIdActor.extend;
                P_TabNameActor.extend;
                P_TabCastIdActor.extend;
                P_TabCharacterActor.extend;
                P_TabPathProfileActor.extend;
                P_TabIdActor(P_TabIdActor.count) := res(1);
                P_TabNameActor(P_TabNameActor.count) := res(2);
                P_TabCastIdActor(P_TabCastIdActor.count) := res(3);
                P_TabCharacterActor(P_TabCharacterActor.count) := res(4);
                P_TabPathProfileActor(P_TabPathProfileActor.count) := res(5); 
            end if;
            i := i +1;
          end loop;
        end if; 
        i := 1;
      end loop;
      
      EXCEPTION
      WHEN OTHERS THEN 
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
  end get_movie_actor;
  
  PROCEDURE get_movie_productionCompanies(P_TabIdProduction  IN OUT NESTEDCHAR, P_TabNameProduction IN OUT NESTEDCHAR) 
  is
    productionCompanies_s T_TabProductionCompanies;
    productionCompanie varchar2(4000);
    res vc_arr;
    i integer := 1;
    cpt integer := 1;
    V_Logs R_Logs;

  begin
        select regexp_substr(production_Companies, '^\[\[(.*)\]\]$', 1, 1, '', 1) BULK COLLECT into productionCompanies_s 
        from movies_ext;

      FOR cpt IN productionCompanies_s.FIRST..productionCompanies_s.LAST 
      loop
        if LENGTH(productionCompanies_s(cpt)) >0 THEN
          loop
            productionCompanie := regexp_substr(productionCompanies_s(cpt), '(.*?)(\|\||$)', 1, i, '', 1);
            
            exit when productionCompanie is null;
            res(1):= regexp_substr(productionCompanie, '^(.*),{2,}(.*)$', 1,1,'',1);
            res(2) := regexp_substr(productionCompanie, '^(.*),{2,}(.*)$', 1,1,'',2);
            
            if res(2) IS NOT NULL then
                P_TabIdProduction.extend;
                P_TabNameProduction.extend;
                P_TabIdProduction(P_TabIdProduction.count) := res(1);
                P_TabNameProduction(P_TabNameProduction.count) := res(2);
            end if;
            i := i +1;
          end loop;
        end if; 
        i := 1;
      end loop;
        
      EXCEPTION
      WHEN OTHERS THEN 
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
  end get_movie_productionCompanies;
  
  PROCEDURE get_movie_productionCountries(P_TabISOCountry IN OUT NESTEDCHAR, P_TabNameCountry IN OUT NESTEDCHAR) 
  is
    productionCountries_s T_TabProductionCountries;
    productionCountry varchar2(4000);
    res vc_arr;
    i integer := 1;
    cpt integer := 1;
    V_Logs R_Logs;
    
  begin
        select regexp_substr(production_Countries, '^\[\[(.*)\]\]$', 1, 1, '', 1) BULK COLLECT into productionCountries_s 
        from movies_ext;

      FOR cpt IN productionCountries_s.FIRST..productionCountries_s.LAST 
      loop
        if LENGTH(productionCountries_s(cpt)) >0 THEN
          loop
            productionCountry := regexp_substr(productionCountries_s(cpt), '(.*?)(\|\||$)', 1, i, '', 1);
            
            exit when productionCountry is null;
            res(1):= regexp_substr(productionCountry, '^(.*),{2,}(.*)$', 1,1,'',1);
            res(2) := regexp_substr(productionCountry, '^(.*),{2,}(.*)$', 1,1,'',2);
            
            if res(2) IS NOT NULL then
                P_TabISOCountry.extend;
                P_TabNameCountry.extend;
                P_TabISOCountry(P_TabISOCountry.count) := res(1);
                P_TabNameCountry(P_TabNameCountry.count) := res(2);
            end if;
            i := i +1;
          end loop;
        end if; 
        i := 1;
      end loop;
        
      EXCEPTION
      WHEN OTHERS THEN 
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
  end get_movie_productionCountries;
  
  PROCEDURE get_movie_spokenLanguages(P_TabISOSpokenLanguages IN OUT NESTEDCHAR, P_TabNameSpokenLanguages IN OUT NESTEDCHAR)
  is
    spokenLanguages_s T_TabSpokenLanguages;
    spokenLanguage varchar2(4000);
    res vc_arr;
    i integer := 1;
    cpt integer := 1;
    V_Logs R_Logs;
    
  begin
        select regexp_substr(spoken_Languages, '^\[\[(.*)\]\]$', 1, 1, '', 1) BULK COLLECT into spokenLanguages_s 
        from movies_ext;

      FOR cpt IN spokenLanguages_s.FIRST..spokenLanguages_s.LAST 
      loop
        if LENGTH(spokenLanguages_s(cpt)) >0 THEN
          loop
            spokenLanguage := regexp_substr(spokenLanguages_s(cpt), '(.*?)(\|\||$)', 1, i, '', 1);
            
            exit when spokenLanguage is null;
            res(1):= regexp_substr(spokenLanguage, '^(.*),{2,}(.*)$', 1,1,'',1);
            res(2) := regexp_substr(spokenLanguage, '^(.*),{2,}(.*)$', 1,1,'',2);
            if res(2) IS NOT NULL then
                P_TabISOSpokenLanguages.extend;
                P_TabNameSpokenLanguages.extend;
                P_TabISOSpokenLanguages(P_TabISOSpokenLanguages.count) := res(1);
                P_TabNameSpokenLanguages(P_TabNameSpokenLanguages.count) := res(2);
            end if;
            i := i +1;
          end loop;
        end if; 
        i := 1;
      end loop;
      
      EXCEPTION
      WHEN OTHERS THEN 
        V_Logs.LogWhen := CURRENT_DATE;
        V_Logs.ErrorCode := '-20002';
        V_Logs.LogWhat := 'Erreur';
        V_Logs.LogWhere := 'GEN_STAT';
        AddLogs(V_Logs);
  end get_movie_spokenLanguages;
  
  PROCEDURE AddLogs(ElemToAdd IN R_Logs) AS
		PRAGMA AUTONOMOUS_TRANSACTION ; -- Procédure autonome niveau transactionnel
		V_Error R_Logs;
		E_ParamaterNull EXCEPTION;
		BEGIN
			IF (ElemToAdd.LogWhen IS NULL) THEN 
				RAISE E_ParamaterNull; 
			END IF;

			INSERT INTO Logs VALUES (seqLogs.NextVal, ElemToAdd.LogWhen, ElemToAdd.ErrorCode, ElemToAdd.LogWhat, ElemToAdd.LogWhere);
			COMMIT;
		EXCEPTION
			WHEN E_ParamaterNull THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := '-20002';
				V_Error.LogWhat := 'Parametre recu null';
				V_Error.LogWhere := 'CB_RennequinepolisCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT;
			WHEN OTHERS THEN
				V_Error.LogWhen := CURRENT_DATE;
				V_Error.ErrorCode := SQLCODE;
				V_Error.LogWhat := 'OTHERS : ' || SQLERRM;
				V_Error.LogWhere := 'CB_RennequinepolisCBLight.AddLogs';
				AddLogs(V_Error);
				COMMIT; 
	END AddLogs;
END STATMOVIES;