CREATE OR REPLACE TRIGGER rozlsem_numer_wersji_trg BEFORE
    INSERT ON rozliczenia_semestrow
    FOR EACH ROW
    DECLARE
        next_numer_wersji number(3);
BEGIN
    SELECT COALESCE(MAX(numer_wersji), 0) + 1 INTO next_numer_wersji FROM rozliczenia_semestrow WHERE rok=:new.rok AND okres=:new.okres;
    :new.numer_wersji := next_numer_wersji;
END;
/
