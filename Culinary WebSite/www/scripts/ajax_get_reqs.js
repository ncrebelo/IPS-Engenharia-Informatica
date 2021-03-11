/**
 * handles requests with HTTP ver = GET
 * @author Nuno Rebelo - 18022107
 */

 /**
  * loads all recipies and news to be displayed in their respective section
  */
window.onload = function () {
    requestRecipies();
    requestNews();
}


 /**
 * @function postRequest general function that establishes and HTTP request - GET, 
 * atferwhich, sending the body with the values and executing it when ready
 * @param {String} url request path
 * @param {function} onReadyFunction function to be executed when ready 
*/
function getRequest(url, onReadyFunction) {
    var xhr = new XMLHttpRequest();
    if (xhr) {
        xhr.open("GET", "http://localhost:5501" + url, true);
        xhr.onreadystatechange = function () {
            if ((this.readyState === 4) && (this.status === 200)) {
                onReadyFunction(xhr);
            };
        }
    };
    xhr.send();
}

 /**
 * requests the DB to return a user based on its id field
 * @param {number} userId 
 */
function requestUser(userId){
    let url = "/requestUser/" + userId;
    getRequest(url, function (xhr) {
    });
}
    


/**
 * requests the DB to return a user based on its userName field
 * @param {String} userName 
 */
function requestUserByUserName(userName){
    let url = "/requestUserByUserName/" + userName;
    getRequest(url, function (xhr) {
    });
};

/**
 * requests the DB to return all recipies
 */
function requestRecipies(){
    let url = "/requestrecipies/";
    getRequest(url, function (xhr) {
        defaultRecipeList = [];
        var recipies = JSON.parse(xhr.responseText);
        recipies.forEach(function (recipe){
            new Recipe(recipe.recipeName, recipe.img);
        });
    }); 
};


/**
 * requests the DB to return all ingredients
 */
function requestIngredients(){
    let url = "/requestingredients/";
    getRequest(url, function (xhr) {
    });
};

/**
 * requests the DB to return all instructions
 */
function requestInstructions() {
    let url = "/requestinstructions/";
    getRequest(url, function (xhr) {
    });
};


/**
 * requests the DB to return all news
 */
function requestNews() {
    let url = "/requestnews/";
    getRequest(url, function (xhr) {
        defaultNewsList = [];
        var newses = JSON.parse(xhr.responseText);
        newses.forEach(function (news){
            new News(news.headline, news.img);
        });
    });
};



