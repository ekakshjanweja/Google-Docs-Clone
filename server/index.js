const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const http = require("http");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
const Document = require("./models/document");

const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
var io = require("socket.io")(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

const DB =
  "mongodb+srv://ekaksh:ekaksh31@cluster0.f2lzvx2.mongodb.net/?retryWrites=true&w=majority";

mongoose
  .connect(DB)
  .then((result) => {
    console.log("Connection Successful!");
  })
  .catch((err) => {
    console.log(err);
  });

io.on("connection", (socket) => {
  socket.on("join", (documentId) => {
    socket.join(documentId);
  });

  socket.on("typing", (data) => {
    socket.broadcast.to(data.room).emit("changes", data);
  });

  socket.on("save", async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
  });
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
