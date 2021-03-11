/**
 * Class that creates a Recipe object
 * @author Nuno Rebelo - 18022107
 */
"use strict";

/**
 * default list
 */
var defaultRecipeList = [];

/**
 * constructor to create a new Recipe object and add it to the default list
 * @param {string} name 
 * @param {boolean} userSubmitted 
 */
function Recipe(name, img){
    this.name = name;
    
    Object.defineProperty(this, "img", {
        writable: true,
        enumerable: false,
        value: img
    });
    
    defaultRecipeList.push(this);
}


