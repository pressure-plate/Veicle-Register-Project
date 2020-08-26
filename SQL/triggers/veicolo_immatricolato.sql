    -- Quando un veicolo viene rottamato (eliminazione dagli immatricolati) elimina anche tutte le cessioni.
start transaction; 

set search_path to MotorizzazioneCivile, public;

create or replace function elimina_veicolo_rottamato()
returns trigger
language plpgsql as
$$
    begin
        

            set search_path to MotorizzazioneCivile, public;

            if ( old.rottamato is false ) then 
                raise exception 'Non è possibile eliminare un veicolo già immatricolato';
                return null;
            end if;

    end;
$$;

create trigger elimina_veicolo_rottamato
before delete on veicoloimmatricolato
for each row
execute procedure elimina_veicolo_rottamato(); 

commit;
