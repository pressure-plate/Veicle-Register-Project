-- La data di fine produzione di una versione deve essere successiva a quella di inizio produzione;
start transaction; 

set search_path to MotorizzazioneCivile, public;

create or replace function controlla_data_produzione()
returns trigger
language plpgsql as
$$

    begin 
        set search_path to MotorizzazioneCivile, public;

        -- se la data di fine produzione è precedente a quella d'inizio produzione abort
        if (new.data_fine_produzione < new.data_inizio_produzione ) then
            raise exception 'Errore, data fine produzione non può essere precedente ad inizio produzione';
            return null;
        end if;

        return new;
    end;

$$;


create trigger controlla_data_produzione
before insert or update on Allestimento
for each row
execute procedure controlla_data_produzione();


commit;

        