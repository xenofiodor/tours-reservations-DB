-- a)
CREATE OR REPLACE PROCEDURE DodajRezerwacje(ID_wycieczki INT, ID_osoby INT)
AS
    countID INT;
    ID_Rezerwacji INT;
BEGIN
    SELECT COUNT(*) INTO countID
    FROM WYCIECZKI w
    WHERE w.ID_WYCIECZKI = DodajRezerwacje.ID_wycieczki;
    IF countID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak wycieczki o podanym ID');
    END IF;

    SELECT COUNT(*) INTO countID
    FROM OSOBY o
    WHERE o.ID_OSOBY = DodajRezerwacje.ID_osoby;
    IF countID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak osoby o podanym ID');
    END IF;

    SELECT COUNT(*) INTO countID
    FROM WYCIECZKIDOSTEPNE wd
    WHERE wd.ID_WYCIECZKI = DodajRezerwacje.ID_wycieczki;
    IF countID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie można dokonać rezerwacji na wycieczkę o podanym ID: brak wolnych miejsc albo wycieczka już się odbyłą');
    END IF;

    SELECT COUNT(*) INTO countID
    FROM REZERWACJE r
    WHERE r.ID_WYCIECZKI = DodajRezerwacje.ID_wycieczki
        AND r.ID_OSOBY = DodajRezerwacje.ID_osoby;
    IF countID != 0 THEN
         RAISE_APPLICATION_ERROR(-20001, 'Taka rezerwacja już istnieje');
    END IF;

    INSERT INTO REZERWACJE r (r.ID_WYCIECZKI, r.ID_OSOBY, STATUS)
    VALUES(DodajRezerwacje.ID_wycieczki, DodajRezerwacje.ID_osoby, 'N');

    SELECT NR_REZERWACJI INTO DodajRezerwacje.ID_Rezerwacji
    FROM REZERWACJE r
    WHERE r.ID_WYCIECZKI = DodajRezerwacje.ID_wycieczki
    AND r.ID_OSOBY = DodajRezerwacje.ID_osoby;

    INSERT INTO REZERWACJE_LOG rl (rl.ID_REZERWACJI, DATA, STATUS)
    VALUES (DodajRezerwacje.ID_Rezerwacji, CURRENT_DATE, 'N');
END;

CALL DodajRezerwacje(5, 4);


-- b)

CREATE OR REPLACE PROCEDURE ZmienStatusRezerwacji(nr_rezerwacji INT, new_status REZERWACJE.STATUS%TYPE)
AS
    countID INT;
    current_status REZERWACJE.STATUS%TYPE;
    id_wycieczki INT;
BEGIN
    SELECT COUNT(*) INTO countID
    FROM REZERWACJE r
    WHERE r.NR_REZERWACJI = ZmienStatusRezerwacji.nr_rezerwacji;
    IF countID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak rezerwacji o podanym ID');
    END IF;


    SELECT STATUS INTO current_status
    FROM REZERWACJE r
    WHERE r.NR_REZERWACJI = ZmienStatusRezerwacji.nr_rezerwacji;


    SELECT ID_WYCIECZKI INTO ZmienStatusRezerwacji.id_wycieczki
    FROM REZERWACJE r
    WHERE r.NR_REZERWACJI = ZmienStatusRezerwacji.nr_rezerwacji;

    IF current_status = new_status THEN
        RAISE_APPLICATION_ERROR(-20001, 'Rezerwacja o podanym numerze już ma podany status');
    END IF;

    IF current_status = 'A' THEN
        SELECT COUNT(*) INTO countID
        FROM WYCIECZKIDOSTEPNE wd
        WHERE wd.ID_WYCIECZKI = ZmienStatusRezerwacji.id_wycieczki;
        IF countID = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nie można przywrócić rezerwacji na wycieczkę o podanym ID: brak wolnych miejsc albo wycieczka już się odbyłą');
        ELSE
            UPDATE REZERWACJE r
            SET STATUS = new_status
            WHERE r.NR_REZERWACJI = ZmienStatusRezerwacji.nr_rezerwacji;

            INSERT INTO REZERWACJE_LOG (ID_REZERWACJI, DATA, STATUS)
            VALUES
            (ZmienStatusRezerwacji.nr_rezerwacji, CURRENT_DATE, new_status);
        END IF;
    ELSE
        IF (current_status = 'P' AND new_status = 'N')
        OR (current_status = 'Z' AND (new_status = 'P' OR new_status = 'N')) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nie można obniżyć statusu rezerwacji');
        ELSE
            UPDATE REZERWACJE r
            SET STATUS = new_status
            WHERE r.NR_REZERWACJI = ZmienStatusRezerwacji.nr_rezerwacji;

            INSERT INTO REZERWACJE_LOG (ID_REZERWACJI, DATA, STATUS)
            VALUES
            (ZmienStatusRezerwacji.nr_rezerwacji, CURRENT_DATE, new_status);
        END IF;
    END IF;
END;

CALL ZmienStatusRezerwacji(48, 'Z');

-- c)

CREATE OR REPLACE PROCEDURE ZmienLiczbeMiejsc(id_wycieczki INT, new_liczba_miejsc INT)
AS
    current_capacity INT;
    countID INT;
BEGIN
    SELECT COUNT(*) INTO countID
    FROM WYCIECZKI w
    WHERE w.ID_WYCIECZKI = ZmienLiczbeMiejsc.ID_wycieczki;
    IF countID = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak wycieczki o podanym ID');
    END IF;


    SELECT w.LICZBA_MIEJSC INTO current_capacity
    FROM WYCIECZKI w
    WHERE w.ID_WYCIECZKI = ZmienLiczbeMiejsc.id_wycieczki;

    IF current_capacity >= new_liczba_miejsc THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie można zmniejszyć liczby miejsc');
    END IF;

    UPDATE WYCIECZKI w
    SET w.LICZBA_MIEJSC = new_liczba_miejsc
    WHERE w.ID_WYCIECZKI = ZmienLiczbeMiejsc.id_wycieczki;
END;


CALL ZmienLiczbeMiejsc(9, 4);
