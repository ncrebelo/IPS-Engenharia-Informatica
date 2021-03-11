/**
 * Class that creates an Ingredient object
 * @author Nuno Rebelo - 18022107
 */
"use strict";

/**
 * default list
 */
var defaultIngredientList = [];

/**
 * constructor to create a new ingredient and add it to the default list
 * @param {string} name 
 */
function Ingredient(name){
    this.name = name;

    defaultIngredientList.push(this);
}
