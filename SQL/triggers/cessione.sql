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
        if (vecchio_propietario = nuovo_propietario) then
            raise exception 'In proprietario non puo cedere il veicolo a se stesso';
            return null;
        end if;

        if (vecchio_propietario = nuovo_propietario) then
            raise exception 'In proprietario non puo cedere il veicolo a se stesso';
            return null;
        end if;

        -- aggiornameno del propietario nella tabella VeicoloImmatiricolato
        -- UPDATE VeicoloImmatricolato SET propietario = new.nuovo_propietario
        -- WHERE (targa = new.veicolo_immatricolato AND propietario = new.vecchio_propietario);
        return new;
    end;
$$;

DROP TRIGGER IF EXISTS controlla_cessione ON Cessione;
DROP TRIGGER IF EXISTS controlla_cessione_upd ON Cessione;

create trigger controlla_cessione
before insert on Cessione
for each row
execute procedure controlla_cessione();

create trigger controlla_cessione_upd
before update on Cessione
for each row
when (
    (new.vecchio_propietario <> old.vecchio_propietario) and 
    (new.nuovo_propietario <> old.nuovo_propietario)
)
execute procedure controlla_cessione();


-- ----------------------------------------------


-- controlla che il veicolo che si sta cedendo e' del proprietario
create or replace function controlla_cessione_veicolo_rottamato()
returns trigger
language plpgsql as
$$  
    declare    
        propietario_corrente id_propietario; 
    begin
        SELECT propietario INTO propietario_corrente FROM VeicoloImmatricolato
            WHERE targa = new.veicolo_immatricolato;

        raise notice 'propietario corrente: "%" ', propietario_corrente;

        -- se la persona e' la stessa abort
        if (propietario_corrente <> new.vecchio_propietario) then
            raise exception 'Il vecchio propietario deve avere intestato il veicolo che sta cedendo';
            return null;
        end if;
        return new;
    end;
$$;


DROP TRIGGER IF EXISTS controlla_cessione_veicolo_rottamato ON Cessione;
DROP TRIGGER IF EXISTS controlla_cessione_veicolo_rottamato_upd ON Cessione;

create trigger controlla_cessione_veicolo_rottamato
before insert on Cessione
for each row
execute procedure controlla_cessione_veicolo_rottamato();

create trigger controlla_cessione_veicolo_rottamato_upd
before update on Cessione
for each row
execute procedure controlla_cessione_veicolo_rottamato();


-- ----------------------------------------------


create or replace function controlla_cessione_posessore_veicolo()
returns trigger
language plpgsql as
$$  
    declare    
        stato_veicolo boolean;
    begin
        SELECT rottamato INTO stato_veicolo FROM VeicoloImmatricolato
            WHERE targa = new.veicolo_immatricolato;

        -- se la persona e' la stessa abort
        if (stato_veicolo = true) then
            raise exception 'Impossibile cedere un veicolo rottamato';
            return null;
        end if;
        return new;
    end;
$$;

DROP TRIGGER IF EXISTS controlla_cessione_posessore_veicolo ON Cessione;
DROP TRIGGER IF EXISTS controlla_cessione_posessore_veicolo_upd ON Cessione;

-- Aggiornamento del veicolo immatricolato
create trigger controlla_cessione_posessore_veicolo
before insert on Cessione
for each row
execute procedure controlla_cessione_posessore_veicolo();

create trigger controlla_cessione_posessore_veicolo_upd
before update on Cessione
for each row
execute procedure controlla_cessione_posessore_veicolo();
