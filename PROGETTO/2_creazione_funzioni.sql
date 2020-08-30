start transaction;


set search_path to MotorizzazioneCivile, public;


-- ---------------------------------------------
-- Una volta che tutti i trigger su cessione sono stati verificati
-- Aggiorna i dati del nuovo propietario anche sulla tabella VeicoloImmatricolato
-- Ultimando cosi effettivamente il passaggio di propieta'
-- ---------------------------------------------

create or replace function update_propietaio()
returns trigger
language plpgsql as
$$
    begin
        set search_path to MotorizzazioneCivile, public;
        
        UPDATE VeicoloImmatricolato SET propietario = new.nuovo_propietario
        WHERE (targa = new.veicolo_immatricolato);

        raise notice 'propietario aggiornato in VeicoloImmatricolato: "%" ', new.nuovo_propietario;

        return new;
    end;
$$;

create trigger update_propietaio
after insert on Cessione
for each row
execute procedure update_propietaio();


-- ---------------------------------------------
-- Impedisci ad un propietario di cedere il veicolo a se stesso
-- ---------------------------------------------

create or replace function controlla_cessione_stesso_propietario()
returns trigger
language plpgsql as
$$
    declare
        vecchio_propietario id_propietario;
	    nuovo_propietario id_propietario;
    begin
        set search_path to MotorizzazioneCivile, public;

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

create trigger controlla_cessione_stesso_propietario
before insert on Cessione
for each row
execute procedure controlla_cessione_stesso_propietario();


-- ---------------------------------------------
-- La cessione non puo' avvenire se il vecchio_propietario
-- non e' il propietario del veicolo che sta cedendo
-- ---------------------------------------------

create or replace function controlla_cessione_intestatario_corrente()
returns trigger
language plpgsql as
$$
    declare
        vecchio_propietario id_propietario;
    begin
        set search_path to MotorizzazioneCivile, public;

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


-- ---------------------------------------------
-- La data di cessione del veicolo non puo' essere antecedente 
-- all'immatricolazione dello stesso;
--
-- Inoltre la data di cessione non puo' essere antecedente ad un'altra cessione 
-- per lo stesso veicolo
-- ---------------------------------------------

create or replace function controlla_cessione_date()
returns trigger
language plpgsql as
$$
    declare
        data_immatricolazione timestamp;
        cessioni_successive record;
    begin
        set search_path to MotorizzazioneCivile, public;

        SELECT VeicoloImmatricolato.data_immatricolazione INTO data_immatricolazione FROM VeicoloImmatricolato
            WHERE targa = new.veicolo_immatricolato;

        -- se la data di immatricolazione e' sucessiva a quella di passaggio abort
        if (new.data_passaggio < data_immatricolazione) then
            raise exception 'Impossibile cedere un veicolo prima che sia immatricolato';
            return null;
        end if;

        SELECT * INTO cessioni_successive FROM Cessione
            WHERE ((data_passaggio >= new.data_passaggio) and (veicolo_immatricolato = new.veicolo_immatricolato));

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


-- ---------------------------------------------
-- Non e' possibile cedere un veicolo rottamato
-- ---------------------------------------------

create or replace function controlla_cessione_veicolo_rottamato()
returns trigger
language plpgsql as
$$
    declare
        rottamato boolean;
    begin
        set search_path to MotorizzazioneCivile, public;

        SELECT VeicoloImmatricolato.rottamato INTO rottamato FROM VeicoloImmatricolato
            WHERE targa = new.veicolo_immatricolato;
        
        -- se il veicolo e' gia' stato rottamato abort
        if (rottamato = true) then
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


-- ---------------------------------------------
-- Non e' possibile cancellare una cessione sucessivamente alla creazione
-- In quanto l'incerimento in cessione modifica la tabella VeicoloImmatricolato
-- E' necessario eseguire una nuova cessione per riparare ad un errore
-- ---------------------------------------------

create or replace function impedisci_modifica_su_cessione()
returns trigger
language plpgsql as
$$  
    begin
        -- impedisci modifica
        raise exception 'Impossibile modificare/cancellare una cessione, per correggere un errore, effettuare una nuova cessione';
            return null;
    end;
$$;

create trigger impedisci_modifica_su_cessione_upd
before update on Cessione
for each row
execute procedure impedisci_modifica_su_cessione();

create trigger impedisci_modifica_su_cessione_del
before delete on Cessione
for each row
execute procedure impedisci_modifica_su_cessione();


-- ---------------------------------------------
-- Non è possibile eliminare un veicolo immatricolato
-- Deve essere rottamato prima del poter essere eliminato
-- ---------------------------------------------

create or replace function elimina_veicolo_rottamato()
returns trigger
language plpgsql as
$$
    begin
        

            set search_path to MotorizzazioneCivile, public;

            if ( old.rottamato is false ) then 
                raise exception 'Non è possibile eliminare un veicolo immatricolato';
                return null;
            end if;

    end;
$$;

create trigger elimina_veicolo_rottamato
before delete on veicoloimmatricolato
for each row
execute procedure elimina_veicolo_rottamato(); 


-- ---------------------------------------------
-- se la data di fine produzione è precedente a quella d'inizio produzione ignora
-- ---------------------------------------------

create or replace function controlla_data_produzione()
returns trigger
language plpgsql as
$$

    begin 
        set search_path to MotorizzazioneCivile, public;

        -- se la data di fine produzione è precedente a quella d'inizio produzione abort
        if (new.data_fine_produzione < new.data_inizio_produzione ) then
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


commit;
