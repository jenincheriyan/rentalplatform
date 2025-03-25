const jwt = require('jsonwebtoken');

function auth(req, res, next) {
    // Log all headers for debugging
    console.log("🔹 Received Headers:", req.headers);

    // Get token from both possible header formats
    let token = req.header('auth-token') || req.header('Authorization');

    // If the token is in "Bearer <token>" format, extract the token
    if (token && token.startsWith("Bearer ")) {
        token = token.split(" ")[1];
    }

    console.log("🔹 Extracted Token:", token || "No Token Found");

    if (!token) {
        console.error("❌ No token provided");
        return res.status(401).json({ error: 'Access Denied. No Token Provided' });
    }

    // Ensure SECRET_KEY is set
    if (!process.env.SECRET_KEY) {
        console.error("❌ SECRET_KEY is not defined in environment variables");
        return res.status(500).json({ error: 'Server Configuration Error' });
    }

    try {
        console.log("🔑 Expected Secret Key:", process.env.SECRET_KEY); // Debugging secret key
        const verified = jwt.verify(token, process.env.SECRET_KEY);
        req.user = verified;
        console.log("✅ Verified User:", req.user);
        next();
    } catch (err) {
        console.error("❌ Invalid Token:", err.message);
        res.status(400).json({ error: 'Invalid Token' });
    }
}

module.exports = auth;
