/**
 * Class that creates an Ingredient object
 * @author Nuno Rebelo - 18022107
 */
"use strict";

/**
 * default list
 */
var defaultNewsList = [];

/**
 * constructor to create a new News object and add it to the default list
 * @param {string} title 
 * @param {string} img 
 */
function News(title, img){
    this.title = title;
    
    Object.defineProperty(this, "img", {
        writable: true,
        enumerable: false,
        value: img
    });
 
    defaultNewsList.push(this);
}
