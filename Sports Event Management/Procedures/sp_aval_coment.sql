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