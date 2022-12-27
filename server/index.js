const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document")

const PORT = process.env.PORT | 3001;

const app = express();

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

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
