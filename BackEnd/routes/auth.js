const router = require('express').Router();
const User = require('../model/User');
const { registervalidation, loginValidation } = require('../validation');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const verify = require('../verifyToken');

// * TEST ROUTE
router.get("/", (req, res) => {
    res.send("User API is working!");
});

// * REGISTER
router.post('/register', async (req, res) => {
    // * VALIDATE DATA
    const { error } = registervalidation(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    // * CHECK IF EMAIL EXISTS
    const emailExist = await User.findOne({ email: req.body.email });
    if (emailExist) return res.status(400).send("Email already exists");

    const phoneExist = await User.findOne({ phoneNumber: req.body.phoneNumber });
    if (phoneExist) return res.status(400).send("Phone Number already exists");

    // * Hash passwords
    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(req.body.password, salt);

    // * Create a new user
    const user = new User({
        name: req.body.name,
        email: req.body.email,
        password: hashPassword,
        phoneNumber: req.body.phoneNumber
    });

    try {
        await user.save();
        res.status(201).send({ user: user._id });
    } catch (err) {
        res.status(400).send(err);
    }
});

// * LOGIN
router.post('/login', async (req, res) => {
    const { error } = loginValidation(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const user = await User.findOne({ email: req.body.email });
    if (!user) return res.status(400).send("Email or password is wrong.");

    const validPassword = await bcrypt.compare(req.body.password, user.password);
    if (!validPassword) return res.status(400).send("Email or password is wrong.");

    const token = jwt.sign({ _id: user._id }, 'secret');
    res.header('auth-token', token).send(token);
});

// * UPDATE ACCOUNT
router.put('/updateAccount', verify, async (req, res) => {
    const user = await User.findOne({ _id: req.user });
    if (!user) return res.status(404).send("User not found");

    const { error } = registervalidation(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(req.body.password, salt);
    user.name = req.body.name;
    user.email = req.body.email;
    user.password = hashPassword;
    user.phoneNumber = req.body.phoneNumber;

    try {
        await user.save();
        res.send({ user: user._id });
    } catch (err) {
        res.status(400).send(err);
    }
});

// * DELETE ACCOUNT
router.delete('/deleteAccount', verify, async (req, res) => {
    const user = await User.findOne({ _id: req.user });
    if (!user) return res.status(404).send("User not found");

    try {
        await user.remove();
        res.status(204).send({ message: "User deleted successfully" });
    } catch (err) {
        res.status(400).send(err);
    }
});

module.exports = router;
