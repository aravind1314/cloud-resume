const express = require("express");

const https = require("https");

const bodyParser = require("body-parser");

const app = express();

app.use(bodyParser.urlencoded({extended:true}));

app.use(express.static(__dirname + "/public", {
  index: false, 
  immutable: true, 
  cacheControl: true,
  maxAge: "30d"
}));


app.get("/", function(req, res) {

  res.sendFile(__dirname+"/index.html");

});

app.listen(3000, function() {
  console.log("server has started on port 3000");
})