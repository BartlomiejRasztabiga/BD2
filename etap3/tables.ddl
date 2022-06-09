CREATE USER bd2c076 IDENTIFIED BY bd2c076
    ACCOUNT UNLOCK;
    
CREATE USER bd2c076_app IDENTIFIED BY bd2c076_app
    ACCOUNT UNLOCK;

CREATE TABLE instytuty (
    id_instytutu NUMBER(6) NOT NULL,
    nazwa        VARCHAR2(100 CHAR) NOT NULL,
    id_wydzialu  NUMBER(6) NOT NULL
)
LOGGING;

COMMENT ON TABLE instytuty IS
    'Instytut na wydziale';

CREATE INDEX inst_wydz_fk_idx ON
    instytuty (
        id_wydzialu
    ASC )
        LOGGING;

GRANT ALL PRIVILEGES ON instytuty TO bd2c076 WITH GRANT OPTION;

ALTER TABLE instytuty ADD CONSTRAINT inst_pk PRIMARY KEY ( id_instytutu );

ALTER TABLE instytuty ADD CONSTRAINT inst_un UNIQUE ( nazwa );

CREATE TABLE przedmioty (
    kod_przedmiotu VARCHAR2(50 CHAR) NOT NULL,
    nazwa          VARCHAR2(100 CHAR) NOT NULL,
    id_instytutu   NUMBER(6) NOT NULL
)
LOGGING;

COMMENT ON TABLE przedmioty IS
    'Przedmiot prowadzony przez instytut';

COMMENT ON COLUMN przedmioty.kod_przedmiotu IS
    'Kod przedmiotu (np. 103C-INxxx-ISP-BD2)';

COMMENT ON COLUMN przedmioty.nazwa IS
    'Pełna nazwa przedmiotu (np. Bazy danych 2)';

COMMENT ON COLUMN przedmioty.id_instytutu IS
    'Identyfikator instytutu, który prowadzi przedmiot';

CREATE INDEX przed_inst_fk_idx ON
    przedmioty (
        id_instytutu
    ASC )
        LOGGING;

GRANT ALL PRIVILEGES ON przedmioty TO bd2c076 WITH GRANT OPTION;

ALTER TABLE przedmioty ADD CONSTRAINT przed_pk PRIMARY KEY ( kod_przedmiotu );

ALTER TABLE przedmioty ADD CONSTRAINT przed_un UNIQUE ( nazwa );

CREATE TABLE rozliczenia_semestrow (
    id_rozliczenia NUMBER(6) NOT NULL,
    rok            NUMBER(4) NOT NULL,
    okres          CHAR(1 CHAR) NOT NULL,
    numer_wersji   NUMBER(3) DEFAULT 1 NOT NULL
)
LOGGING;

ALTER TABLE rozliczenia_semestrow ADD CHECK ( rok >= 1970 );

ALTER TABLE rozliczenia_semestrow ADD CHECK ( numer_wersji >= 1 );

COMMENT ON TABLE rozliczenia_semestrow IS
    'Rozliczenie semestru (wszystkich zajęć przedmiotów dla danego semestru)';

COMMENT ON COLUMN rozliczenia_semestrow.rok IS
    'Rok semestru dla którego utworzono rozliczenie';

COMMENT ON COLUMN rozliczenia_semestrow.okres IS
    'Okres semestru dla którego utworzono rozliczenie';

COMMENT ON COLUMN rozliczenia_semestrow.numer_wersji IS
    'Numer wersji rozliczenia semestru';

GRANT ALL PRIVILEGES ON rozliczenia_semestrow TO bd2c076 WITH GRANT OPTION;

ALTER TABLE rozliczenia_semestrow ADD CONSTRAINT rozlsem_pk PRIMARY KEY ( id_rozliczenia );

ALTER TABLE rozliczenia_semestrow
    ADD CONSTRAINT rozlsem_un UNIQUE ( rok,
                                       okres,
                                       numer_wersji );

CREATE TABLE rozliczenia_zajec (
    id_rozliczenia                NUMBER(6) NOT NULL,
    liczba_godzin_rozliczeniowych NUMBER(5, 2) DEFAULT 30 NOT NULL,
    liczba_godzin_rzeczywistych   NUMBER(5, 2) DEFAULT 30 NOT NULL,
    typ_zajec                     CHAR(1 CHAR) DEFAULT 'W' NOT NULL,
    kod_przedmiotu                VARCHAR2(50 CHAR) NOT NULL
)
LOGGING;

ALTER TABLE rozliczenia_zajec ADD CHECK ( liczba_godzin_rozliczeniowych >= 0 );

ALTER TABLE rozliczenia_zajec ADD CHECK ( liczba_godzin_rzeczywistych >= 0 );

ALTER TABLE rozliczenia_zajec
    ADD CHECK ( typ_zajec IN ( 'C', 'L', 'P', 'W' ) );

COMMENT ON TABLE rozliczenia_zajec IS
    'Rozliczenie pojedynczych zajęć dla konkretnego semestru i rozliczenia';

COMMENT ON COLUMN rozliczenia_zajec.id_rozliczenia IS
    'Identyfikator rozliczenia semestru';

COMMENT ON COLUMN rozliczenia_zajec.typ_zajec IS
    'Typ zajęć przedmiotu dla którego zdefiniowano rozliczenie';

COMMENT ON COLUMN rozliczenia_zajec.kod_przedmiotu IS
    'Kod przedmiotu dla którego zdefiniowano rozliczenie';

GRANT ALL PRIVILEGES ON rozliczenia_zajec TO bd2c076 WITH GRANT OPTION;

ALTER TABLE rozliczenia_zajec
    ADD CONSTRAINT rozlzaj_pk PRIMARY KEY ( id_rozliczenia,
                                            typ_zajec,
                                            kod_przedmiotu );

CREATE TABLE semestry (
    rok   NUMBER(4) NOT NULL,
    okres CHAR(1 CHAR) NOT NULL
)
LOGGING;

ALTER TABLE semestry ADD CHECK ( rok >= 1970 );

ALTER TABLE semestry
    ADD CHECK ( okres IN ( 'L', 'Z' ) );

COMMENT ON TABLE semestry IS
    'Semestr roku akademickiego';

COMMENT ON COLUMN semestry.rok IS
    'Rok semestru (np. 2022)';

COMMENT ON COLUMN semestry.okres IS
    'Okres semestru - L (letni) lub Z (zimowy)';

GRANT ALL PRIVILEGES ON semestry TO bd2c076 WITH GRANT OPTION;

ALTER TABLE semestry ADD CONSTRAINT sem_pk PRIMARY KEY ( rok,
                                                         okres );

CREATE TABLE wydzialy (
    id_wydzialu NUMBER(6) NOT NULL,
    nazwa       VARCHAR2(100 CHAR) NOT NULL
)
LOGGING;

COMMENT ON TABLE wydzialy IS
    'Wydział na uczelni';

ALTER TABLE wydzialy ADD CONSTRAINT wydz_pk PRIMARY KEY ( id_wydzialu );

ALTER TABLE wydzialy ADD CONSTRAINT wydz_un UNIQUE ( nazwa );

CREATE TABLE zajecia (
    typ_zajec      CHAR(1 CHAR) DEFAULT 'W' NOT NULL,
    kod_przedmiotu VARCHAR2(50 CHAR) NOT NULL
)
LOGGING;

ALTER TABLE zajecia
    ADD CHECK ( typ_zajec IN ( 'C', 'L', 'P', 'W' ) );

COMMENT ON TABLE zajecia IS
    'Zajęcia prowadzone dla przedmiotu';

COMMENT ON COLUMN zajecia.typ_zajec IS
    'Typ zajęć:
W - wykład
C - ćwiczenia
L - laboratoria
P - projekt';

COMMENT ON COLUMN zajecia.kod_przedmiotu IS
    'Kod przedmiotu, dla którego zdefiniowano zajęcia';

GRANT ALL PRIVILEGES ON zajecia TO bd2c076 WITH GRANT OPTION;

ALTER TABLE zajecia ADD CONSTRAINT zaj_pk PRIMARY KEY ( kod_przedmiotu,
                                                        typ_zajec );

ALTER TABLE instytuty
    ADD CONSTRAINT inst_wydz_fk FOREIGN KEY ( id_wydzialu )
        REFERENCES wydzialy ( id_wydzialu )
    DEFERRABLE;

ALTER TABLE przedmioty
    ADD CONSTRAINT przed_inst_fk FOREIGN KEY ( id_instytutu )
        REFERENCES instytuty ( id_instytutu )
    DEFERRABLE;

ALTER TABLE rozliczenia_semestrow
    ADD CONSTRAINT rozlsem_sem_fk FOREIGN KEY ( rok,
                                                okres )
        REFERENCES semestry ( rok,
                              okres )
    DEFERRABLE;

ALTER TABLE rozliczenia_zajec
    ADD CONSTRAINT rozlzaj_rozlsem_fk FOREIGN KEY ( id_rozliczenia )
        REFERENCES rozliczenia_semestrow ( id_rozliczenia )
            ON DELETE CASCADE
    DEFERRABLE;

ALTER TABLE rozliczenia_zajec
    ADD CONSTRAINT rozlzaj_zaj_fk FOREIGN KEY ( kod_przedmiotu,
                                                typ_zajec )
        REFERENCES zajecia ( kod_przedmiotu,
                             typ_zajec )
            ON DELETE CASCADE
    DEFERRABLE;

ALTER TABLE zajecia
    ADD CONSTRAINT zaj_przed_fk FOREIGN KEY ( kod_przedmiotu )
        REFERENCES przedmioty ( kod_przedmiotu )
    DEFERRABLE;

GRANT SELECT, INSERT, UPDATE, DELETE ON instytuty TO bd2c076_app WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE ON przedmioty TO bd2c076_app WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE ON rozliczenia_semestrow TO bd2c076_app WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE ON rozliczenia_zajec TO bd2c076_app WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE ON semestry TO bd2c076_app WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE ON wydzialy TO bd2c076_app WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE ON zajecia TO bd2c076_app WITH GRANT OPTION;

