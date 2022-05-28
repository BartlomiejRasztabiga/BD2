CREATE OR REPLACE TRIGGER rozlsem_numer_wersji_trg 
    BEFORE INSERT ON Rozliczenia_semestrow 
    FOR EACH ROW 
    ENABLE 
DECLARE
    next_numer_wersji number(3);
BEGIN
-- ustawia ROZLICZENIA_SEMESTROW.NUMER_WERSJI na kolejna dostepna liczbe porzadkowa dla danej pary (rok, okres) --
    SELECT COALESCE(MAX(numer_wersji), 0) + 1 INTO next_numer_wersji FROM rozliczenia_semestrow WHERE rok=:new.rok AND okres=:new.okres;
    :new.numer_wersji := next_numer_wersji;
END; 
/

CREATE OR REPLACE TRIGGER fkntm_instytuty BEFORE
    UPDATE OF id_wydzialu ON instytuty FOR EACH ROW
    WHEN (new.id_wydzialu <> old.id_wydzialu)
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table Instytuty is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_rozliczenia_semestrow BEFORE
    UPDATE OF rok, okres ON rozliczenia_semestrow FOR EACH ROW
    WHEN (new.rok <> old.rok OR new.okres <> old.okres)
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table Rozliczenia_semestrow is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_rozliczenia_zajec BEFORE
    UPDATE OF id_rozliczenia, kod_przedmiotu, typ_zajec ON rozliczenia_zajec FOR EACH ROW
    WHEN (new.id_rozliczenia <> old.id_rozliczenia OR new.kod_przedmiotu <> old.kod_przedmiotu OR new.typ_zajec <> old.typ_zajec)
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table Rozliczenia_zajec is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_zajecia BEFORE
    UPDATE OF kod_przedmiotu ON zajecia FOR EACH ROW
    WHEN (new.kod_przedmiotu <> old.kod_przedmiotu)
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table Zajecia is violated');
END;
/

CREATE SEQUENCE inst_id_instytutu_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER inst_id_instytutu_trg BEFORE
    INSERT ON instytuty
    FOR EACH ROW
    WHEN ( new.id_instytutu IS NULL )
BEGIN
    :new.id_instytutu := inst_id_instytutu_seq.nextval;
END;
/

CREATE SEQUENCE rozlsem_id_rozliczenia_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER rozlsem_id_rozliczenia_trg BEFORE
    INSERT ON rozliczenia_semestrow
    FOR EACH ROW
    WHEN ( new.id_rozliczenia IS NULL )
BEGIN
    :new.id_rozliczenia := rozlsem_id_rozliczenia_seq.nextval;
END;
/

CREATE SEQUENCE wydz_id_wydzialu_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER wydz_id_wydzialu_trg BEFORE
    INSERT ON wydzialy
    FOR EACH ROW
    WHEN ( new.id_wydzialu IS NULL )
BEGIN
    :new.id_wydzialu := wydz_id_wydzialu_seq.nextval;
END;
/

