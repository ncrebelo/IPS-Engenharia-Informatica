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
