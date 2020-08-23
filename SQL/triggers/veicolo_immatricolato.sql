-- un veicolo immatricolato non puo' essere mai eliminato
create or replace function controlla_veicolo_immatricolato()
returns trigger
language plpgsql as
$$
    begin
        raise notice 'You cannot delete a record in this table'
        return null;
    end;
$$;

create trigger controlla_veicolo_immatricolato
before delete on veicoloimmatricolato
for each row
execute procedure controlla_veicolo_immatricolato(); 

-- La Versione del veicolo immatricolato deve essere appartenere al Modello immatricolato
