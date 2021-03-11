/**
 * Class that handles the requests made to the database
 * @author Nuno Rebelo - 18022107
 */

const Util = require("./utils.js");
const path = require("path");
const mysql = require("mysql");
const connectionOptions = require("../con_options/connection_options.json");

/**
 * returns all users
 * @param {*} req 
 * @param {*} res 
 */
function users(req, res){
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = mysql.format(
    "SELECT userName FROM registereduser");
    connection.query(sql, function (err, rows, fields) {
      if (err) res.sendStatus(500);
      else res.json(rows);
    });
}
module.exports.users = users;


/**
 * returns a user with ID equal to the ID sent to the database
 * @param {*} req 
 * @param {*} res 
 */
function getUserId(req, res){
  var userId = req.params.userId;
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = mysql.format("SELECT userName FROM registereduser WHERE userId = ?" ,[userId]);
  connection.query(sql, function (err, rows, fields) {
    if (err) res.sendStatus(500);
    else res.json(rows);
  });
  connection.end();
}
module.exports.getUserId = getUserId;

/**
 * returns a user with username equal to the username sent to the database
 * @param {*} req 
 * @param {*} res 
 */
function getUserName(req, res){
  var userName = req.params.userName;
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = mysql.format("SELECT userName FROM registereduser WHERE userName = ?" ,[userName]);
  connection.query(sql, function (err, rows, fields) {
    if (err) res.sendStatus(500);
    else res.json(rows);
  });
  connection.end();
}
module.exports.getUserName = getUserName;

/**
 * returns all recipies
 * @param {*} req 
 * @param {*} res 
 */
function getRecipies(req, res){
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = mysql.format("SELECT * FROM recipe");
  connection.query(sql, function (err, rows, fields) {
    if (err) res.sendStatus(500);
    else res.json(rows);
  });
  connection.end();
}
module.exports.getRecipies = getRecipies;

/**
* returns all ingredients
 * @param {*} req 
 * @param {*} res 
 */
function getIngredients(req, res){
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = mysql.format("SELECT ingredientName FROM ingredient");
  connection.query(sql, function (err, rows, fields) {
    if (err) res.sendStatus(500);
    else res.json(rows);
  });
  connection.end();
}
module.exports.getIngredients = getIngredients;

/**
* returns all instructions
 * @param {*} req 
 * @param {*} res 
 */
function getInstructions(req, res){
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = mysql.format("SELECT instruction FROM instructions");
  connection.query(sql, function (err, rows, fields) {
    if (err) res.sendStatus(500);
    else res.json(rows);
  });
  connection.end();
}
module.exports.getInstructions = getInstructions;

/**
 * compares login information against db information
 * @param {String} req 
 * @param {String} res 
 */
function validateLogin(req, res, callback) {
  var userName = req.params.userName;
  var pwd = req.params.userPassword;
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = connection.format(
    "SELECT userPassword FROM registereduser WHERE userName = ?",
    [userName]);
    connection.query(sql, function (err, rows, fields) {
      if (err) 
      res.sendStatus(500);
      connection.end();
      if(callback){
        let hashedPwd = rows[0].userPassword;
        let verified = Util.passwordsMatch(pwd, hashedPwd);;
        if(verified){
          return callback(null, res.json(rows));
        }
        else{
          return callback (res.sendStatus(404), null);
        }
      }
    }); 
}
module.exports.validateLogin = validateLogin;

/**
 * compares registry information against db information
 * @param {*} req 
 * @param {*} res 
 */
function validateRegistration(req, res, callback){
  var errorMessage = "Username or Email already in use";
  var name = req.params.userName;
  var mail = req.params.email;
  var userPassword = req.params.userPassword;
  let hashedPassword = Util.passwordToHash(12, userPassword);
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = connection.format(
    "INSERT INTO registereduser (userName, email, userPassword) VALUES (?, ? ,?)", 
    [name, mail, hashedPassword]);
    connection.query(sql, function (err, rows, fields) {
    if (err){
       res.sendStatus(400);
    }
    else{
      if(rows.length < 1){
         res.send(errorMessage);
      }
      else {
        res.json(rows);
      }
    }
    });
    connection.end();
}
module.exports.validateRegistration = validateRegistration;


/**
 * updates the field with a boolean value
 * @param {*} req 
 * @param {*} res 
 */
function validateSubscription(req, res){
  var email = req.params.email;
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = connection.format(
    "UPDATE registereduser SET subscribed = true WHERE email = ?", 
    [email]);
    connection.query(sql, function (err, rows, fields) {
      if (err) res.sendStatus(500);
      else res.json(rows);
      connection.end();
    });
}
module.exports.validateSubscription = validateSubscription;


/**
* returns all news
 * @param {*} req 
 * @param {*} res 
 */
function getNews(req, res){
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = mysql.format("SELECT * FROM news");
  connection.query(sql, function (err, rows, fields) {
    if (err) res.sendStatus(500);
    else res.json(rows);
  });
  connection.end();
}
module.exports.getNews = getNews;

/**
 * adds to the db a new recipe, without details
 * @param {sub} req 
 * @param {*} res 
 */
function userRecipeSubmission(req, res){
  var name = req.params.recipeName;
  var image = req.params.img;
  var bool = 1;
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = connection.format(
    "INSERT INTO recipe (recipeName, userSubmitted, img) VALUES (?, ? ,?)", 
    [name, bool, image]);
    connection.query(sql, function (err, rows, fields) {
      if (err) res.sendStatus(500);
      else res.json(rows);
      connection.end();
    });
}
module.exports.userRecipeSubmission = userRecipeSubmission;


/**
 * 
 * @param {*} req 
 * @param {*} res 
 */
function userMessage(req, res){
  var name = req.params.fullName;
  var mail = req.params.email;
  var message = req.params.msgContent;
  var connection = mysql.createConnection(connectionOptions);
  connection.connect();
  var sql = connection.format(
    "INSERT INTO messages (fullName, email, msgContent) VALUES (?, ? ,?)",
    [name, mail, message]); 
    connection.query(sql, function (err, rows, fields) {
      if (err) res.sendStatus(500);
      else res.json(rows);
      connection.end();
    });
}
module.exports.userMessage = userMessage;

/**
 * re-routes the user to the home page
 * @param {String} request 
 * @param {String} response 
 */
function home(req, res) { 
  res.sendFile(path.join(__dirname, '../', 'index.html'));
}
module.exports.home = home;



