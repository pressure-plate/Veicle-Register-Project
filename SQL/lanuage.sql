create database motorization

create table Veicolo
(
	ID_veicolo int not null
		constraint Veicolo_pk primary key,
	targa varchar,
	cilindrata float4,
	vel_max int
);

INSERT INTO Veicolo(ID_veicolo, targa) VALUES(12221, "TARGA6")

-- VIEW per contare
CREATE view CountX AS
SELECT field, COUNT(*) as nr_fiell
GROUP BY field
WHERE condition IN ... --(optional)
HAVING field IN (SELECT field FROM ...) -- il campo deve essere dello stesso tipo

SELECT DISTINCT ... FROM ... -- solo un elemento per tabella con lo stesso valore

-- quando le tabelle da joinare hanno le chiavi esterne e sono da fare comparazioni su entrambe le tabelle
NATURAL JOIN

ORDER BY ... DESC or ASC --ordina in ordine decrescente o crescente
NOT EXIST  -- se esite esiste anche nella corrente relazione

-- TRIGGERS
create or replace function verifica()
return trigger language plpgsql as
$$
declare
	counter_entita integer;
begin
	SELECT count(*) into counter_entita
	from tabella
	where condizione;

	if counter_entita <= then
		raise notice "messaggio";
		return null; -- annulla operazione
	end if;

	IF (TG_OP = "delete") then
		return old;
	ELSEIF (TG_OP = 'update') then
		return new,
	END IF;
end
$$
create trigger NOME_DEL_TRIGGER
before delete or update on TABLELLA
for each row execute procedure verifica()

--ALGEBRA
--si usa il prodotto cartesiano per contare
	C <- value F count(*)(B)
	D1 <- P count(*)->c2 (C)
	D2 <- P count(*)->c2, value->v(C)
	NoGood <- o c1 < c2 (D1xD2)

--usare l'inverso per estrarre i dati di solo
	B <- PI value1 (TAB_X) x PI value2 (TAB_Y)
	C <- B\A --le colonne che non sono membri di A

is null
is not null
