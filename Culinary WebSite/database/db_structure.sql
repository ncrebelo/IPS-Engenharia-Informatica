drop schema if exists ProjPW;
CREATE SCHEMA ProjPW;

use ProjPW;

CREATE TABLE RegisteredUser(
	userId BIGINT AUTO_INCREMENT PRIMARY KEY,
    userName NVARCHAR(99) UNIQUE NOT NULL,
    email NVARCHAR(99) UNIQUE NOT NULL,
	userPassword NVARCHAR(99) NOT NULL,
	subscribed BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE Recipe(
	recipeId BIGINT AUTO_INCREMENT PRIMARY KEY,
	recipeName NVARCHAR(99) UNIQUE NOT NULL,
	userSubmitted BOOLEAN DEFAULT FALSE NOT NULL,
	img NVARCHAR(99) NOT NULL
);

CREATE TABLE Ingredient(
	ingredientId BIGINT AUTO_INCREMENT PRIMARY KEY,
    ingredientName NVARCHAR(99) UNIQUE NOT NULL
);

CREATE TABLE Instructions(
	instructionId BIGINT AUTO_INCREMENT PRIMARY KEY,
	instruction NVARCHAR(999) NOT NULL
);

CREATE TABLE Recipe_Ingredients(
	recipeId BIGINT NOT NULL,
	ingredientId BIGINT NOT NULL, 
	amount DECIMAL NOT NULL,
	amountType NVARCHAR(10) NOT NULL,
	primary key(recipeId, ingredientId)
);

CREATE TABLE Recipe_Instructions(
	recipeId BIGINT NOT NULL,
	instructionId BIGINT NOT NULL,
	primary key(recipeId, instructionId)
);

CREATE TABLE News(
	newsId BIGINT AUTO_INCREMENT PRIMARY KEY,
	headline NVARCHAR(99) NOT NULL,
	newscontent NVARCHAR(999) NOT NULL,
	img NVARCHAR(99) NOT NULL
);

CREATE TABLE Messages(
	msgId BIGINT AUTO_INCREMENT PRIMARY KEY,
    fullName NVARCHAR(99) UNIQUE NOT NULL,
	email NVARCHAR(99) UNIQUE NOT NULL,
    msgContent NVARCHAR(999) NOT NULL
);


ALTER TABLE Recipe_Ingredients
	ADD CONSTRAINT FOREIGN KEY (recipeId) REFERENCES Recipe(recipeId),
	ADD CONSTRAINT FOREIGN KEY (ingredientId) REFERENCES Ingredient(ingredientId);
	
ALTER TABLE	Recipe_Instructions
	ADD CONSTRAINT FOREIGN KEY (recipeId) REFERENCES Recipe(recipeId),
	ADD CONSTRAINT FOREIGN KEY (instructionId) REFERENCES Instructions(instructionId);
