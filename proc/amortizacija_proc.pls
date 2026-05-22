
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
    v_status sredstvo.status%TYPE;
BEGIN
    -- Ako sredstvo ne postoji Oracle ce baciti NO_DATA_FOUND gresku
    SELECT
        s.nabavna_vrijednost,
        s.datum_amortizacije,
        ag.stopa_amortizacije
        INTO
            v_osnovica,
            v_datum_amortizacije,
            v_stopa_amortizacije
     FROM sredstvo s
        INNER JOIN amortizacijska_grupa ag ON s.am_grupa=ag.id
    WHERE s.id = p_sredstvo_id
    FOR UPDATE WAIT 5;

    IF v_status != 'aktivno' THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'Amortizacija je dozvoljena samo za aktivna sredstva.'
        );
    END IF;

    IF v_datum_amortizacije IS NOT NULL AND
        EXTRACT(YEAR FROM v_datum_amortizacije) = EXTRACT(YEAR FROM SYSDATE)
    THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Sredstvo s ID ' || p_sredstvo_id || ' je vec amortizirano ove godine.'
        );
    END IF;

    v_iznos_amortizacije := v_osnovica * (v_stopa_amortizacije / 100);

    UPDATE sredstvo SET
            trenutna_vrijednost=GREATEST(trenutna_vrijednost - v_iznos_amortizacije, 0),
            ukupni_iznos_amortizacija=(ukupni_iznos_amortizacija + v_iznos_amortizacije),
            godisnji_iznos_amortizacije=v_iznos_amortizacije,
            datum_amortizacije=SYSDATE
    WHERE id=p_sredstvo_id;

    INSERT INTO transakcije (vrsta, entity_id) VALUES ('godisnja_amortizacija', p_sredstvo_id);

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Sredstvo s ID ' || p_sredstvo_id || ' ne postoji.'
        );

    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
