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
                raise exception 'cazzo fai coglione';
                return null;
            end if;

            DELETE 
            FROM CESSIONE
            WHERE targa = cessioni.veicolo_immatricolato;

            return new;

            

    end;
$$;

create trigger elimina_veicolo_rottamato
before delete on veicoloimmatricolato
for each row
execute procedure elimina_veicolo_rottamato(); 

commit;



-- ************************************************
set search_path to MotorizzazioneCivile, public;

delete from VeicoloImmatricolato
where targa = 'G5233CE' and data_immatricolazione= '2020-07-28 13:10:33' and 
propietario = 'DKHTMG49H24I896S' and modello = 'A4' and allestimento='SportBack';


insert into veicolo_immatricolato(targa, )