
-- Propietario
insert into Propietario(cf, nome, cognome, residenza) 
values ('DKHTMG49H24I896S', 'Luca', 'Schiava', 'Milano');
insert into Propietario(cf, nome, cognome, residenza) 
values ('VFKNDG91H65C623X', 'Vittorio', 'Alba', 'Milano');


-- Casa Produttrice
insert into CasaProduttrice(nome, direttore, contatto_telefonico, indirizzo_sede) 
values ('fiat', 'Luca Marco', '+393429956222', 'milano');


-- Modello
insert into Modello(id_modello, cilindrata, cavalli_fiscali, velocita_massima, numero_posti, alimentazione, classe_veicolo, casa_produttrice) 
values ('500', 1200, 83, 150, 5, 'benzina', 'auto', 'fiat');


-- Versione
insert into Versione(nome_versione, data_inizio_produzione, data_fine_produzione, modello) 
values ('SportMissionE', '2020-06-22', NULL, '500');


-- Veicolo Immatricolato
insert into VeicoloImmatricolato(targa, data_immatricolazione, propietario, modello, versione) 
values ('G4489SS', '2020-06-22 19:10:25', 'DKHTMG49H24I896S', '500', 'SportMissionE');


-- Cessione
insert into Cessione(data_passaggio, vecchio_propietario, nuovo_propietario, veicolo_immatricolato)
values ('2020-05-22 22:10:25', 'DKHTMG49H24I896S', 'VFKNDG91H65C623X', 'G4489SS'); -- viola per data
insert into Cessione(data_passaggio, vecchio_propietario, nuovo_propietario, veicolo_immatricolato)
values ('2020-05-22 22:10:25', 'VFKNDG91H65C623X', 'DKHTMG49H24I896S', 'G4489SS');

