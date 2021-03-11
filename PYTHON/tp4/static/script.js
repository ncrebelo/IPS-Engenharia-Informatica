/**
 * REST Client
 *
 */

function getUsers() {
    var req = new XMLHttpRequest();
    req.open("GET", "/api/user/");
    req.addEventListener("load", function() {
        var users = JSON.parse(this.responseText);
        var ul = document.getElementById('users');
        ul.innerHTML = '';
        for (var i in users) {
            var li = document.createElement('li');
            li.innerHTML = users[i].name + ' (' + users[i].age + ')';
            li.innerHTML += " <button onclick='updateUser(" + users[i].id +  ")'>Update</button>";
            li.innerHTML += " <button onclick='deleteUser(" + users[i].id +  ")'>Delete</button>";
            ul.appendChild(li);
        }
    });
    req.send();
}



function signIn(){
    var form = document.getElementById("loginform");

    var username = form.username.value;
    var password = form.password.value;

    var req = new XMLHttpRequest();
    req.open("POST", "/api/user/", true);
    req.setRequestHeader("Content-Type", "application/json");

    req.addEventListener("load", function() {
        getUsers();
    });

    var data = JSON.stringify({"username": username, "password": password});
    req.send(data);
    //console.log("Signed in: " + " " + username + " " + password);
    loadContent();
}


function addUser() {
    var form = document.getElementById("regform");

    var name = form.name.value;
    var email = form.email.value;
    var username = form.username.value;
    var password = form.password.value;

    var req = new XMLHttpRequest();
    req.open("POST", "/api/user/register/", true);
    req.setRequestHeader("Content-Type", "application/json");

    req.addEventListener("load", function() {
        getUsers();
    });

    var data = JSON.stringify({"name": name, "email": email, "username": username, "password": password});
    req.send(data);
    console.log("Add: " + name + " " + email + " " + username + " " + password);
    loadContent();

}

function loadContent(){

    switchToContent("main_page");
}

function switchToContent(_div) {
    var pages = document.getElementById("main_page");

    pages.forEach(function (page) {
        page.style.display = "none";
    })

    document.getElementById(_div).style.display = "inline-block";
}
getUsers();



