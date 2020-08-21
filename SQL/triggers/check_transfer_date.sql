



create trigger controlla_data_cessione
before insert on Cessione
for each row
execute procedure controlla_data_cessione();

create trigger controlla_data_cessione_upd_cessione
before update on Cessione
for each row
when (new.data_passaggio <> old.data_passaggio)
execute procedure controlla_data_cessione();

create trigger controlla_data_cessione_upd_veicolo_immatricolato
before update on VeicoloImmatricolato
for each row
when (new.data_immatricolazione <> old.data_immatricolazione)
execute procedure controlla_data_cessione();