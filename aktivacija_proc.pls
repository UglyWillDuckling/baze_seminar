
-- `Aktivacija`:
-- promjena statusa na sredstvu i datuma aktivacije, i dodaje zapis u tablicu transakcija

CREATE OR REPLACE PROCEDURE aktivacija (
    p_sredstvo_id IN NUMBER
)
AS
BEGIN
    UPDATE sredstvo SET status = 'aktivno' WHERE id = p_sredstvo_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Sredstvo s ID ' || p_sredstvo_id || ' nije ažurirano.'
        );
    END IF;

    INSERT INTO transakcije (vrsta, entity_id) VALUES ('aktivacija', p_sredstvo_id);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- NOTE: it's important to rollback
        RAISE;
END;
