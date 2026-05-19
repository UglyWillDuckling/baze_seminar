
-- `Otpis`:
-- promjena statusa imovine, i dodaje zapis u tablicu transakcija

CREATE OR REPLACE PROCEDURE otpis (
    p_sredstvo_id IN NUMBER
)
AS
BEGIN
    UPDATE sredstvo SET status = 'otpisano' WHERE id = p_sredstvo_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Sredstvo s ID ' || p_sredstvo_id || ' nije ažurirano.'
        );
    END IF;

    INSERT INTO transakcije (vrsta, entity_id) VALUES ('otpis', p_sredstvo_id);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
