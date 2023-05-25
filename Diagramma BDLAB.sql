CREATE TABLE "Segreteria" (
  "id_segreteria" smallserial PRIMARY KEY,
  "nome" varchar(20) NOT NULL,
  "cognome" varchar(30) NOT NULL,
  "email" varchar(30) UNIQUE NOT NULL,
  "password" varchar(16) NOT NULL,
  "data_nascita" date NOT NULL,
  "sesso" varchar(7) NOT NULL,
  "residenza" varchar(70) NOT NULL,
  "telefono" varchar(17) NOT NULL,
  "codice_fiscale" varchar(16) UNIQUE NOT NULL,
  "domicilio" varchar(70),
  "primo_anno" smallint,
  "dipartimento" varchar(30)
);

CREATE TABLE "Docente" (
  "id_docente" smallserial PRIMARY KEY,
  "nome" varchar(20) NOT NULL,
  "cognome" varchar(30) NOT NULL,
  "email" varchar(30) UNIQUE NOT NULL,
  "password" varchar(16) NOT NULL,
  "data_nascita" date NOT NULL,
  "sesso" varchar(7) NOT NULL,
  "residenza" varchar(70) NOT NULL,
  "telefono" varchar(17) NOT NULL,
  "codice_fiscale" varchar(16) UNIQUE NOT NULL,
  "domicilio" varchar(70),
  "primo_anno" smallint,
  "ufficio" varchar(6)
);

CREATE TABLE "Studente" (
  "matricola" char(6) PRIMARY KEY,
  "nome" varchar(20) NOT NULL,
  "cognome" varchar(30) NOT NULL,
  "email" varchar(30) UNIQUE NOT NULL,
  "password" varchar(16) NOT NULL,
  "data_nascita" date NOT NULL,
  "sesso" varchar(7) NOT NULL,
  "residenza" varchar(70) NOT NULL,
  "telefono" varchar(17) NOT NULL,
  "codice_fiscale" varchar(16) UNIQUE NOT NULL,
  "domicilio" varchar(70),
  "data_iscrizione" timestamp NOT NULL,
  "corso_laurea" varchar(6) NOT NULL
);

CREATE TABLE "Storico_studente" (
  "matricola" char(6) PRIMARY KEY,
  "nome" varchar(20) NOT NULL,
  "cognome" varchar(30) NOT NULL,
  "email" varchar(30) UNIQUE NOT NULL,
  "password" varchar(16) NOT NULL,
  "data_nascita" date NOT NULL,
  "sesso" varchar(7) NOT NULL,
  "residenza" varchar(70) NOT NULL,
  "telefono" varchar(17) NOT NULL,
  "codice_fiscale" varchar(16) UNIQUE NOT NULL,
  "domicilio" varchar(70),
  "data_iscrizione" timestamp NOT NULL,
  "data_inizo_inattivita" timestamp NOT NULL,
  "corso_laurea" varchar(6) NOT NULL
);

CREATE TABLE "Corso" (
  "codice_corso" char(6) PRIMARY KEY,
  "nome" varchar(40) UNIQUE NOT NULL,
  "tipologia" varchar(10) NOT NULL,
  "descrizione" text NOT NULL
);

CREATE TABLE "Insegnamenti" (
  "codice_insegnamento" char(6) PRIMARY KEY,
  "nome" varchar(40) UNIQUE NOT NULL,
  "anno" tinyint NOT NULL,
  "descrizione" text NOT NULL
);

CREATE TABLE "Calendario" (
  "id_esame" serial PRIMARY KEY,
  "cod_insegnamento" char(6) NOT NULL,
  "data" date NOT NULL,
  "posti" tinyint NOT NULL,
  "aula" varchar(20) NOT NULL
);

CREATE TABLE "Piano_Didattico" (
  "cod_insegnamento" char(6) NOT NULL,
  "cod_corso" char(6) NOT NULL
);

CREATE TABLE "insegna" (
  "id_docente" serial NOT NULL,
  "cod_insegnamento" char(6) NOT NULL
);

CREATE TABLE "propeduticita" (
  "cod_insegnamento" char(6) NOT NULL,
  "cod_ins_proped" char(6) NOT NULL
);

CREATE TABLE "appello" (
  "matricola_stud" char(6) NOT NULL,
  "id_esame" serial NOT NULL,
  "voto" tinyint NOT NULL
);

CREATE TABLE "Appelli_storici" (
  "matricola_stud" char(6) NOT NULL,
  "id_esame" serial NOT NULL,
  "voto" tinyint NOT NULL
);

CREATE INDEX ON "Piano_Didattico" ("cod_corso", "cod_insegnamento");

CREATE INDEX ON "insegna" ("id_docente", "cod_insegnamento");

CREATE INDEX ON "propeduticita" ("cod_insegnamento", "cod_ins_proped");

CREATE INDEX ON "appello" ("matricola_stud", "id_esame");

CREATE INDEX ON "Appelli_storici" ("matricola_stud", "id_esame");

ALTER TABLE "Corso" ADD FOREIGN KEY ("codice_corso") REFERENCES "Studente" ("corso_laurea");

ALTER TABLE "Piano_Didattico" ADD FOREIGN KEY ("cod_corso") REFERENCES "Corso" ("codice_corso");

ALTER TABLE "Piano_Didattico" ADD FOREIGN KEY ("cod_insegnamento") REFERENCES "Insegnamenti" ("codice_insegnamento");

ALTER TABLE "insegna" ADD FOREIGN KEY ("cod_insegnamento") REFERENCES "Insegnamenti" ("codice_insegnamento");

ALTER TABLE "insegna" ADD FOREIGN KEY ("id_docente") REFERENCES "Docente" ("id_docente");

ALTER TABLE "propeduticita" ADD FOREIGN KEY ("cod_insegnamento") REFERENCES "Insegnamenti" ("codice_insegnamento");

ALTER TABLE "propeduticita" ADD FOREIGN KEY ("cod_ins_proped") REFERENCES "Insegnamenti" ("codice_insegnamento");

ALTER TABLE "Insegnamenti" ADD FOREIGN KEY ("codice_insegnamento") REFERENCES "Calendario" ("cod_insegnamento");

ALTER TABLE "appello" ADD FOREIGN KEY ("matricola_stud") REFERENCES "Studente" ("matricola");

ALTER TABLE "appello" ADD FOREIGN KEY ("id_esame") REFERENCES "Calendario" ("id_esame");

ALTER TABLE "Appelli_storici" ADD FOREIGN KEY ("matricola_stud") REFERENCES "Storico_studente" ("matricola");

ALTER TABLE "Appelli_storici" ADD FOREIGN KEY ("id_esame") REFERENCES "Calendario" ("id_esame");