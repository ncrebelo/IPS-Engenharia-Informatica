/**
 * handles requests with HTTP ver = POST
 * @author Nuno Rebelo - 18022107
 */

/**
 * @function postRequest general function that establishes and HTTP request - POST, 
 * atferwhich, sending the body with the values and executing it when ready
 * @param {String} url request path
 * @param {String} sendValues concat of values to be sent
 * @param {function} onReadyFunction function to be executed when ready 
 */
function postRequest(url, sendValues, onReadyFunction) {
    var xhr = new XMLHttpRequest();
    if (xhr) {
        xhr.open("POST", "http://localhost:5501" + url + sendValues, true);
        xhr.onreadystatechange = function () {
            if ((this.readyState === 4) && (this.status === 200)) {
                onReadyFunction(xhr);
            };
        }
    };
    xhr.send();
}


/**
 * Requests the DB to validate user credentials
 */
function requestLogin(){
    var username = login_form.username.value;
    var pwd = login_form.psw.value;
    var url = "/requestLogin/";
    var sendValue = username + "/" + pwd;
    postRequest(url, sendValue, function (xhr){ 
        if(xhr){
            alert("Welcome back " + username);
            login();
            loadHome();
        }
    });
}

/**
 * Requests the DB to add a new user 
 */
function registerUser(){
    var username = register_form.username.value;
    var email = register_form.email.value;
    var pwd = register_form.psw.value;
    var url = "/registerUser/";
    var sendValue = username + "/" + email + "/" + pwd;
    postRequest(url, sendValue, function (xhr){ 
        if(xhr){
            alert("An email has been sent to your inbox. Please log in!");
        }
        else{
            alert("Username or Email is on use.");
        }
    });
}

/**
 * Requests the DB to add a new recipe 
 */
function submitRecipe(){
    var recipeName = recipesubmission.recipeName.value;
    var bool = 1;
    var img = recipesubmission.recipefileURL.value; // www/images/db/ filename.ext
    var url = "/submitrecipe/";
    var sendValue = recipeName + "/" + bool + "/" + img;
    postRequest(url, sendValue, function (xhr){ 
        if(xhr){
            alert("Recipe has been submitted");
        }
        else{
            alert("OOPS. Something went wrong");
        }
    });
}

/**
 * Requests the DB to add a new message 
 */
function submitMessage(){
    var fullName = message.fname.value;
    var email = message.email.value;
    var content = message.subject.value; 
    var url = "/submitmessage/";
    var sendValue = fullName + "/" + email + "/" + content;
    postRequest(url, sendValue, function (xhr){ 
        if(xhr){
            alert("Your Message has been sent");
        }
        else{
            alert("OOPS. Something went wrong");
        }
    });
}




