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