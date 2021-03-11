use eventos;

-- *********************************************
--					TESTES
-- *********************************************


-- *******************************************************
-- 			I.REQUISITOS MÍNIMOS
-- *******************************************************

-- VIEWS
-- RM01
select * from InformacaoEventos;
-- RM02
select * from InformacaoOcorrencias;
-- RM03
select * from InformacaoParticipantesPorEvento;
-- RM04
select * from media_avaliacoes_comentarios;
-- RM05
select * from top_espectador_avaliacoes;
-- RM06
select * from comentarios_avaliacoes;
-- RM07
select * from InformacaoEspectadoresPorEvento;


-- FUNCTIONS
-- RM08
select fn_comentario_espectador(1);
-- RM09
select fn_email_pessoa(300);

-- PROCEDURES
-- RM10
call sp_caracterisiticas_evento();
-- RM11
call sp_informação_ocorrencia();
-- RM12
call sp_aval_coment(31);
-- RM13
call sp_event_participantes();
-- RM14
call sp_idade_pessoa(1);
-- RM15
call sp_getUserHistoryByName("Dulce Josefino");
-- RM16
call sp_getUserHistoryByUserId(1);
-- RM17
call sp_event_patocinador("Continente");
-- RM18
call sp_modo_inscricao();
-- RM19
call sp_seguranca_eventos(2028);


-- TRIGGER
-- RM20
Update pessoa
set pess_email = "DulceJosefino"
Where pess_id = 1;

-- INSERÇÕES / ATUALIZAÇÕES
-- RM21 - Atualizar Email
call sp_atualizar_email(1,"DulceJosefino@hotmail.com");

-- REMOÇÕES
-- RM22 - Remover alojamento
call sp_remover_alojamento("Hotel Roma");



-- *******************************************************
-- 			II.REQUISITOS ESPECIFICOS 
-- *******************************************************


-- Alínea A
-- RE01
call sp_criar_comunicacao(31,str_to_date('2021.07.29','%Y.%m.%d'),'15:0:0','17:0:0',"VIII-Campeonato de Natação",
							11,"Pavilhão Desportivo Municipal da Venda do Pinheiro",@emailOut);
							
-- Alínea B
-- RE02
call sp_adicionar_comentario_a_comunicação(31,107,10,"sp_adicionar_comentario_a_comunicação");

-- Alínea C
-- RE03
call sp_adicionar_avaliação_a_comunicação(31,106,10,"")

-- Alínea D
-- RE04
call sp_remover_comunicação(31);

-- Alínea E
-- RE05


-- Monitorização de comunicações, suas avaliações e comentários

-- ALINEA A
-- RE06
-- VER EVENTOS


-- Alínea B
-- RE07
-- refere ao trg_verificacao_profanidade
call sp_adicionar_comentario_a_comunicação(31,86,10,"N u n c a");
call sp_adicionar_comentario_a_comunicação(31,85,10,"N*u*n*c*a");



-- *******************************************************
-- 						EVENTOS
-- *******************************************************

--REFERE AO RE06
select * from auxiliar;
show events;

