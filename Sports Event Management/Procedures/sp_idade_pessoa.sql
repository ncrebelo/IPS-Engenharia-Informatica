drop procedure if exists sp_idade_pessoa;
delimiter $$
create procedure sp_idade_pessoa(id INT)
BEGIN
	SELECT pess_nome,TIMESTAMPDIFF(YEAR, pess_data_de_nascimento, CURDATE()) AS "Idade"
    from pessoa
    WHERE pess_id = id;
END$$
delimiter ;