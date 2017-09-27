CREATE OR REPLACE PACKAGE AlimMKT IS
    PROCEDURE AlimentationMKT;
	PROCEDURE MergeMovie;
	PROCEDURE InsertPays;
    PROCEDURE InsertActors;
    PROCEDURE InsertGenres;
    PROCEDURE MergeMoviePaysActorsGenres;
    PROCEDURE MergeComplexe;
    PROCEDURE MergeSalle;
    PROCEDURE InsertProgrammations;
END;
/