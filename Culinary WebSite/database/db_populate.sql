use projpw;

-- USERS
INSERT INTO registereduser
	(userName,email, userPassword, subscribed)
VALUES
	("Nuno", "NunoAdmin@worldofsweets.com", "$2b$12$Qm0NW9Zb2Sf3Kxu0IAhZzen/Hw6fs2FL47oTStJAD3YIW6CBkEgSi", false),
	("cakeEater69", "cakeEater69@cakes.com","$2y$12$WpgJwma.nbnDZuFyDp0PYetBNzYBu5UvnDR7t3VKgZaykZOot9yE." , false),
	("sugarRush", "sugarRush@hotmail.com","$2y$12$WpgJwma.nbnDZuFyDp0PYetBNzYBu5UvnDR7t3VKgZaykZOot9yE." , false),
	("fatboy3000", "fatboy3000@hotmail.com", "$2y$12$WpgJwma.nbnDZuFyDp0PYetBNzYBu5UvnDR7t3VKgZaykZOot9yE.", false);
	
-- RECIPIES	
INSERT INTO recipe
	(recipeName, userSubmitted, img)
VALUES
	("Chocolate Cake", false,'/www/images/db/choccake.jpg'),
	("NY Cheesecake", false,'/www/images/db/nycheesecake.jpg'),
	("Chocolate Salame", false,'/www/images/db/chocsalame.jpg');


-- INGREDIENTS
INSERT INTO ingredient
	(ingredientName)
VALUES
	("Powdered Chocolate"),
	("Sugar"),
	("Butter"),
	("Powdered Sugar"),
	("Milk"),
	("Egg"),
	("Flour"),
	("Sour Cream"),
	("Graham Crackers"),
	("Vanilla Extract"),
	("Lemon Zest"),
	("Icing Sugar"),
	("Cream Milk"),
	("Peanut Butter"),
	("Baking Soda"),
	("Cocunut Oil"),
	("Coffee"),
	("Oil"),
	("Chocolate Chips"),
	("Cinnamon"),
	("Brown Sugar");
	
	
INSERT INTO instructions
	(instruction)
VALUES
	("Whisk 3 cups flour, the baking powder and salt in a bowl until combined. Beat 2 sticks butter and the sugar in a large bowl with a mixer on medium-high speed"),
	("Heat oven to 180C/160C fan/gas 4, butter and line the base of two 20cm spring-form cake tins with baking parchment."),
	("Using an electric whisk beat the butter and sugar together until pale and fluffy. Crack the eggs in one at a time and whisk well, 
		scraping down the sides of the bowl after each addition. Add the lemon zest, vanilla, flour, milk and a pinch of salt. 
		Whisk until just combined then divide the mixture between the two tins."),
	("Bake in the centre of the oven for 25-30 mins until a skewer inserted into the middle of each cake comes out clean. 
		After 10 mins remove the cakes from their tins and leave to cool completely on a wire rack. Fill how you like. 
		My personal favourite is a good dollop of lemon curd and some fresh cream, then dust the top with icing sugar. Will keep for 3 days."),
	("Heat the oven to 180C/160C Fan/Gas 4 and line two 18cm/7in cake tins with baking parchment."),
	("Cream the butter and the sugar together until pale. Use an electric hand mixer if you have one. Beat in the eggs."),
	("Sift over the flour and fold in using a large metal spoon."),
	("The mixture should be of a dropping consistency; if it is not, add a little milk."),
	("Divide the mixture between the cake tins and gently spread out with a spatula. Bake for 20-25 minutes, or until an inserted skewer comes out clean. 
		Allow to stand for 5 minutes before turning on to a wire rack to cool."),
	("Sandwich the cakes together with jam, lemon curd or whipped cream and berries or just enjoy on its own."),
	("Preheat oven to 350 degrees F (175 degrees C). Grease and flour a 9x9 inch pan or line a muffin pan with paper liners."),
	("In a medium bowl, cream together the sugar and butter. Beat in the eggs, one at a time, then stir in the vanilla. Combine flour and baking powder, 
		add to the creamed mixture and mix well. Finally stir in the milk until batter is smooth. Pour or spoon batter into the prepared pan."),
	("Bake for 30 to 40 minutes in the preheated oven. For cupcakes, bake 20 to 25 minutes. Cake is done when it springs back to the touch."),
	("Heat the oven to 180°C (gas mark 4). Lightly grease an 18cm (7in) round cake tin with a little extra butter or margarine and cut a piece of 
		greaseproof paper or non-stick baking parchment to fit the base of the tin."),
	("Put all the ingredients into a large mixing bowl and beat with a wooden spoon or a hand-held mixer for 1 minute, or until just combined. 
		It's important not to beat the batter too much - just long enough to make it smooth."),
	("Pour or spoon the mixture into the tin, smooth the top and bake on the middle shelf of the oven for about 45-50 minutes. The cake is cooked when it looks well risen and golden; 
		the top should spring back when lightly touched with a fingertip. Another test is to insert a skewer into the centre of the cake - it should come out clean."),
	("Let the cake sit in the tin for 5 minutes, then gently run a knife around the edge and turn the cake out onto a wire rack to cool. Serve dusted with icing sugar."),
	("Heat the oven to 180C/160C fan/gas 4. Oil and line the base of two 18cm sandwich tins. Sieve the flour, cocoa powder and 
		bicarbonate of soda into a bowl. Add the caster sugar and mix well."),
	("Make a well in the centre and add the golden syrup, eggs, sunflower oil and milk. Beat well with an electric whisk until smooth."),
	("Pour the mixture into the two tins and bake for 25-30 mins until risen and firm to the touch. Remove from oven, leave to cool 
		for 10 mins before turning out onto a cooling rack."),
	("To make the icing, beat the unsalted butter in a bowl until soft. Gradually sieve and beat in the icing sugar and cocoa powder, 
		then add enough of the milk to make the icing fluffy and spreadable."),
	("Sandwich the two cakes together with the butter icing and cover the sides and the top of the cake with more icing.");
	
	
INSERT INTO recipe_ingredients
	(recipeId, ingredientId, amount, amountType)
VALUES
	(sf_getrecipeId(1), sf_getingredientId(1), 0.5, "kg"),
	(sf_getrecipeId(1), sf_getingredientId(2), 0.5, "kg"),
	(sf_getrecipeId(1), sf_getingredientId(3), 0.2, "kg"),
	(sf_getrecipeId(1), sf_getingredientId(5), 1.0, "lt"),
	(sf_getrecipeId(1), sf_getingredientId(6), 6, "#"),
    (sf_getrecipeId(2), sf_getingredientId(1), 0.5, "kg"),
	(sf_getrecipeId(2), sf_getingredientId(2), 0.5, "kg"),
	(sf_getrecipeId(2), sf_getingredientId(3), 0.2, "kg"),
	(sf_getrecipeId(2), sf_getingredientId(15), 0.3, "kg"),
	(sf_getrecipeId(2), sf_getingredientId(7), 0.3, "kg"),
    (sf_getrecipeId(3), sf_getingredientId(13), 0.5, "lt"),
	(sf_getrecipeId(3), sf_getingredientId(8), 1.0, "kg"),
	(sf_getrecipeId(3), sf_getingredientId(9), 0.5, "kg"),
	(sf_getrecipeId(3), sf_getingredientId(3), 0.6, "kg"),
	(sf_getrecipeId(3), sf_getingredientId(7), 0.3, "kg");
    
    
INSERT INTO recipe_instructions
	(recipeId, instructionId)
VALUES	
	(sf_getrecipeId(1), sf_getinstructionId(1)),
    (sf_getrecipeId(1), sf_getinstructionId(2)),
    (sf_getrecipeId(1), sf_getinstructionId(3)),
    (sf_getrecipeId(1), sf_getinstructionId(4)),
    (sf_getrecipeId(2), sf_getinstructionId(5)),
    (sf_getrecipeId(2), sf_getinstructionId(6)),
    (sf_getrecipeId(2), sf_getinstructionId(7)),
    (sf_getrecipeId(3), sf_getinstructionId(8)),
    (sf_getrecipeId(3), sf_getinstructionId(9)),
    (sf_getrecipeId(3), sf_getinstructionId(10));
	
	
INSERT INTO news
	(headline, newscontent, img)
VALUES
	("Valentine Suggestions","We are taking a different approach to Valentine’s Day this year and focusing on ‘sharing the love’ with family and friends as well as partners. 
	When you open the ‘Let’s Make Valentine’s Cookies’ baking box, you will find it contains all the essential products to bake at least 12 delicious heart cookies. 
	We have included two different coloured icings, rose gold blush sprinkles and the ‘With Love’ embosser so that you or your family can enjoy designing and decorating cookies 
	for the loved ones in your life – a great project to keep little ones busy too!","/www/images/db/val.jpg"),
	("Viral McDonald's Burger Cake Finds Many Takers On The Internet; See How It Looks Like", "A Reddit user posted a picture of the 'burger cake' that soon went viral. 
		Surprisingly, most of the followers were all in for this savoury cake, maybe because it was made with their favourite food - burgers, which find more preference than a sweet cake.",
		"/www/images/db/mcd.jpg");
	
    

