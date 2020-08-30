Se si desidera implementare la base di dati, basta seguire i passi descritti in questo file di testo.

Prima di fare ciò, è necessario però creare un'altro user all'interno del server di pgAdmin, e chiamarlo "utente";
Utente non deve essere un superuser, e non deve poter creare database o altri utenti/ruoli.

Una volta che si hanno due user ("utente", e lo user default "postgres"), si può implementare il db da linea di comando cmd, usando le seguenti istruzioni (Windows):

1) psql postgres postgres (per connettersi al db default)
2) inserire la password assegnata a postgres sul proprio pc per connettersi
3) copiare e lanciare il testo del file "db" che si trova nella cartella sorgenti (per creare il db Azienda)
4) \c Azienda (per connettersi al nuovo db)
5) copiare e lanciare il testo del file "database" (per creare tutto il database e popolarlo, SEGUIRE L'ORDINE dall'alto verso il basso)

Ora il database è pronto e popolato!
Se si vuole testare i permessi e provare ad effettuare operazioni, basta connettersi al database con lo user "utente" con il comando:
psql Azienda utente

Infine, se si vuole creare gli stessi grafici visibili in fondo alla relazione, basta aprire RStudio e copiare-incollare i comandi presenti nel file di testo "grafici", nella cartella delle sorgenti.





