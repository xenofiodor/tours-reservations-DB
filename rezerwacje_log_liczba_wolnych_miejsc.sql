CREATE TABLE Rezerwacje_log
(
    ID INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    ID_Rezerwacji INT,
    DATA DATE,
    STATUS CHAR(1),
    CONSTRAINT REZERWACJE_LOG_PK PRIMARY KEY
    (
        ID
    )
    ENABLE
);

ALTER TABLE Rezerwacje_log
ADD CONSTRAINT REZERWACJE_LOG_FK1 FOREIGN KEY
(
    ID_Rezerwacji
)
REFERENCES REZERWACJE
(
    NR_REZERWACJI
)
ENABLE;

SELECT * FROM REZERWACJE_LOG;


ALTER TABLE WYCIECZKI
ADD LICZBA_WOLNYCH_MIEJSC INT;
ALTER TABLE WYCIECZKI
ADD CONSTRAINT MIEJSCA_CHECK CHECK
(
    LICZBA_WOLNYCH_MIEJSC <= LICZBA_MIEJSC
)
ENABLE;

SELECT * FROM WYCIECZKI;


CREATE OR REPLACE PROCEDURE PrzeliczLiczbeWolnychMiejsc
AS
BEGIN
    UPDATE WYCIECZKI w
    SET LICZBA_WOLNYCH_MIEJSC =
        LICZBA_MIEJSC - (SELECT COUNT(*)
                         FROM REZERWACJE r
                         WHERE r.ID_WYCIECZKI = w.ID_WYCIECZKI
                            AND STATUS != 'A')
    WHERE w.ID_WYCIECZKI IN (SELECT ID_WYCIECZKI FROM WYCIECZKI);
END;

CALL PrzeliczLiczbeWolnychMiejsc();
SELECT * FROM WYCIECZKI;

