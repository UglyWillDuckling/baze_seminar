CREATE TABLE konto (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sifra NUMBER NOT NULL,
    naziv VARCHAR2(32),
    status_konta VARCHAR2(16) NOT NULL,
    tip_konta VARCHAR2(16) NOT NULL,

    CONSTRAINT chk_status_konta
        CHECK (status_konta IN ('aktivan', 'neaktivan')),

    CONSTRAINT chk_tip_konta
        CHECK (tip_konta IN ('dugovni', 'potrazni'))
);
