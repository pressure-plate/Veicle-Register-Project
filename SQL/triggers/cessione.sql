DROP TRIGGER IF EXISTS controlla_cessione_posessore_veicolo ON Cessione;
DROP TRIGGER IF EXISTS controlla_cessione_veicolo_rottamato ON Cessione;
DROP TRIGGER IF EXISTS controlla_soggetti_cessione ON Cessione;
DROP TRIGGER IF EXISTS update_propietaio ON Cessione;
DROP TRIGGER IF EXISTS impedisci_aggiornamento_cessione ON Cessione;
DROP TRIGGER IF EXISTS controlla_cessione ON Cessione;


create or replace function update_propietaio()
returns trigger
language plpgsql as
$$
    begin
        UPDATE VeicoloImmatricolato SET propietario = new.nuovo_propietario
        WHERE (targa = new.veicolo_immatricolato AND propietario = new.vecchio_propietario);

        return new;
    end;
$$;

create trigger update_propietaio
after insert on Cessione
for each row
execute procedure update_propietaio();


-- ----------------------------------------------


create or replace function controlla_cessione_stesso_propietario()
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
            raise exception 'Il proprietario non puo cedere il veicolo a se stesso';
            return null;
        end if;
        
        return new;
    end;
$$;

create trigger controlla_cessione
before insert on Cessione
for each row
execute procedure controlla_cessione();


-- ----------------------------------------------


create or replace function controlla_cessione_intestatario_corrente()
returns trigger
language plpgsql as
$$
    declare
        vecchio_propietario id_propietario;
    begin
        SELECT propietario INTO vecchio_propietario FROM VeicoloImmatricolato
            WHERE targa = new.veicolo_immatricolato;

        raise notice 'propietario corrente: "%" ', vecchio_propietario;

        -- se l'attuale intestatario e' diverso dal vecchio propietario abort
        if (vecchio_propietario <> new.vecchio_propietario) then
            raise exception 'Il vecchio propietario deve avere intestato il veicolo che sta cedendo';
            return null;
        end if;

        return new;
    end;
$$;

create trigger controlla_cessione_intestatario_corrente
before insert on Cessione
for each row
execute procedure controlla_cessione_intestatario_corrente();


-- ----------------------------------------------


create or replace function controlla_cessione_date()
returns trigger
language plpgsql as
$$
    declare
        data_immatricolazione timestamp;
        cessioni_successive record;
    begin

        SELECT data_immatricolazione INTO data_immatricolazione FROM VeicoloImmatricolato
            WHERE veicolo_immatricolato = new.veicolo_immatricolato;

        -- se la data di immatricolazione e' sucessica a quella di passaggio abort
        if (new.data_passaggio < data_immatricolazione) then
            raise exception 'Impossibile cedere un veicolo prima che sia immatricolato';
            return null;
        end if;

        SELECT * INTO cessioni_successive FROM Cessione
            WHERE data_passaggio >= new.data_passaggio;

        raise notice 'cessioni successive: "%" ', cessioni_successive;

        -- se la data di passaggio e' inferiore ad un passaggio gia' esistente abort
        if (cessioni_successive is not null) then
            raise exception 'Impossibile cedere il veicolo prima di una cessione gia effettuata, confilitti: "%" ', cessioni_successive;
            return null;
        end if;

        return new;
    end;
$$;

create trigger controlla_cessione_date
before insert on Cessione
for each row
execute procedure controlla_cessione_date(); 


-- ----------------------------------------------


create or replace function controlla_cessione_veicolo_rottamato()
returns trigger
language plpgsql as
$$
    declare
        rottamato BOOLEAN;
    begin
        -- se il veicolo e' gia' stato rottamato abort
        if (veicolo_immatricolato.rottamato = true) then
            raise exception 'Impossibile cedere un veicolo rottamato';
            return null;
        end if;

        return new;
    end;
$$;

create trigger controlla_cessione_veicolo_rottamato
before insert on Cessione
for each row
execute procedure controlla_cessione_veicolo_rottamato();


-- ----------------------------------------------


create or replace function impedisci_aggiornamento_cessione()
returns trigger
language plpgsql as
$$  
    begin
        -- se la persona e' la stessa abort
        if (new <> old) then
            raise exception 'Impossibile modificare/cancellare una cessione, per correggere un errore, effettuare una nuova cessione al propietario precedente e ripetere';
            return null;
        end if;
        return new;
    end;
$$;

create trigger impedisci_aggiornamento_cessione
before update on Cessione
for each row
execute procedure impedisci_aggiornamento_cessione();

