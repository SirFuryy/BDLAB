-- controlli che un docente universitario non abbia più di 3 corsi assegnati? --

CREATE OR REPLACE FUNCTION controlla_numero_corsi()
  RETURNS TRIGGER AS
$$
DECLARE
  numero_corsi INTEGER;
BEGIN
  SELECT COUNT(*) INTO numero_corsi
  FROM Corsi
  WHERE docente_id = NEW.docente_id;
  
  IF numero_corsi >= 3 THEN
    RAISE EXCEPTION 'Il docente ha già assegnati tre corsi.';
  END IF;
  
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;
--Come crearlo:
CREATE TRIGGER controllo_numero_corsi_trigger
  BEFORE INSERT OR UPDATE ON Corsi
  FOR EACH ROW
  EXECUTE FUNCTION controlla_numero_corsi();





-- controllare se uno studente può iscriversi a un esame solo se ha ricevuto un voto maggiore o uguale a 18 negli esami propedeutici per quell'esame --
CREATE OR REPLACE FUNCTION controlla_propedeuticità()
  RETURNS TRIGGER AS
$$
DECLARE
  voto_propedeutici INTEGER;
BEGIN
  SELECT COUNT(*) INTO voto_propedeutici
  FROM Propedeuticità
  WHERE id_insegnamento = NEW.id_insegnamento
    AND id_insegnamento_propedeutico IN (
      SELECT id_insegnamento
      FROM Esame
      WHERE matricola = NEW.matricola
        AND voto >= 18
    );
    
  IF voto_propedeutici < 1 THEN
    RAISE EXCEPTION 'Lo studente non ha i requisiti propedeutici per iscriversi a questo esame.';
  END IF;
  
  RETURN NEW;
END;
$$
LANGUAGE plpgsql;
-- Come crearlo: 
CREATE TRIGGER controllo_propedeuticità_trigger
  BEFORE INSERT ON Esame
  FOR EACH ROW
  EXECUTE FUNCTION controlla_propedeuticità();




-- copia tutti i dati di uno studente dalla tabella "studente" alla tabella "studente_inattivo" utilizzando la matricola come identificatore. Successivamente, il record dello studente può essere cancellato dalla tabella "studente". --
CREATE OR REPLACE FUNCTION sposta_studente_inattivo(matricola_input INTEGER)
  RETURNS VOID AS
$$
BEGIN
  INSERT INTO studente_inattivo
  SELECT *
  FROM studente
  WHERE matricola = matricola_input;

  DELETE FROM studente
  WHERE matricola = matricola_input;
END;
$$
LANGUAGE plpgsql;
-- Lo chiamo con 
SELECT sposta_studente_inattivo(12345);



-- verificare che non possano essere inseriti più esami di insegnamenti che appartengono allo stesso corso di laurea nello stesso giorno. Per fare ciò, utilizzeremo le tabelle "corsi", "insegnamenti" e "calendario" come descritte in precedenza--
CREATE OR REPLACE FUNCTION controllo_esami_stesso_giorno()
  RETURNS TRIGGER AS
$$
DECLARE
  corso_di_laurea INTEGER;
BEGIN
  SELECT id_corso INTO corso_di_laurea
  FROM corso_di_laurea
  WHERE id_insegnamento = NEW.id_insegnamento;

  IF EXISTS (
    SELECT 1
    FROM calendario
    WHERE id_insegnamento IN (
      SELECT id_insegnamento
      FROM corso_di_laurea
      WHERE id_corso = corso_di_laurea
    ) AND data_esame = NEW.data_esame
  ) THEN
    RAISE EXCEPTION 'Non è possibile inserire più esami dello stesso corso di laurea nello stesso giorno.';
  END IF;

  RETURN NEW;
END;
$$
LANGUAGE plpgsql;
--Come chiamarlo:
CREATE TRIGGER controllo_esami_stesso_giorno_trigger
  BEFORE INSERT ON calendario
  FOR EACH ROW
  EXECUTE FUNCTION controllo_esami_stesso_giorno();




--  produrre l'intera carriera di uno studente, che includa i voti e le date di tutti gli esami sostenuti da quello studente. --
CREATE OR REPLACE FUNCTION carriera_studente(matricola_input INTEGER)
  RETURNS TABLE (insegnamento TEXT, voto INTEGER, data_esame DATE) AS
$$
BEGIN
  RETURN QUERY
  SELECT i.insegnamento, e.voto, c.data_esame
  FROM studente s
  INNER JOIN esame e ON s.matricola = e.matricola
  INNER JOIN calendario c ON e.id_esame = c.id_esame
  INNER JOIN insegnamenti i ON e.id_insegnamento = i.id_insegnamento
  WHERE s.matricola = matricola_input;
END;
$$
LANGUAGE plpgsql;   
-- Come chiamarlo: 
SELECT * FROM carriera_studente(12345);
