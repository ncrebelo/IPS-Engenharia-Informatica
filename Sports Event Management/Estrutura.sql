DROP DATABASE IF EXISTS Eventos;

CREATE DATABASE IF NOT EXISTS Eventos;
USE Eventos;


CREATE TABLE IF NOT EXISTS Evento(
  eve_nome  VARCHAR(30)  NOT NULL UNIQUE PRIMARY KEY,
  eve_frequencia  VARCHAR(20),
  eve_data_inicio DATE NOT NULL,
  eve_data_fim DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Atividade(
  ativ_id  INT NOT NULL UNIQUE PRIMARY KEY,
  ativ_nome   VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Localizacao(
  loc_local     VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,
  loc_cidade    VARCHAR(20) NOT NULL,
  loc_distrito  VARCHAR(20) NOT NULL,
  loc_lotacao 	INT  NOT NULL
);

CREATE TABLE IF NOT EXISTS Ocorrencia(
  ocor_id  INT NOT NULL UNIQUE PRIMARY KEY,
  ocor_dia    DATE NOT NULL,
  ocor_hora_inicio  TIME NOT NULL,
  ocor_hora_fim TIME NOT NULL,
  ocor_eve_nome  VARCHAR(30) NOT NULL,
  ocor_ativ_id    INT NOT NULL,
  ocor_loc_local  VARCHAR(50) NOT NULL,
  FOREIGN KEY (ocor_eve_nome) REFERENCES Evento(eve_nome),
  FOREIGN KEY (ocor_ativ_id) REFERENCES Atividade(ativ_id),
  FOREIGN KEY (ocor_loc_local) REFERENCES Localizacao(loc_local)
);

CREATE TABLE IF NOT EXISTS Pessoa(
  pess_id  INT  NOT NULL UNIQUE PRIMARY KEY,
  pess_nome   VARCHAR(50) NOT NULL,
  pess_data_de_nascimento DATE NOT NULL,
  pess_morada VARCHAR(50) NOT NULL,
  pess_cod_postal VARCHAR(10) NOT NULL,
  pess_telefone INT UNIQUE,
  pess_email VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Participante(
  parti_id_participativo  INT  NOT NULL UNIQUE PRIMARY KEY,
  parti_clube  VARCHAR(20),
  parti_pess_id INT NOT NULL UNIQUE,
  FOREIGN KEY (parti_pess_id) REFERENCES Pessoa(pess_id)
);

CREATE TABLE IF NOT EXISTS Espectador(
  esp_id_espectador  INT  NOT NULL UNIQUE PRIMARY KEY,
  esp_pess_id  INT  NOT NULL UNIQUE,
  FOREIGN KEY (esp_pess_id) REFERENCES Pessoa(pess_id)
);

CREATE TABLE IF NOT EXISTS Seguranca(
  seg_id_APSEI  INT  NOT NULL UNIQUE PRIMARY KEY,
  seg_pess_id  INT  NOT NULL UNIQUE,
  FOREIGN KEY (seg_pess_id) REFERENCES Pessoa(pess_id)
);

CREATE TABLE IF NOT EXISTS Exame_Aptidao(
  exa_id   INT  NOT NULL,
  exa_tipo   VARCHAR(50) NOT NULL,
  exa_resultado VARCHAR(10) NOT NULL,
  exa_data DATE NOT NULL,
  exa_seg_id_APSEI  INT  NOT NULL,
  FOREIGN KEY (exa_seg_id_APSEI) REFERENCES Seguranca(seg_id_APSEI)
);

CREATE TABLE IF NOT EXISTS Alojamento(
  aloj_nome VARCHAR(40) NOT NULL UNIQUE PRIMARY KEY,
  aloj_custo INT NOT NULL
);
 
CREATE TABLE IF NOT EXISTS Patrocinador(
  patro_nome  VARCHAR(20) NOT NULL UNIQUE PRIMARY KEY,
  patro_descricao  VARCHAR(20) NOT NULL,
  patro_capital_social INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Evento_Patrocinador(
   eve_nome  VARCHAR(30)  NOT NULL,
   patro_nome  VARCHAR(20) NOT NULL,
   ev_pat_eve_nome VARCHAR(30)  NOT NULL,
   ev_pat_patro_nome VARCHAR(20) NOT NULL,
   primary key(eve_nome,patro_nome)
);
	
CREATE TABLE IF NOT EXISTS Evento_Alojamento(
   eve_nome  VARCHAR(30)  NOT NULL,
   aloj_nome  VARCHAR(40) NOT NULL,
   ev_aloj_eve_nome VARCHAR(30)  NOT NULL,
   ev_aloj_aloj_nome VARCHAR(40) NOT NULL,
   primary key(eve_nome,aloj_nome)
);

CREATE TABLE IF NOT EXISTS Evento_Seguranca(
   eve_nome  VARCHAR(30)  NOT NULL,
   seg_id_APSEI  INT  NOT NULL,
   primary key(eve_nome,seg_id_APSEI)
);	
	
CREATE TABLE IF NOT EXISTS Evento_Espectador(
   eve_nome  VARCHAR(30)  NOT NULL,
   esp_id_espectador  INT  NOT NULL,
   bilhete VARCHAR(10) NOT NULL,
   primary key(eve_nome,esp_id_espectador)
);

CREATE TABLE IF NOT EXISTS Evento_Participante(
   eve_nome  VARCHAR(30)  NOT NULL,
   parti_id_participativo  INT  NOT NULL,
   inscricao VARCHAR(10) NOT NULL,
   primary key(eve_nome,parti_id_participativo)
);

CREATE TABLE IF NOT EXISTS Ocorrencia_Espectador(
	ocor_id INT NOT NULL,
	esp_id_espectador INT NOT NULL,
	avaliacao INT,
	primary key(ocor_id,esp_id_espectador)
);


-------- ALTER TABLES --------
-- FOREIGN KEYS

ALTER TABLE Evento_Patrocinador ADD CONSTRAINT EventoHasPatrocinador_FK		FOREIGN KEY      		   		(ev_pat_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;
																			
ALTER TABLE Evento_Patrocinador ADD CONSTRAINT PatrocinadorHasEvento_FK		FOREIGN KEY      		   		(ev_pat_patro_nome)
																			REFERENCES Patrocinador			(patro_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;

ALTER TABLE Evento_Patrocinador ADD CONSTRAINT EventoHasAlojamento			FOREIGN KEY      		   		(ev_aloj_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;