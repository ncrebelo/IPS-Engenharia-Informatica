use eventos;

-- POPULATE PROCEDURES
-- Inserções/Atualizações - ALINEA A)


-- INSERT Evento
delimiter $$
-- drop procedure if exists sp_insert_evento;
create procedure sp_insert_evento	(in _nome varchar(30),
									   in _frequencia varchar(20),
									   in _data_inicio DATE,
									   in _data_fim DATE)
BEGIN
	insert into Evento (eve_nome, eve_frequencia, eve_data_inicio,eve_data_fim)
    values(_nome, _frequencia, _data_inicio,_data_fim);
END $$
DELIMITER ;


-- INSERT Atividade
delimiter $$
-- drop procedure if exists sp_insert_atividade
create procedure sp_insert_atividade	(in _id int,
											in _nome varchar (20))
BEGIN
	insert into Atividade (ativ_id, ativ_nome)
    values(_id, _nome);
END $$
DELIMITER ;					


-- INSERT Localizacao
delimiter $$
-- drop procedure if exists sp_insert_localizacao
create procedure sp_insert_localizacao	(in _local varchar(50),
											in _cidade varchar (20),
											in _distrito varchar (20),
											in _lotacao int)
BEGIN
	insert into Localizacao (loc_local, loc_cidade,loc_distrito,loc_lotacao)
    values(_local, _cidade,_distrito,_lotacao);
END $$
DELIMITER ;	


-- INSERT Ocorrencia
delimiter $$
-- drop procedure if exists sp_insert_ocorrencia;
create procedure sp_insert_ocorrencia	(in _id int,
											in _dia DATE,
											in _hora_inicio TIME,
											in _hora_fim TIME,
											in _eve_nome varchar (30),
											in _ativ_id int,
											in _loc_local varchar (50))
BEGIN
	insert into Ocorrencia (ocor_id, ocor_dia, ocor_hora_inicio, ocor_hora_fim, ocor_eve_nome, ocor_ativ_id, ocor_loc_local)
    values(_id, _dia,_hora_inicio,_hora_fim,_eve_nome,_ativ_id,_loc_local);
END $$
DELIMITER ;		


-- INSERT Pessoa
delimiter $$
-- drop procedure if exists sp_insert_pessoa
create procedure sp_insert_pessoa		(in _id int,
											in _nome varchar (50),
											in _data_de_nascimento DATE,
											in _morada varchar (50),
											in _cod_postal varchar (10),
											in _telefone int,
											in _email varchar(50))
BEGIN
	insert into Pessoa (pess_id, pess_nome, pess_data_de_nascimento,pess_morada,pess_cod_postal,pess_telefone,pess_email)
    values(_id, _nome,_data_de_nascimento,_morada,_cod_postal,_telefone,_email);
END $$
DELIMITER ;	


-- INSERT Participante
delimiter $$
-- drop procedure if exists sp_insert_participante
create procedure sp_insert_participante		(in _id_participativo int,
												in _clube varchar (20),
												in _pess_id int)
BEGIN
	insert into Participante (parti_id_participativo, parti_clube, parti_pess_id)
    values(_id_participativo, _clube,_pess_id);
END $$
DELIMITER ;	


-- INSERT Espectador
delimiter $$
-- drop procedure if exists sp_insert_espectador
create procedure sp_insert_espectador		(in _id_espectador int,
												in _pess_id int)
BEGIN
	insert into Espectador (esp_id_espectador, esp_pess_id)
    values(_id_espectador, _pess_id);
END $$
DELIMITER ;	


-- INSERT Seguranca
delimiter $$
-- drop procedure if exists sp_insert_seguranca
create procedure sp_insert_seguranca		(in _id_APSEI int,
												in _pess_id int)
BEGIN
	insert into Seguranca (seg_id_APSEI, seg_pess_id)
    values(_id_APSEI, _pess_id);
END $$
DELIMITER ;	


-- INSERT Exame_Aptidao
delimiter $$
-- drop procedure if exists sp_insert_exame_aptidao;
create procedure sp_insert_exame_aptidao		(in _id int,
													in _tipo varchar (50),
													in _resultado varchar (10),
													in _data DATE,
													in _seg_id_APSEI int)
BEGIN
	insert into Exame_Aptidao (exa_id, exa_tipo,exa_resultado, exa_data, exa_seg_id_APSEI)
    values(_id,_tipo,_resultado,_data,_seg_id_APSEI);
END $$
DELIMITER ;	


-- INSERT Alojamento
delimiter $$
-- drop procedure if exists sp_insert_alojamento
create procedure sp_insert_alojamento		(in _nome varchar (40),
												in _custo int )
BEGIN
	insert into Alojamento (aloj_nome, aloj_custo)
    values(_nome,_custo);
END $$
DELIMITER ;	
			
			
-- INSERT Patrocinador
delimiter $$
-- drop procedure if exists sp_insert_patrocinador
create procedure sp_insert_patrocinador		(in _nome varchar (20),
												in _descricao varchar (20),
												in _capital_social int)
BEGIN
	insert into Patrocinador (patro_nome, patro_descricao, patro_capital_social)
    values(_nome,_descricao,_capital_social);
END $$
DELIMITER ;	



-- INSERT Evento_Patrocinador
delimiter $$
-- drop procedure if exists sp_insert_evento_patrocinador
create procedure sp_insert_evento_patrocinador		(in _eve_nome varchar (30),
														in _patro_nome varchar (20))
BEGIN
	insert into Evento_Patrocinador (evpat_eve_nome, evpat_patro_nome)
    values(_eve_nome,_patro_nome);
END $$
DELIMITER ;	



-- INSERT Evento_Alojamento
delimiter $$
-- drop procedure if exists sp_insert_evento_alojamento
create procedure sp_insert_evento_alojamento		(in _eve_nome varchar (30),
														in _aloj_nome varchar (40))
BEGIN
	insert into Evento_Alojamento (evaloj_eve_nome, evaloj_aloj_nome)
    values(_eve_nome,_aloj_nome);
END $$
DELIMITER ;	


-- INSERT Evento_Seguranca
delimiter $$
-- drop procedure if exists sp_insert_evento_seguranca
create procedure sp_insert_evento_seguranca			(in _eve_nome varchar (30),
														in _seg_id_APSEI int )
BEGIN
	insert into Evento_Seguranca (evseg_eve_nome, evseg_seg_id_APSEI)
    values(_eve_nome,_seg_id_APSEI);
END $$
DELIMITER ;	


-- INSERT Evento_Espectador
delimiter $$
-- drop procedure if exists sp_insert_evento_espectador;
create procedure sp_insert_evento_espectador			(in _eve_nome varchar (30),
															in _esp_id_espectador int,
															in _bilhete varchar (10))
BEGIN
	insert into Evento_Espectador (evesp_eve_nome, evesp_esp_id_espectador, evesp_bilhete)
    values(_eve_nome,_esp_id_espectador,_bilhete);
END $$
DELIMITER ;	


-- INSERT Evento_Participante
delimiter $$
-- drop procedure if exists sp_insert_evento_participante;
create procedure sp_insert_evento_participante			(in _eve_nome varchar (30),
															in _parti_id_participativo int,
															in _inscricao varchar (10))												
BEGIN
	insert into Evento_Participante (evpar_eve_nome, evpar_parti_id_participativo, evpar_inscricao)
    values(_eve_nome,_parti_id_participativo,_inscricao);
END $$
DELIMITER ;	


-- INSERT Ocorrencia_Espectador
delimiter $$
-- drop procedure if exists sp_insert_ocorrencia_espectador;
create procedure sp_insert_ocorrencia_espectador			(in _ocor_id int,
																in _esp_id_espectador int,
																in _avaliacao int,
																in _comentario varchar (100))
BEGIN
	insert into Ocorrencia_Espectador (ocoresp_ocor_id, ocoresp_esp_id_espectador, ocoresp_avaliacao, ocoresp_comentario)
    values(_ocor_id,_esp_id_espectador,_avaliacao,_comentario);
END $$
DELIMITER ;	


-- *******************************************************
-- 			I.REQUISITOS MÍNIMOS
-- *******************************************************

-- VIEWS
-- RM01
drop view if exists InformacaoEventos;
create view InformacaoEventos as
select eve_nome as 'Nome do Evento', eve_frequencia as 'Frequência', eve_data_inicio as 'Começo', eve_data_fim as'Fim',
evpat_patro_nome as 'Patrocinador',
pess_nome as 'Nome Participante'
from evento
join evento_patrocinador on eve_nome = evpat_eve_nome
join evento_participante on evpar_eve_nome = eve_nome
join participante on evpar_parti_id_participativo = parti_id_participativo
join pessoa on parti_pess_id = pess_id
order by eve_nome;

--RM02
drop view if exists InformacaoOcorrencias;
create view InformacaoOcorrencias as
select ocor_id as 'ID Ocorrência', ativ_nome as 'Nome da Atividade', eve_nome as 'Nome do Evento',
ocor_dia as 'Dia', ocor_hora_inicio as 'Hora ínicio', ocor_hora_fim as 'Hora fim', ocor_loc_local as 'Local', 
average as 'Avaliação Média'
from ocorrencia a
join atividade on ativ_id = ocor_ativ_id
join evento on ocor_eve_nome = eve_nome
join (select ocoresp_ocor_id, avg(ocoresp_avaliacao) as 'average'
from ocorrencia_espectador
group by ocoresp_ocor_id) b on b.ocoresp_ocor_id = a.ocor_id
order by eve_nome

--RM03
drop view if exists InformacaoParticipantesPorEvento;
create view InformacaoParticipantesPorEvento as
select parti_id_participativo as 'Id Competição', pess_nome as 'Nome', 
pess_data_de_nascimento as 'Data de Nascimento', pess_morada as 'Morada', pess_telefone as 'Telefone',
evpar_eve_nome as 'Evento', evpar_inscricao as 'Local da Inscrição'
from evento_participante
join participante on evpar_parti_id_participativo = parti_id_participativo
join pessoa on parti_pess_id = pess_id;

--RM04
DROP VIEW IF EXISTS media_avaliacoes_comentarios;
CREATE VIEW media_avaliacoes_comentarios AS
SELECT evesp_eve_nome AS "Evento",
		AVG(ocoresp_avaliacao) AS "Avaliação",COUNT(ocoresp_comentario) AS "Comentário"
FROM evento_espectador
JOIN evento
ON evesp_eve_nome = eve_nome
JOIN ocorrencia 
ON eve_nome = ocor_eve_nome
JOIN ocorrencia_espectador
ON ocoresp_ocor_id = ocor_id
GROUP BY evesp_eve_nome;

--RM05
DROP VIEW IF EXISTS top_espectador_avaliacoes;
CREATE VIEW top_espectador_avaliacoes AS
SELECT pess_nome AS "Espectador", COUNT(*) AS ocoresp_comentario
FROM ocorrencia_espectador
JOIN espectador 
ON ocoresp_esp_id_espectador = esp_id_espectador
JOIN pessoa
ON esp_id_espectador = pess_id
GROUP BY ocoresp_esp_id_espectador
ORDER BY ocoresp_comentario DESC
LIMIT 5;

--RM06
DROP VIEW IF EXISTS comentarios_avaliacoes;
CREATE VIEW comentarios_avaliacoeS AS
SELECT evesp_eve_nome AS "Evento",ativ_nome AS "Atividade",eve_data_inicio "Data Inicio",eve_data_fim AS "Data Fim", 
		pess_nome "Espectador",ocoresp_avaliacao AS "Avaliação",ocoresp_comentario AS "Comentário"
FROM evento_espectador
JOIN evento
ON evesp_eve_nome = eve_nome
JOIN espectador
ON evesp_esp_id_espectador = esp_id_espectador
JOIN pessoa
ON esp_id_espectador = pess_id
JOIN ocorrencia_espectador
ON ocoresp_esp_id_espectador = esp_id_espectador
JOIN ocorrencia 
ON eve_nome = ocor_eve_nome
JOIN atividade
ON ativ_id = ocor_ativ_id
ORDER BY eve_data_inicio DESC, eve_data_fim DESC;

--RM07
drop view if exists InformacaoEspectadoresPorEvento;
create view InformacaoParticipantesPorEvento as
select evesp_esp_id_espectador as 'Id Competição', pess_nome as 'Nome', 
pess_data_de_nascimento as 'Data de Nascimento', pess_morada as 'Morada', pess_telefone as 'Telefone',
evesp_eve_nome as 'Evento', evesp_bilhete as 'Bilhete'
from evento_espectador
join espectador on  esp_id_espectador = evesp_esp_id_espectador
join pessoa on esp_pess_id = pess_id;

-- Functions
--RM08
drop function if exists fn_comentario_espectador;
DELIMITER $$
CREATE FUNCTION fn_comentario_espectador(esp_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE aux VARCHAR(100);
	SELECT 
		ocoresp_comentario AS "Comentário"
	FROM
		ocorrencia_espectador
	WHERE
		ocoresp_esp_id_espectador = _espectador_id
	INTO aux;
	RETURN aux;
END$$
DELIMITER ;

--RM09
drop function if exists fn_email_pessoa;
DELIMITER $$
CREATE FUNCTION fn_email_pessoa(pessoa_id int)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
	DECLARE aux varchar(40);
	SELECT 
		pess_email AS "Email"
	FROM
		pessoa
	WHERE
		pess_id = pessoa_id
	INTO aux;
	RETURN aux;
END$$
DELIMITER ;

-- PROCEDURES
-- RM10
DROP PROCEDURE IF EXISTS sp_caracterisiticas_evento;
DELIMITER $$
CREATE PROCEDURE sp_caracterisiticas_evento(nome VARCHAR(60))
BEGIN
	select ocor_id as 'ID Ocorrência', ativ_nome as 'Nome da Atividade', eve_nome as 'Nome do Evento',
	ocor_dia as 'Dia', ocor_hora_inicio as 'Hora ínicio', ocor_hora_fim as 'Hora fim', ocor_loc_local as 'Local'
	from ocorrencia a
	join atividade on ativ_id = ocor_ativ_id
	join evento on ocor_eve_nome = eve_nome
	join (select ocoresp_ocor_id, avg(ocoresp_avaliacao) as 'average'
	from ocorrencia_espectador
	group by ocoresp_ocor_id) b on b.ocoresp_ocor_id = a.ocor_id
	Where nome = eve_nome
	order by eve_nome;
END $$
DELIMITER ;

--RM11
drop procedure if exists sp_informação_ocorrencia;
delimiter $$
create procedure sp_informação_ocorrencia()
begin
	select ocor_id as 'ID Ocorrência', ativ_nome as 'Nome da Atividade',
	ocor_dia as 'Dia', ocor_hora_inicio as 'Hora ínicio', ocor_hora_fim as 'Hora fim', ocor_loc_local as 'Local', 
	average as 'Avaliação Média'
	from ocorrencia a
	join atividade on ativ_id = ocor_ativ_id
	join evento on ocor_eve_nome = eve_nome
	join (select ocoresp_ocor_id, avg(ocoresp_avaliacao) as 'average'
	from ocorrencia_espectador
	group by ocoresp_ocor_id) b on b.ocoresp_ocor_id = a.ocor_id
	order by eve_nome;
end$$

--RM12
DROP PROCEDURE IF EXISTS sp_aval_coment;
DELIMITER $$
CREATE PROCEDURE sp_aval_coment(ocoresp_ocor_id INT)
BEGIN
	SELECT ocoresp_ocor_id AS "Ocorrencia",ocoresp_avaliacao AS "Avaliação", 
			ocoresp_comentario AS "Comentários", pess_nome AS "Espectador"
	FROM ocorrencia_espectador a
    JOIN (SELECT ocoresp_ocor_id FROM ocorrencia_espectador
	GROUP BY ocoresp_ocor_id) b ON b.ocoresp_ocor_id = a.ocoresp_ocor_id
    JOIN espectador
    ON ocoresp_esp_id_espectador = esp_id_espectador
    LEFT JOIN pessoa 
    ON esp_id_espectador  = pess_id
    ORDER BY ocoresp_ocor_id;
END $$
DELIMITER ;

--RM13
DROP PROCEDURE IF EXISTS sp_event_participantes;
DELIMITER $$
CREATE PROCEDURE sp_event_participantes()
BEGIN
	SELECT eve_nome AS "Evento",eve_data_inicio AS "Data Início", eve_data_fim AS "Data Fim", 
			pess_nome AS "Participante"
	FROM evento_participante
    JOIN evento
    ON evpar_eve_nome = eve_nome
    JOIN pessoa
    ON evpar_parti_id_participativo = pess_id
	ORDER BY eve_data_inicio DESC
	LIMIT 2;
END $$
DELIMITER ;

--RM14
drop procedure if exists sp_idade_pessoa;
delimiter $$
create procedure sp_idade_pessoa(id INT)
BEGIN
	SELECT pess_nome,TIMESTAMPDIFF(YEAR, pess_data_de_nascimento, CURDATE()) AS "Idade"
    from pessoa
    WHERE pess_id = id;
END$$
delimiter ;

--RM15
DROP PROCEDURE IF EXISTS sp_getUserHistoryByName;
DELIMITER $$
CREATE PROCEDURE sp_getUserHistoryByName(nome varchar(30))
BEGIN
	select evpar_eve_nome as 'Evento', eve_data_inicio as 'Data de Início', eve_data_fim as 'Data do fim', 
    evpar_inscricao as 'Local da Inscrição'
	from evento_participante
	join evento on eve_nome = evpar_eve_nome
	join participante on evpar_parti_id_participativo = parti_id_participativo
	join pessoa on parti_pess_id = pess_id
    where pess_nome = nome;
END $$
DELIMITER ;

--RM16
DROP PROCEDURE IF EXISTS sp_getUserHistoryByUserId;
delimiter $$
CREATE PROCEDURE sp_getUserHistoryByUserId(id int)
BEGIN 
	select evpar_eve_nome as 'Evento', eve_data_inicio as 'Data de Início', eve_data_fim as 'Data do fim', 
    evpar_inscricao as 'Local da Inscrição'
	from evento_participante
	join evento on eve_nome = evpar_eve_nome
	join participante on evpar_parti_id_participativo = parti_id_participativo
	join pessoa on parti_pess_id = pess_id
    where evpar_parti_id_participativo = id;
END $$
DELIMITER ;

--RM17
DROP PROCEDURE IF EXISTS sp_event_patocinador;
DELIMITER $$
CREATE PROCEDURE sp_event_patocinador(patrocinador VARCHAR(50))
BEGIN
	SELECT  evpat_patro_nome AS "Patrocinador", patro_descricao "Descrição",
				patro_capital_social AS "Capital Social", COUNT(evpat_eve_nome) AS "Eventos Patrocinados"
    FROM evento_patrocinador
    JOIN patrocinador
    ON patro_nome = evpat_patro_nome
    WHERE patrocinador = patro_nome;
END $$
DELIMITER ;

--RM18
DROP PROCEDURE IF EXISTS sp_modo_inscricao;
DELIMITER $$
CREATE PROCEDURE sp_modo_inscricao()
BEGIN
	SELECT  evpar_inscricao AS "Forma de Inscrição", COUNT(evpar_inscricao) AS "Quantidade"
    FROM evento_participante
    GROUP BY evpar_inscricao;
END $$
DELIMITER ;

--RM19
DROP PROCEDURE IF EXISTS sp_seguranca_eventos;
DELIMITER $$
CREATE PROCEDURE sp_seguranca_eventos(apsei INT)
BEGIN
	SELECT pess_nome AS "Segurança",eve_nome AS "Eventos",  seg_id_APSEI AS "Nº APSEI"
    FROM evento_seguranca
    JOIN evento 
    ON evseg_eve_nome = eve_nome
    JOIN seguranca
    ON evseg_seg_id_APSEI = seg_id_APSEI
    LEFT JOIN pessoa 
    ON seg_pess_id  = pess_id
    WHERE apsei = seg_id_APSEI;
END $$
DELIMITER ;

-- TRIGGER
-- RM20
drop trigger if exists trg_email;
DELIMITER $$
CREATE TRIGGER trg_email 
BEFORE UPDATE ON pessoa
FOR EACH ROW
BEGIN
		IF(NEW.pess_email NOT LIKE '%_@%_.__%') THEN
        SET NEW.pess_email = "emailinvalido";
        END IF;
END $$
DELIMITER ;

-- INSERÇÕES / ATUALIZAÇÕES
--RM21
drop procedure if sp_atualizar_email ;
delimiter $$
create procedure sp_atualizar_email(in pessoa_id int,
								 in novo_email VARCHAR(50))
BEGIN
	UPDATE pessoa set pess_email = novo_email 
    WHERE pess_id = pessoa_id;
END $$
DELIMITER ;

--RM21
DROP PROCEDURE IF EXISTS sp_remover_alojamento;
delimiter $$
create procedure sp_remover_alojamento(alojamento_nome VARCHAR(40))
BEGIN
DECLARE aux VARCHAR(40);
	SELECT aloj_nome
	FROM alojamento
	WHERE aloj_nome = alojamento_nome
	INTO aux;
		DELETE FROM alojamento 
		WHERE
			aloj_nome = alojamento_nome;
END $$
DELIMITER ;

-- *******************************************************
-- 			II.REQUISITOS ESPECIFICOS 
-- *******************************************************

-- Alínea A
-- RE01
drop procedure if exists sp_criar_comunicacao;
delimiter $$
create procedure sp_criar_comunicacao(in id INT,
								   in dia DATE,
                                   in horaInicio TIME,
								   in horaFim TIME,
								   in eventoNome VARCHAR (30),
                                   in atividade INT,
                                   in localizacao VARCHAR (50),
                                   out emailOut VARCHAR(50))
BEGIN
	insert into ocorrencia (ocor_id,ocor_dia,ocor_hora_inicio,ocor_hora_fim,ocor_eve_nome,ocor_ativ_id,ocor_loc_local)
    values (id,dia, horaInicio, horaFim, eventoNome, atividade, localizacao);
    select count(pess_email) from pessoa into emailOut;
END $$
DELIMITER ;)

-- Alínea B
-- RE02
drop procedure if exists sp_adicionar_comentario_a_comunicação;
delimiter $$
create procedure sp_adicionar_comentario_a_comunicação(idOcor INT,
									  idEspetador INT,
                                      avaliacao INT,
                                      comentario VARCHAR(100))
BEGIN
	insert into ocorrencia_espectador (ocoresp_ocor_id,ocoresp_esp_id_espectador,ocoresp_avaliacao,ocoresp_comentario)
    values (idOcor, idEspetador,avaliacao,comentario);
END $$
DELIMITER ;

-- Alínea C
-- RE03
drop procedure if exists sp_adicionar_avaliação_a_comunicação;
delimiter $$
create procedure sp_adicionar_avaliação_a_comunicação(idOcor INT,
									  idEspetador INT,
                                      avaliacao INT,
                                      comentario VARCHAR(100))
BEGIN
	insert into ocorrencia_espectador (ocoresp_ocor_id,ocoresp_esp_id_espectador,ocoresp_avaliacao,ocoresp_comentario)
    values (idOcor, idEspetador,avaliacao,comentario);
END $$
DELIMITER ;

-- Alínea D
-- RE04
drop procedure if exists sp_remover_comunicação;
delimiter $$
create procedure sp_remover_comunicação(idOcor INT)
BEGIN
	DECLARE aux INT;
	SELECT 
    COUNT(ocoresp_avaliacao)
	FROM ocorrencia_espectador
	WHERE ocoresp_ocor_id = idOcor
	INTO aux;
    IF aux = 0 THEN
		DELETE FROM ocorrencia_espectador 
		WHERE ocoresp_ocor_id = idOcor;
	ELSE 
		SELECT CONCAT("ERRO: O conteúdo tem comentários.") as Mensagem;
	END IF;
END $$
DELIMITER ;


-- Monitorização de comunicações, suas avaliações e comentários
-- ALINEA A
-- RE06
DROP TRIGGER IF EXISTS trg_notificar_av_neg;
DELIMITER $$
CREATE TRIGGER trg_notificar_av_neg
AFTER INSERT ON ocorrencia_espectador
FOR EACH ROW
BEGIN
	DECLARE aux double;
    DECLARE countAv_Neg, audav_ocor_id INT;
    
    SELECT  aux_AVG
	FROM auxiliar
	ORDER BY aux_id DESC
    INTO aux;
	
    SELECT COUNT(*)
	FROM ocorrencia_espectador
	WHERE ocoresp_avaliacao < 4
	INTO countAv_Neg;
    
    SELECT ocoresp_ocor_id
    FROM ocorrencia_espectador
    WHERE ocoresp_ocor_id = NEW.ocoresp_ocor_id
    INTO audav_ocor_id;
    
    IF (countAv_Neg >=  296) THEN
		insert into avaliacoes_audit (audav_ocor_id,audav_notificar,audav_mensagem)
		values (audav_ocor_id,true, "Tem recebido muitas avaliações negativas!!");
	ELSE
		insert into avaliacoes_audit (audav_ocor_id,audav_notificar,audav_mensagem)
		values (audav_ocor_id,false,"");
    END IF;
END $$

-- Alínea B
-- RE07
-- refere ao trg_verificacao_profanidade
DROP EVENT IF EXISTS ev_AVG_avaliacoes;
CREATE EVENT IF NOT EXISTS ev_AVG_avaliacoes
ON SCHEDULE
    EVERY 1 MINUTE
    STARTS '2019-06-09 18:27:15' ON COMPLETION PRESERVE ENABLE
  DO
INSERT INTO auxiliar (aux_data_hora,aux_AVG)
SELECT 
    now(), AVG(a.count_neg_avaliacoes)
FROM
    (SELECT COUNT(ocoresp_avaliacao) AS count_neg_avaliacoes
    FROM ocorrencia_espectador
    WHERE ocoresp_avaliacao < 4) a;


drop trigger if exists trg_verificacao_profanidade;
DELIMITER $$
CREATE TRIGGER trg_verificacao_profanidade
BEFORE INSERT ON ocorrencia_espectador
FOR EACH ROW
BEGIN

	IF (NEW.ocoresp_comentario LIKE "%N%u%n%c%a%" OR NEW.ocoresp_comentario = "Nunca") THEN
       SET NEW.ocoresp_comentario = "Comentário Removido. Palavras ofensivas detectadas";
			INSERT into palavras_ofensivas_audit (processo,ocorrencia,ocoresp_esp_id_espectador)
			values ("pal_ofen", now(),NEW.ocoresp_esp_id_espectador);
		END IF;
END $$
DELIMITER ;







					