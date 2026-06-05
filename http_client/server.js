const http = require("http");
http
	.createServer((req, res) => {
		res.writeHead(200, { "Content-Type": "application/json" });
		res.end(JSON.stringify({ message: "hello from node", path: req.url }));
		console.log("Connection received from", req.socket.remoteAddress);
	})
	.listen(3000, "0.0.0.0", () => console.log("listening on :3000"));
