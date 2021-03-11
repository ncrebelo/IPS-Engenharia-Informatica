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