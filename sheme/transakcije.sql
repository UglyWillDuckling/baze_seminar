CREATE TABLE transakcije (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datum DATE DEFAULT SYSDATE NOT NULL,
    vrsta VARCHAR2(32) NOT NULL,
    entity_id NUMBER NOT NULL,

    CONSTRAINT chk_vrsta CHECK (
        vrsta IN (
            'nabava',
            'aktivacija',
            'rashod',
            'otpis',
            'godisnja_amortizacija'
        )
    )
);
