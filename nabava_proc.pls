CREATE OR REPLACE PROCEDURE nabava(
    p_naziv            VARCHAR2,
    p_opis             VARCHAR2,
    p_vrijednost       NUMBER(10,2),
    p_am_grupa         NUMBER,
    p_inventarni_broj  NUMBER,
    p_id               OUT NUMBER
)
AS
BEGIN
    IF p_vrijednost < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Vrijednost ne moze bit negativna');
    END IF;

    IF TRIM(p_naziv) IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Naziv ne smije biti prazan');
    END IF;

    INSERT INTO sredstvo(
        naziv,
        opis,
        trenutna_vrijednost,
        nabavna_vrijednost,
        am_grupa,
        inventarni_broj
    )
    VALUES (
        p_naziv,
        p_opis,
        p_vrijednost,
        p_vrijednost,
        p_am_grupa,
        p_inventarni_broj
    )
    RETURNING id INTO p_id;

    -- Insert into transakcije with reference
    INSERT INTO transakcije(vrsta)
    VALUES ('nabava');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20003, 'Inventarni broj već postoji');
    WHEN OTHERS THEN
        RAISE;
END;
