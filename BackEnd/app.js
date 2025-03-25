const path = require('path');
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require("cors");
const app = express();
const adminRoutes = require("./routes/admin");

// * IMPORT ROUTES
const authRoute = require('./routes/auth.js');
const rentingRoute = require('./routes/renting.js');
const chatRoute = require('./routes/chat.js');

// Load environment variables from .env file
dotenv.config();

// * CONNECT TO DB
const connectDB = async () => {
    try {
        const dbURI = process.env.DB_CONNECT || 'mongodb://127.0.0.1:27017/renting_app'; // Use the environment variable or fallback to local DB
        await mongoose.connect(dbURI, {
            // Removed the deprecated and unsupported options
        });
        console.log("*** DATABASE HAS CONNECTED SUCCESSFULLY");
    } catch (err) {
        console.error("Database connection failed:", err.message);
        process.exit(1);
    }
};


connectDB();

// * MIDDLEWARE
app.use(express.json());
app.use(cors());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// * ROUTES

app.use("/admin", adminRoutes); // Protect admin routes
app.use('/api/user', authRoute);
app.use('/api/rental', rentingRoute);
app.use("/api/chat", chatRoute);
app.get("/", (req, res) => {
    res.send("Server is working!");
});



// * SERVER START
app.listen(3000, '127.0.0.1', () => {
  console.log("Server running on http://127.0.0.1:3000");
});
