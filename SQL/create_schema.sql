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
