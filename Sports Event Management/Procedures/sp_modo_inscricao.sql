DROP PROCEDURE IF EXISTS sp_modo_inscricao;
DELIMITER $$
CREATE PROCEDURE sp_modo_inscricao()
BEGIN
	SELECT  evpar_inscricao AS "Forma de Inscrição", COUNT(evpar_inscricao) AS "Quantidade"
    FROM evento_participante
    GROUP BY evpar_inscricao;
END $$
DELIMITER ;