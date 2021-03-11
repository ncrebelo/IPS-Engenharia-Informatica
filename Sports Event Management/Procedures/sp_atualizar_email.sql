-- ATUALIZAR EMAIL
drop procedure if sp_atualizar_email ;
delimiter $$
create procedure sp_atualizar_email(in pessoa_id int,
								 in novo_email VARCHAR(50))
BEGIN
	UPDATE pessoa set pess_email = novo_email 
    WHERE pess_id = pessoa_id;
END $$
DELIMITER ;

