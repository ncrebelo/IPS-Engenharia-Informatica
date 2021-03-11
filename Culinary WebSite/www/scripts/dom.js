/**
 * classes that handles how the user interacts with objects
 * @author Nuno Rebelo - 18022107
 */

"use strict";

/**
 * Block of functions that load the appropriate section
 */
function loadHome(){
    switchToContent("page_home");
}

function loadForum(){
    switchToContent("page_forum");
}

function loadRecipeDetails(){
    switchToContent("recipedetails");
}

function loadSubmission(){
    switchToContent("page_submit");
}

function loadGame(){
    switchToContent("page_game");
}

function loadForm(){
    switchToContent("page_form");
}

function loadSSO(){
    switchToContent("page_login");
    
}

function loadRegister(){
    switchToContent("page_register");
}

/**
 * switches content shown
 * @param {*} _div 
 */
function switchToContent(_div) {
    var pages = document.getElementsByName("page");
    pages.forEach(function (page) {
        page.style.display = "none";
    })
    document.getElementById(_div).style.display = "inline-block";
}

/**
 * generic function to generate a Header
 * @param {*} arrColumns 
 */
function generateThead(arrColumns) {
    var thead = document.createElement("thead");
    var tr, td;

    tr = document.createElement("tr");

    for (var i = 0; i < arrColumns.length; i++) {
        td = document.createElement("td");
        td.appendChild(document.createTextNode(arrColumns[i]));
        tr.appendChild(td);
    }

    thead.appendChild(tr);

    return thead;
}

/**
 * generic function to generate a TD
 * @param {*} tr 
 * @param {*} text 
 */
function generateTd(tr, text) {
    var td = document.createElement("td");
    td.appendChild(document.createTextNode(text));
    tr.appendChild(td);
}

/**
 * generic function to generate a TD with a link
 * @param {*} tr 
 * @param {*} text 
 * @param {*} link 
 * @param {*} targetBlank 
 */
function generateTdLink(tr, text, link, targetBlank) {
    var td = document.createElement("td");
    var a = document.createElement("a");
    a.setAttribute("href", link);
    a.appendChild(document.createTextNode(text));

    if (targetBlank !== void 0 && targetBlank)
        a.setAttribute("target", "_blank");

    td.appendChild(a);
    tr.appendChild(td);
}

/**
 * generic function to generate an element
 * @param {*} elem 
 * @param {*} text 
 */
function generateElement(elem, text) {
    var elem = document.createElement(elem);
    elem.appendChild(document.createTextNode(text));
    return elem;
}


/**
 * toggles the text in the signin button, after successful login
 */
function login(){ 
    document.getElementsByClassName("SignIn")[0].getElementsByTagName('a')[0].style.display = "none";
    document.getElementsByClassName("Logout")[0].style.display = "";
}

/**
 * toggles the text in the logout button, after successful logout
 */
function logout(){
    document.getElementsByClassName("SignIn")[0].getElementsByTagName('a')[0].style.display = "inline-block";
    document.getElementsByClassName("Logout")[0].style.display = "none";
    alert("Logged Out Successfully");
    location.reload();
}





