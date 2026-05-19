
-- `Amortizacija`:
-- koja će umanjiti trenutnu vrijednost sredstva za iznos: osnovica amort. x stopa amortizacije,
-- pri tome, istim tim iznosom uvećati ukupni iznos amortizacije na sredstvu. i dodaje zapis u tablicu transakcija
-- **Pri tome treba paziti da se sredstvo može amortizirati samo jednom godišnje.**


CREATE OR REPLACE PROCEDURE amortizacija (
    p_sredstvo_id IN NUMBER
)
AS
    v_datum_amortizacije DATE;
    v_stopa_amortizacije NUMBER;
    v_osnovica NUMBER;
    v_iznos_amortizacije NUMBER;
BEGIN
    SELECT
        s.nabavna_vrijednost into v_osnovica,
        s.datum_amortizacije into v_datum_amortizacije,
        ag.stopa_amortizacije INTO v_stopa_amortizacije,
    INNER JOIN amortizacijska_grupa ag on s.am_grupa=ag.id
    FROM sredstvo s WHERE id=p_sredstvo_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Sredstvo s ID ' || p_sredstvo_id || ' ne postoji.'
        );
    END IF;

    IF EXTRACT(YEAR FROM v_datum_amortizacije) = EXTRACT(YEAR FROM SYSDATE) THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Sredstvo s ID ' || p_sredstvo_id || ' je vec amortizirano ove godine.'
        );
    END IF;

    v_iznos_amortizacije := v_osnovica * (v_stopa_amortizacije / 100);

    UPDATE sredstvo SET
            trenutna_vrijednost=(trenutna_vrijednost - v_iznos_amortizacije),
            ukupni_iznos_amortizacija=(ukupni_iznos_amortizacija + v_iznos_amortizacije),
            godisnji_iznos_amortizacije=v_iznos_amortizacije,
            datum_amortizacije=SYSDATE
    WHERE id=p_sredstvo_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Sredstvo s ID ' || p_sredstvo_id || ' nije ažurirano. Amortizacija neuspjela.'
        );
    END IF;

    INSERT INTO transakcije (vrsta, entity_id) VALUES ('godisnja_amortizacija', p_sredstvo_id);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
