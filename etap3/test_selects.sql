set echo on
set linesize 300
set pagesize 500
spool BD2C076_TEST.LIS

SELECT * FROM ROZLICZENIA_ZAJEC rozlzaj
LEFT JOIN ZAJECIA zaj ON (rozlzaj.typ_zajec = zaj.typ_zajec AND rozlzaj.kod_przedmiotu = zaj.kod_przedmiotu)
LEFT JOIN ROZLICZENIA_SEMESTROW rozlsem ON (rozlzaj.id_rozliczenia = rozlsem.id_rozliczenia)
WHERE rozlzaj.kod_przedmiotu = '103C-INxxx-ISP-BD2' AND rozlsem.rok = 2022 AND rozlsem.okres = 'Z' AND rozlsem.numer_wersji = 1;

SELECT * FROM PRZEDMIOTY przed
LEFT JOIN INSTYTUTY inst ON (przed.id_instytutu = inst.id_instytutu)
LEFT JOIN WYDZIALY wydz ON (inst.id_wydzialu = wydz.id_wydzialu);

SELECT rozlsem.id_rozliczenia, sem.rok, sem.okres, rozlsem.numer_wersji FROM SEMESTRY sem
RIGHT JOIN ROZLICZENIA_SEMESTROW rozlsem ON (sem.rok = rozlsem.rok AND sem.okres = rozlsem.okres)
ORDER BY sem.rok ASC, sem.okres, rozlsem.numer_wersji ASC;

SELECT DISTINCT(typ_zajec) FROM ZAJECIA;

spool off
