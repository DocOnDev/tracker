var exec = require("child_process").exec;

function start(response) {
  console.log("Request handler 'start' was called.");

  exec("ls -lah", function (error, stdout, stderr) {
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.write(stdout);
    response.end();
  });
}
exports.start = start;

function upload(response) {
  console.log("Request handler 'upload' was called.");
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.write("Hello Upload");
  response.end();
}
exports.upload = upload;

function personalize(response) {
  console.log("Request handler 'personalize' was called.");
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.write("Hello Personalize");
  response.end();
}
exports.personalize = personalize;
