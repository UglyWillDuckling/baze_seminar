
CREATE OR REPLACE VIEW pregled_imovine AS
SELECT
    sr.inventarni_broj,
    sr.opis,
    sr.amortizacijska_grupa,
    sr.nabavna_vrijednost,
    sr.trenutna_vrijednost,
    ag.naziv AS naziv_am_grupe,
    ag.sifra AS sifra_am_grupe
FROM sredstvo sr
JOIN amortizacijska_grupa ag
    ON sr.amortizacijska_grupa = ag.id;
