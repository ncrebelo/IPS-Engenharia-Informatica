drop function if exists fn_email_pessoa;
DELIMITER $$
CREATE FUNCTION fn_email_pessoa(pessoa_id int)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
	DECLARE aux varchar(40);
	SELECT 
		pess_email AS "Email"
	FROM
		pessoa
	WHERE
		pess_id = pessoa_id
	INTO aux;
	RETURN aux;
END$$
DELIMITER ;
