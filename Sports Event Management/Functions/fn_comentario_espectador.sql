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


