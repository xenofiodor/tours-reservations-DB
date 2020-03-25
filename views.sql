--3a
CREATE VIEW RezerwacjeWszystkie
    AS
        SELECT
            w.ID_WYCIECZKI,
            w.NAZWA,
            w.KRAJ,
            w.DATA,
            o.IMIE,
            o.NAZWISKO,
            r.STATUS
        FROM WYCIECZKI w
            JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY;

SELECT * FROM RezerwacjeWszystkie;
--3b
CREATE OR REPLACE VIEW RezerwacjePotwierdzone
    AS
        SELECT
            ID_WYCIECZKI,
            NAZWA,
            KRAJ,
            DATA,
            IMIE,
            NAZWISKO,
            STATUS
        FROM RezerwacjeWszystkie
        WHERE STATUS = 'P' OR STATUS = 'Z';
SELECT * FROM RezerwacjePotwierdzone;

--3c
CREATE OR REPLACE VIEW RezerwacjeWPrzyszlosci
    AS
        SELECT
            ID_WYCIECZKI,
            NAZWA,
            KRAJ,
            DATA,
            IMIE,
            NAZWISKO,
            STATUS
        FROM RezerwacjeWszystkie
        WHERE DATA > CURRENT_DATE
        AND STATUS != 'A';

SELECT * FROM RezerwacjeWPrzyszlosci;




--3d
CREATE OR REPLACE VIEW WycieczkiMiejsca
    AS
        SELECT
            w.ID_WYCIECZKI,
            w.NAZWA,
            w.KRAJ,
            w.DATA,
            w.LICZBA_MIEJSC,
            (w.LICZBA_MIEJSC -
                (SELECT COUNT(*)
                 FROM REZERWACJE r
                 WHERE r.ID_WYCIECZKI = w.ID_WYCIECZKI
                 AND r.STATUS != 'A'
                )
             ) AS LICZBA_WOLNYCH_MIEJSC
        FROM WYCIECZKI w;


SELECT * FROM WycieczkiMiejsca;

--3e
CREATE OR REPLACE VIEW WycieczkiDostepne
    AS
        SELECT *
        FROM WycieczkiMiejsca
        WHERE LICZBA_WOLNYCH_MIEJSC > 0
        AND DATA >= CURRENT_DATE;

SELECT * FROM WycieczkiDostepne;

--3f wycieczki osoby
CREATE VIEW WycieczkiOsoby
    AS
        SELECT w.ID_WYCIECZKI, NAZWA, KRAJ, DATA, o.ID_OSOBY, IMIE, NAZWISKO, PESEL, KONTAKT
        FROM WYCIECZKI w
        JOIN REZERWACJE r ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
        JOIN OSOBY o ON o.ID_OSOBY = r.ID_OSOBY;

SELECT * FROM WycieczkiOsoby ORDER BY ID_WYCIECZKI;


SELECT * FROM WYCIECZKI;
SELECT * FROM REZERWACJE;
SELECT * FROM OSOBY;