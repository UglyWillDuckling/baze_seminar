CREATE TABLE amortizacijska_grupa (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sifra NUMBER NOT NULL,
    naziv VARCHAR2(32) NOT NULL,
    stopa_amortizacije NUMBER(10, 2) NOT NULL,
    osnovni_konto NUMBER NOT NULL,

    CONSTRAINT fk_amortizacijska_konto
        FOREIGN KEY (osnovni_konto)
        REFERENCES konto(id)
);
