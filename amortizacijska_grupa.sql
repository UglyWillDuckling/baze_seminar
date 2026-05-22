CREATE TABLE amortizacijska_grupa (
	id INT PRIMARY KEY AUTO_INCREMENT,
	sifra INT NOT NULL,
	naziv VARCHAR(32) NOT NULL,
	stopa_amortizacije DECIMAL(10, 2) NOT NULL,
	osnovni_konto INT NOT NULL,

	FOREIGN KEY(osnovni_konto) REFERENCES konto(id)
)
