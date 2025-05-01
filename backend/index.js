const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const router = require('./router/user_router');
require('dotenv').config();

const app = express();
const PORT = 8000;
const MONGO_URI = 'mongodb://localhost:27017/vilmart';

app.use(cookieParser()); 
app.use(express.json());
app.use(cors());


app.use('/', router);


mongoose.connect(MONGO_URI)
  .then(() => {
    app.listen(PORT, () => {
      console.error(`Dbconnected`);
      console.error(`running on the port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('DB Connection Error:', err);
  });
