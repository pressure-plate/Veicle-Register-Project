-- queesta funzione verifica che nel caso in cui venga fatto un passaggio
-- di proprietà la data d'immatricolazione sia precedente a quella del passaggio
-- di proprietà. In caso contrario il passaggio fallisce

create or replace function controllaDataImmatricolazioneEDataPassaggio()
returns trigger language plpgsql as
$$ 
    begin 
        select dataImmatricolazione, dataPassaggio
        from VeicoloImm union cessione 
        
        -- se il valore della data del passaggio è maggiore del valore della data precedente allora ok
        if (new.dataPassaggio > dataImmatricolazione) then
            return new; 
        end if;

         raise notice '% %: inserimento data passaggio non valida.'
         return null;
    end;
$$;

-- funzione che verifica che la data di fine produzione sia successiva a quella
-- di inizio produzione
create or replace function controllaDataInzioEFineProduzione()
return trigger language plpgsql as
$$ 
    begin 
        select dataInizioProduz, dataFineProduz
        from Versione

        if(new.dataFineProduz > dataInizioProduz) then
            return new;
        end if;

        raise notice '% %: data di fine produzione errata.'
        return null;

    end;
$$;




        