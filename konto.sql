CREATE TABLE konto (
	id INT PRIMARY KEY AUTO_INCREMENT,
	sifra INT NOT NULL,
	naziv VARCHAR(32),
	status_konta VARCHAR(16) NOT NULL CHECK status_konta IN ('aktivan', 'neaktivan'),
	tip_konta VARCHAR(16) NOT NULL CHECK tip_konta IN ('dugovni', 'potrazni')
)
