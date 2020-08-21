create or replace function controlla_cessione()
returns trigger
language plpgsql as
$$
    declare
        vecchio_propietario id_propietario;
	    nuovo_propietario id_propietario;
    
    begin
        SELECT cf INTO vecchio_propietario FROM Propietario
            WHERE cf = new.vecchio_propietario;
        
        SELECT cf INTO nuovo_propietario FROM Propietario
            WHERE cf = new.nuovo_propietario;

        -- se la persona e' la stessa abort
        if (vecchio_propietario == nuovo_propietario) then
            raise exception 'In proprietario non puo cedere il veicolo a se stesso';
            return null;
        end if;

        -- aggiornameno del propietario nella tabella VeicoloImmatiricolato
        UPDATE VeicoloImmatricolato SET propietario = new.nuovo_propietario
        WHERE (targa = new.veicolo_immatricolato AND propietario = new.vecchio_propietario)
        return new;
    end;
$$;


create or replace function controlla_cessione_veicolo_rottamato()
returns trigger
language plpgsql as
$$  
    declare    
        stato_veicolo boolean
    begin
        SELECT rottamato INTO stato_veicolo FROM VeicoloImmatricolato
            WHERE targa = new.veicolo_immatricolato;

        -- se la persona e' la stessa abort
        if (stato_veicolo == 1) then
            raise exception 'Impossibile cedere un veicolo rottamato';
            return null;
        end if;
        return new;
    end;
$$;

-- controllo proprietario
create trigger controlla_cessione
before insert on Cessione
for each row
execute procedure controlla_cessione();

create trigger controlla_cessione
before update on Cessione
for each row
when ((new.vecchio_propietario <> old.vecchio_propietario) and (new.nuovo_propietario <> old.nuovo_propietario))
execute procedure controlla_cessione();

-- Aggiornamento della cessiona
create trigger controlla_cessione_upd_cessione
before update on Cessione
for each row
when (new.data_passaggio <> old.data_passaggio)
execute procedure controlla_cessione();

-- Aggiornamento del veicolo immatricolato
create trigger controlla_cessione_upd_veicolo_immatricolato
before update on VeicoloImmatricolato
for each row
when (new.data_immatricolazione <> old.data_immatricolazione)
execute procedure controlla_cessione();
