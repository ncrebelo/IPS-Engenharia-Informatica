"use strict";
var path = require("path");
const express = require("express");
const requestHandlers = require("./www/scripts/request-handlers.js");
const bodyParser = require("body-parser");
const app = express();

//manage CORS errors when "Open with Live Server" is used
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("www"));

//HOME
app.get("/www/views/", requestHandlers.home);

//USERS
app.get("/requestUserByUserName/:userName", requestHandlers.getUserName);
app.get("/requestUser/:userId", requestHandlers.getUserId);
app.post("/requestLogin/:userName/:userPassword", requestHandlers.validateLogin);
app.post("/registerUser/:userName/:email/:userPassword", requestHandlers.validateRegistration);
app.put("/subscribe/:email", requestHandlers.validateSubscription);
app.post("/submitrecipe/:recipeName/:userSubmitted/:img", requestHandlers.userRecipeSubmission);
app.post("/submitmessage/:fullName/:email/:msgContent", requestHandlers.userMessage);

//RECIPIES
app.get("/requestrecipies/", requestHandlers.getRecipies);
app.get("/requestingredients/", requestHandlers.getIngredients);
app.get("/requestinstructions/", requestHandlers.getInstructions);

//NEWS
app.get("/requestnews/", requestHandlers.getNews);


//SERVER
app.listen(5501, function () {
  console.log("Server running at http://localhost:5501");
});
