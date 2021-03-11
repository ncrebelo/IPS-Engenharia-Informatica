/**
 * handles requests with HTTP ver = PUT
 * @author Nuno Rebelo - 18022107
 */


/**
 * @function putRequest general function that establishes and HTTP request - PUT, 
 * atferwhich, sending the body with the values and executing it when ready
 * @param {String} url request path
 * @param {String} sendValues concat of values to be sent
 * @param {function} onReadyFunction function to be executed when ready 
 */
function putRequest(url, sendValues, onReadyFunction) {
    var xhr = new XMLHttpRequest();
    if (xhr) {
        xhr.open("PUT", "http://localhost:5501" + url + sendValues, true);
        xhr.onreadystatechange = function () {
            if ((this.readyState === 4) && (this.status === 200)) {
                onReadyFunction(xhr);
            };
        }
    };
    xhr.send();
}

/**
 * request the DB to enable subscription. Changes the appropriate value to true
 */
function requestSubscription(){
    var email = document.getElementById("email-field").value;
    var url = "/subscribe/";
    putRequest(url, email, function (xhr){ 
        if(xhr){
            alert("You are now subscribed to our newsletter");
        }
        else{
            alert("OOPS. Something went wrong. Try again.");
        }
    });
}