-- c)


CREATE OR REPLACE FUNCTION DostepneWycieczki2(do_kraj WYCIECZKI.KRAJ%TYPE, data_od DATE, data_do DATE)
RETURN TabelaDostepneWycieczki
AS result TabelaDostepneWycieczki;
countID INT;
BEGIN
   IF data_do < data_od THEN
        RAISE_APPLICATION_ERROR(-20001, 'Niepoprawne dane');
    END IF;

    SELECT ObiektDostepneWycieczki(NAZWA, KRAJ, DATA, OPIS, LICZBA_WOLNYCH_MIEJSC)
        BULK COLLECT
    INTO result
    FROM WYCIECZKI
    WHERE DATA >= data_od AND DATA <= data_do AND KRAJ = do_kraj;

    SELECT COUNT(*) INTO countID FROM WYCIECZKI
    WHERE DATA >= data_od AND DATA <= data_do AND KRAJ = do_kraj;
    IF countID = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Brak wycieczek o podanych parametrach');
    END IF;

    RETURN result;
END DostepneWycieczki2;
