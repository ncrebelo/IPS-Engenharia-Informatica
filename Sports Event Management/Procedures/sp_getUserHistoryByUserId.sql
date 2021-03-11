use eventos;

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
