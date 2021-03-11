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