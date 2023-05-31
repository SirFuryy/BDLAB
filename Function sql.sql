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
