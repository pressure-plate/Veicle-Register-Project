start transaction;


set search_path to MotorizzazioneCivile, public;


-- Propietario
insert into Propietario(cf, nome, cognome, residenza) 
values ('DKHTMG49H24I896S', 'Luca', 'Schiava', 'Milano');
insert into Propietario(cf, nome, cognome, residenza) 
values ('VFKNDG91H65C623X', 'Vittorio', 'Alba', 'Milano');


-- Casa Produttrice
insert into CasaProduttrice(nome, direttore, contatto_telefonico, indirizzo_sede) 
values ('fiat', 'Luca Marco', '+393429956222', 'milano');
insert into CasaProduttrice(nome, direttore, contatto_telefonico, indirizzo_sede) 
values ('audi', 'Paolo Moro', '+393336522786', 'milano');
insert into CasaProduttrice(nome, direttore, contatto_telefonico, indirizzo_sede) 
values ('toyota', 'Beppino Belli', '+39343542355', 'milano');


-- Modello
insert into Modello(modello, cilindrata, cavalli_fiscali, velocita_massima, numero_posti, alimentazione, classe_veicolo, casa_produttrice) 
values ('500', 1200, 83, 150, 5, 'benzina', 'auto', 'fiat');
insert into Modello(modello, cilindrata, cavalli_fiscali, velocita_massima, numero_posti, alimentazione, classe_veicolo, casa_produttrice) 
values ('A4', 2000, 130, 240, 5, 'diesel', 'auto', 'audi');


-- Allestimento
insert into Allestimento(nome, data_inizio_produzione, data_fine_produzione, modello) 
values ('SportMissionE', '2020-06-22', NULL, '500');
insert into Allestimento(nome, data_inizio_produzione, data_fine_produzione, modello) 
values ('SportBack', '2020-06-23', NULL, 'A4');


-- Veicolo Immatricolato
insert into VeicoloImmatricolato(targa, data_immatricolazione, propietario, modello, allestimento) 
values ('G4489SS', '2020-06-22 19:10:25', 'DKHTMG49H24I896S', '500', 'SportMissionE');
insert into VeicoloImmatricolato(targa, data_immatricolazione, propietario, modello, allestimento) 
values ('G5233CE', '2020-07-28 13:10:33', 'DKHTMG49H24I896S', 'A4', 'SportBack');


-- Cessione
insert into Cessione(data_passaggio, vecchio_propietario, nuovo_propietario, veicolo_immatricolato)
values ('2020-05-22 22:10:25', 'DKHTMG49H24I896S', 'VFKNDG91H65C623X', 'G4489SS');
insert into Cessione(data_passaggio, vecchio_propietario, nuovo_propietario, veicolo_immatricolato)
values ('2020-05-22 22:10:25', 'VFKNDG91H65C623X', 'DKHTMG49H24I896S', 'G4489SS');


commit;
