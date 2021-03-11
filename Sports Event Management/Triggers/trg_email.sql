
drop trigger if exists trg_email;
DELIMITER $$
CREATE TRIGGER trg_email 
BEFORE UPDATE ON pessoa
FOR EACH ROW
BEGIN
		IF(NEW.pess_email NOT LIKE '%_@%_.__%') THEN
        SET NEW.pess_email = "emailinvalido";
        END IF;
END $$
DELIMITER ;
