create schema vehicle_register;


create table vehicle_register.VeicoloImmatricolato
(
	ID_veicolo int not null
		constraint VeicoloImmatricolato_pk
			primary key,
	targa varchar,
	cilindrata float4,
	cavalli float4,
	vel_max int
);

CREATE TABLE corsi (
    id INTEGER NOT NULL PRIMARY KEY,
    nome_corso VARCHAR(50) NOT NULL,
    ore_corso INTEGER NOT NULL,
);
