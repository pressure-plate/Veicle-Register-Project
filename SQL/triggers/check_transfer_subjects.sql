create or replace function controlla_soggetti_cessione()
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
        return new;
    end;
$$;


create trigger controlla_soggetti_cessione
before insert on Cessione
for each row
execute procedure controlla_soggetti_cessione();
