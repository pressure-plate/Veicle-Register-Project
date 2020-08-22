create or replace function propietario_controlla_cancellazione()
returns trigger
language plpgsql as
$$  
    declare
        veicoli record
    begin
        SELECT * INTO veicoli FROM VeicoliImmatricolati
            WHERE propietario >= old.cf;

        if (veicoli is not null) then
            raise exception 'Impossibile cancellare il propietario, confilitti: "%" ', veicoli;
            return null;
        end if;

        return new;
    end;
$$;

create trigger propietario_controlla_cancellazione
before delete on Propietario
for each row
execute procedure propietario_controlla_cancellazione();
