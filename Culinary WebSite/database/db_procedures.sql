use projpw;

DROP FUNCTION IF EXISTS sf_getrecipeId;
DROP FUNCTION IF EXISTS sf_getingredientId;
DROP PROCEDURE IF EXISTS sf_getinstructionId;
DROP PROCEDURE IF EXISTS sp_PopulateRecipe;
DROP PROCEDURE IF EXISTS sp_PopulateMessage;



DELIMITER //

CREATE FUNCTION sf_getrecipeId(recipeId_in BIGINT) RETURNS BIGINT
    DETERMINISTIC
BEGIN
	DECLARE recipeId BIGINT;
    
    SELECT recipeId INTO recipeId
    FROM recipe
    WHERE recipeId = recipeId_in;
    
    RETURN recipeId_in;
END//

CREATE FUNCTION sf_getingredientId(ingredientId_in BIGINT) RETURNS BIGINT
    DETERMINISTIC
BEGIN
	DECLARE ingredientId BIGINT;
    
    SELECT ingredientId INTO ingredientId
    FROM ingredient
    WHERE ingredientId = ingredientId_in;
    
    RETURN ingredientId_in;
END//

CREATE FUNCTION sf_getinstructionId(instructionId_in BIGINT) RETURNS BIGINT
    DETERMINISTIC
BEGIN
	DECLARE instructionId BIGINT;
    
    SELECT instructionId INTO instructionId
    FROM instructions
    WHERE instructionId = instructionId_in;
    
    RETURN instructionId_in;
END//


CREATE PROCEDURE sp_PopulateRecipe
(_recipeName varchar(99), _userSubmitted boolean, _img varchar(99))
BEGIN
	INSERT INTO recipe
		(recipeName, userSubmitted, img)
	VALUES
		(_recipeName, _userSubmitted,_img);
END//

CREATE PROCEDURE sp_PopulateMessage
(_fullName varchar(99), _email varchar(99), _msgContent varchar(999))
BEGIN
	INSERT INTO message
		(fullName, email, msgContent)
	VALUES
		(_fullName, _email,_msgContent);
END//
