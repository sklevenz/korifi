var http = require('http');
var PORT = process.env.PORT || 3000;

http.createServer(function (req, res) {
  var body = JSON.stringify({
    environment: process.env,
    request: req.headers
  }, null, 2);
  res.useChunkedEncodingByDefault = false;
  res.writeHead(200, {
    "Content-Type": "application/json",
    "Content-Length": Buffer.byteLength(body, 'utf8')
  });
  res.end(body);
}).listen(PORT, function () {
  console.log("server running on http://localhost:" + PORT);
});
