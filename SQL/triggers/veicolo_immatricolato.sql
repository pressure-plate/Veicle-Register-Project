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

-- La data di fine produzione di una versione deve essere successiva a quella di inizio produzione;
create or replace function controlla_data_produzione()
return trigger
language plpgsql as
$$
    declare data_inizio_produzione timestamp;

    begin 
        set search_path to MotorizzazioneCivile, public;

        SELECT data_inizio_produzione.Allestimento INTO data_inizio_produzione
        FROM Allestimento
        WHERE nome = new.Allestimento 

        -- se la data di fine produzione è precedente a quella d'inizio produzione abort
        if (new.data_fine_produzione < data_inizio_produzione && data_inizio_produzione not null)
            raise exception 'Errore, data fine produzione non può essere precedente';
            return null;
        end if;

        return new;
    end;

$$;


create trigger controlla_data_produzione
before insert or update on Allestimento
for each row
execute procedure controlla_data_produzione();


