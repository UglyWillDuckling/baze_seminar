CREATE TABLE transakcije (
	id NUMBER PRIMARY KEY AUTO_INCREMENT,
	datum NOT NULL DEFAULT SYSDATE,
	vrsta VARCHAR(32) NOT NULL CHECK STATUS IN (
		'nabava', 'aktivacija',	'rashod', 'otpis', 'godisnja_amortizacija')
),
entity_id INT NOT NULL
