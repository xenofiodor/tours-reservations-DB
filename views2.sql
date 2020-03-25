--3d2
CREATE OR REPLACE VIEW WycieczkiMiejsca2
    AS
        SELECT
            ID_WYCIECZKI,
            NAZWA,
            KRAJ,
            DATA,
            LICZBA_MIEJSC,
            LICZBA_WOLNYCH_MIEJSC
        FROM WYCIECZKI;


CREATE OR REPLACE VIEW WycieczkiDostepne
    AS
        SELECT *
        FROM WycieczkiMiejsca2
        WHERE LICZBA_WOLNYCH_MIEJSC > 0
        AND DATA >= CURRENT_DATE;

SELECT * FROM WycieczkiMiejsca2;
