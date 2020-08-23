-- Quando un veicolo viene rottamato (eliminazione dagli immatricolati) elimina anche tutte le cessioni.
create or replace function controlla_veicolo_immatricolato()
returns trigger
language plpgsql as
$$
    begin
            
    end;
$$;

create trigger controlla_veicolo_immatricolato
before delete on veicoloimmatricolato
for each row
execute procedure controlla_veicolo_immatricolato(); 




