const express = require("express");
const router = express.Router();
const User = require("../model/User");

// Get all users
router.get("/users", async (req, res) => {
  try {
    const users = await User.find({}, "name email role"); // Fetch user details without passwords
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: "Error fetching users" });
  }
});
// Delete a user
router.delete("/users/:id", async (req, res) => {
  try {
    await User.findByIdAndDelete(req.params.id);
    res.json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: "Error deleting user" });
  }
});


module.exports = router;
