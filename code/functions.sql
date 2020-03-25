-- a)
CREATE OR REPLACE TYPE ObiektUczestnicyWycieczki AS OBJECT (
    ID_WYCIECZKI INT,
    NAZWA VARCHAR2(100),
    KRAJ VARCHAR2(50),
    "DATA" DATE,
    IMIE VARCHAR2(50),
    NAZWISKO VARCHAR2(50),
    STATUS CHAR(1)
);

CREATE OR REPLACE TYPE TabelaUczestnicyWycieczki AS TABLE OF ObiektUczestnicyWycieczki;

CREATE OR REPLACE FUNCTION UczestnicyWycieczki(id INT)
    RETURN TabelaUczestnicyWycieczki AS
        result  TabelaUczestnicyWycieczki;
    countID INTEGER;
BEGIN
    SELECT COUNT(*) INTO countID
    FROM WYCIECZKI
    WHERE ID_WYCIECZKI = id;
    IF countID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak wycieczki o podanym ID');
    END IF;

    SELECT ObiektUczestnicyWycieczki(ID_WYCIECZKI, NAZWA, KRAJ, DATA, IMIE, NAZWISKO, STATUS)
        BULK COLLECT
    INTO result
    FROM REZERWACJEWSZYSTKIE
    WHERE ID_WYCIECZKI = id
    AND STATUS != 'A';
    RETURN result;
END UczestnicyWycieczki;

SELECT * FROM TABLE(UczestnicyWycieczki(3));

-- b)

CREATE OR REPLACE TYPE ObiektRezerwacjeOsoby AS OBJECT (
    ID_WYCIECZKI INT,
    NAZWA VARCHAR2(100),
    KRAJ VARCHAR2(50),
    "DATA" DATE
);

CREATE OR REPLACE TYPE TabelaRezerwacjeOsoby AS TABLE OF ObiektRezerwacjeOsoby;

CREATE OR REPLACE FUNCTION RezerwacjeOsoby(id INT)
RETURN TabelaRezerwacjeOsoby
AS result TabelaRezerwacjeOsoby;
countID INT;
BEGIN
    SELECT COUNT(*) INTO countID
    FROM OSOBY
    WHERE ID_OSOBY = id;
    IF countID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak osoby o podanym ID');
    END IF;

    SELECT ObiektRezerwacjeOsoby(r.ID_WYCIECZKI, NAZWA, KRAJ, DATA)
        BULK COLLECT
    INTO result
    FROM REZERWACJE r
    JOIN WYCIECZKI w ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
    WHERE ID_OSOBY = id;

    SELECT COUNT(*) INTO countID
    FROM REZERWACJE
    WHERE ID_OSOBY = id;
    IF (countID = 0) THEN
        DBMS_OUTPUT.PUT_LINE('Osoba o podanym ID nie ma rezerwacji');
    END IF;

    RETURN result;
END RezerwacjeOsoby;

SELECT * FROM TABLE(REZERWACJEOSOBY(28));


-- c)

CREATE OR REPLACE TYPE ObiektDostepneWycieczki AS OBJECT (
    NAZWA VARCHAR2(100),
    KRAJ VARCHAR2(50),
    "DATA" DATE,
    OPIS VARCHAR2(200),
    LICZBA_WOLNYCH_MIEJSC INT
);

CREATE OR REPLACE TYPE TabelaDostepneWycieczki AS TABLE OF ObiektDostepneWycieczki;

CREATE OR REPLACE FUNCTION DostepneWycieczki(do_kraj WYCIECZKI.KRAJ%TYPE, data_od DATE, data_do DATE)
RETURN TabelaDostepneWycieczki
AS result TabelaDostepneWycieczki;
countID INT;
BEGIN
   IF data_do < data_od THEN
        RAISE_APPLICATION_ERROR(-20001, 'Niepoprawne dane');
    END IF;

    SELECT ObiektDostepneWycieczki(wd.NAZWA, wd.KRAJ, wd.DATA, OPIS, wd.LICZBA_WOLNYCH_MIEJSC)
        BULK COLLECT
    INTO result
    FROM WYCIECZKIDOSTEPNE wd
    JOIN WYCIECZKI w on wd.ID_WYCIECZKI = w.ID_WYCIECZKI
    WHERE wd.DATA >= data_od AND wd.DATA <= data_do AND wd.KRAJ = do_kraj;

    SELECT COUNT(*) INTO countID FROM WYCIECZKIDOSTEPNE wd
    WHERE wd.DATA >= data_od AND wd.DATA <= data_do AND wd.KRAJ = do_kraj;
    IF countID = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Brak wycieczek o podanych parametrach');
    END IF;

    RETURN result;
END DostepneWycieczki;


SELECT * FROM TABLE(DostepneWycieczki('Francja', TO_DATE('2020/01/01', 'yyyy/mm/dd'), TO_DATE('2020/12/31', 'yyyy/mm/dd')));
