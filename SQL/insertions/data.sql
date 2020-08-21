
-- Proprietario
insert into Proprietario(cf, nome, cognome, residenza) 
values ('DKHTMG49H24I896S', 'Luca', 'Schiava', 'Milano');
insert into Proprietario(cf, nome, cognome, residenza) 
values ('VFKNDG91H65C623X', 'Vittorio', 'Alba', 'Milano');


-- Casa Produttrice
insert into CasaProduttrice(nome, direttore, contatto_telefonico, indirizzo_sede) 
values ('fiat', 'Luca Marco', '+393429956222', 'milano');


-- Modello
insert into Modello(id_modello, cilindrata, cavalli_fiscali, velocita_massima, numero_posti, alimentazione, classe_veicolo, motorizzazione, casa_produttrice) 
values ('500', 1200, 83, 150, 5, 'benzina', 'auto', '1.2multijet', 'fiat');


-- Versione
insert into Versione(numero_versione, numero_pezzi_prodotti, data_inizio_produzione, data_fine_produzione, modello) 
values ('Sport', 233, '2020-06-22', NULL);


-- Veicolo Immatricolato
insert into VeicoloImmatricolato(targa, data_immatricolazione, rottamato, propietario, modello, versione) 
values ('G4489SS', '2020-06-22 19:10:25', 0, 'DKHTMG49H24I896S', '500');


-- Cessione
insert into Cessione(data_passaggio, vecchio_propietario, nuovo_propietario, veicolo_immatricolato)
values ('2020-06-22 22:10:25', 'DKHTMG49H24I896S', 'DKHTMG49H24I896S', 'G4489SS');
