create schema vehicle_register;


create table vehicle_register.VeicoloImmatricolato
(
	ID_veicolo int not null
		constraint VeicoloImmatricolato_pk
			primary key,
	targa varchar(10),
	cilindrata float4,
	cavalli float4,
	vel_max int
);

create table vehicle_register.Modello
(
  ID_modello int primary key,
  nome_modello varchar(10),
  alimentazione int(2),
  fabbrica int references vehicle_register.Fabbrica(ID_fabbrica)
);

create table vehicle_register.Fabbrica
(
  ID_fabbrica int primary key,
  città varchar(10),
);

create table vehicle_register.Versione
(
  ID_versione int primary key,
  anno_versione int(4),
  mese_versione int(2),
  data_inizio_produzione date,
  data_fine_produzione date,
  numero_pezzi_prodotti int default 0,
  modello int references vehicle_register.modello(ID_modello)
);
