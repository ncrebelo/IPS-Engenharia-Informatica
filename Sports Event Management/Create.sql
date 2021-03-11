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
  ocor_loc_local  VARCHAR(50) NOT NULL
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
  parti_pess_id INT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Espectador(
  esp_id_espectador  INT  NOT NULL UNIQUE PRIMARY KEY,
  esp_pess_id  INT  NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Seguranca(
  seg_id_APSEI  INT  NOT NULL UNIQUE PRIMARY KEY,
  seg_pess_id  INT  NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Exame_Aptidao(
  exa_id   INT  NOT NULL,
  exa_tipo   VARCHAR(50) NOT NULL,
  exa_resultado VARCHAR(10) NOT NULL,
  exa_data DATE NOT NULL,
  exa_seg_id_APSEI  INT  NOT NULL
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
   evpat_eve_nome  VARCHAR(30)  NOT NULL,
   evpat_patro_nome  VARCHAR(20) NOT NULL,
   primary key(evpat_eve_nome,evpat_patro_nome)
);
	
CREATE TABLE IF NOT EXISTS Evento_Alojamento(
   evaloj_eve_nome  VARCHAR(30)  NOT NULL,
   evaloj_aloj_nome  VARCHAR(40) NOT NULL,
   primary key(evaloj_eve_nome,evaloj_aloj_nome)
);

CREATE TABLE IF NOT EXISTS Evento_Seguranca(
   evseg_eve_nome  VARCHAR(30)  NOT NULL,
   evseg_seg_id_APSEI  INT  NOT NULL,
   primary key(evseg_eve_nome,evseg_seg_id_APSEI)
);	
	
CREATE TABLE IF NOT EXISTS Evento_Espectador(
   evesp_eve_nome  VARCHAR(30)  NOT NULL,
   evesp_esp_id_espectador  INT  NOT NULL,
   evesp_bilhete VARCHAR(10) NOT NULL,
   primary key(evesp_eve_nome,evesp_esp_id_espectador)
);

CREATE TABLE IF NOT EXISTS Evento_Participante(
   evpar_eve_nome  VARCHAR(30)  NOT NULL,
   evpar_parti_id_participativo  INT  NOT NULL,
   evpar_inscricao VARCHAR(10) NOT NULL,
   primary key(evpar_eve_nome,evpar_parti_id_participativo)
);

CREATE TABLE IF NOT EXISTS Ocorrencia_Espectador(
	ocoresp_ocor_id INT NOT NULL,
	ocoresp_esp_id_espectador INT NOT NULL,
	ocoresp_avaliacao INT,
	ocoresp_comentario VARCHAR (100),
	primary key(ocoresp_ocor_id,ocoresp_esp_id_espectador)
);


CREATE TABLE Palavras_ofensivas_filtro (
	id int NOT NULL AUTO_INCREMENT,
    word varchar (30),
	PRIMARY KEY (id)
);

CREATE TABLE Palavras_ofensivas_audit(
	id int NOT NULL AUTO_INCREMENT,
    processo VARCHAR (10),
	ocorrencia DATE NOT NULL,
    ocoresp_esp_id_espectador INT,
	PRIMARY KEY (id)
);

    
CREATE TABLE Auxiliar(
    aux_id int NOT NULL AUTO_INCREMENT,
    aux_data_hora TIMESTAMP,
	aux_AVG DOUBLE,
	PRIMARY KEY (aux_id)
);

CREATE TABLE avaliacoes_audit(
    audav_id int NOT NULL AUTO_INCREMENT,
	audav_ocor_id INT NOT NULL,
	audav_notificar boolean NOT NULL,
    audav_mensagem varchar (100),
	PRIMARY KEY (audav_id)
);





-------- ALTER TABLES --------
-- FOREIGN KEYS

ALTER TABLE Ocorrencia ADD CONSTRAINT OcorrenciaHasEvento_FK				FOREIGN KEY      		   		(ocor_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;
																			
ALTER TABLE Ocorrencia ADD CONSTRAINT OcorrenciaHasAtividade_FK				FOREIGN KEY      		   		(ocor_ativ_id)
																			REFERENCES Atividade			(ativ_id)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;
																			
ALTER TABLE Ocorrencia ADD CONSTRAINT OcorrenciaHasLocalizacao_FK			FOREIGN KEY      		   		(ocor_loc_local)
																			REFERENCES Localizacao			(loc_local)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;
																			
ALTER TABLE Participante ADD CONSTRAINT ParticipanteHasPessoa_FK			FOREIGN KEY      		   		(parti_pess_id)
																			REFERENCES Pessoa				(pess_id)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;
																			
ALTER TABLE Espectador ADD CONSTRAINT ParticipanteHasEspectador_FK			FOREIGN KEY      		   		(esp_pess_id)
																			REFERENCES Pessoa				(pess_id)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;

ALTER TABLE Exame_Aptidao ADD CONSTRAINT Exame_AptidaoHasSeguranca_FK		FOREIGN KEY      		   		(exa_seg_id_APSEI)
																			REFERENCES Seguranca			(seg_id_APSEI)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;																		
																			
ALTER TABLE Seguranca ADD CONSTRAINT ParticipanteHasSeguranca_FK			FOREIGN KEY      		   		(seg_pess_id)
																			REFERENCES Pessoa				(pess_id)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;																			
																			
ALTER TABLE Evento_Patrocinador ADD CONSTRAINT EventoHasPatrocinador_FK		FOREIGN KEY      		   		(evpat_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;
																			
ALTER TABLE Evento_Patrocinador ADD CONSTRAINT PatrocinadorHasEvento_FK		FOREIGN KEY      		   		(evpat_patro_nome)
																			REFERENCES Patrocinador			(patro_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;

ALTER TABLE Evento_Alojamento ADD CONSTRAINT EventoHasAlojamento_FK			FOREIGN KEY      		   		(evaloj_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;
																			
ALTER TABLE Evento_Alojamento ADD CONSTRAINT AlojamentoHasEvento_FK			FOREIGN KEY      		   		(evaloj_aloj_nome)
																			REFERENCES Alojamento			(aloj_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;	

ALTER TABLE Evento_Seguranca ADD CONSTRAINT EventoHasSeguranca_FK			FOREIGN KEY      		   		(evseg_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;	
																			
ALTER TABLE Evento_Seguranca ADD CONSTRAINT SegurancaHasEvento_FK			FOREIGN KEY      		   		(evseg_seg_id_APSEI)
																			REFERENCES Seguranca			(seg_id_APSEI)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;		

ALTER TABLE Evento_Espectador ADD CONSTRAINT EventoHasEspectador_FK			FOREIGN KEY      		   		(evesp_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;		

ALTER TABLE Evento_Espectador ADD CONSTRAINT EspectdorHasEvento_FK			FOREIGN KEY      		   		(evesp_esp_id_espectador)
																			REFERENCES Espectador			(esp_id_espectador)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;		

ALTER TABLE Evento_Participante ADD CONSTRAINT EventoHasParticipante_FK		FOREIGN KEY      		   		(evpar_eve_nome)
																			REFERENCES Evento				(eve_nome)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;		

ALTER TABLE Evento_Participante ADD CONSTRAINT ParticipanteHasEvento_FK		FOREIGN KEY      		   		(evpar_parti_id_participativo)
																			REFERENCES Participante			(parti_id_participativo)
																			ON DELETE CASCADE
																			ON UPDATE CASCADE;		

ALTER TABLE Ocorrencia_Espectador ADD CONSTRAINT OcorrenciaHasEspectador_FK		FOREIGN KEY      		   	(ocoresp_ocor_id)
																				REFERENCES Ocorrencia		(ocor_id)
																				ON DELETE CASCADE
																				ON UPDATE CASCADE;	

ALTER TABLE Ocorrencia_Espectador ADD CONSTRAINT EspectadorHasOcorrencia_FK		FOREIGN KEY      		   		(ocoresp_esp_id_espectador)
																				REFERENCES Espectador			(esp_id_espectador)
																				ON DELETE CASCADE
																				ON UPDATE CASCADE;																				