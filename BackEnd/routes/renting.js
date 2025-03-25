const router = require('express').Router();
const Rental = require('../model/Rental');
const User = require('../model/User');
const { rentalValidation } = require('../validation');
const verify = require('../verifyToken');
const formidable = require("formidable");
const fs = require('fs');
const path = require('path');

// * ADD RENTAL PROPERTY
router.post('/add', verify, async (req, res) => {
    console.log("🔹 Received request to add rental property");

    const form = formidable.IncomingForm();
    form.multiples = true;
    form.maxFileSize = 50 * 1024 * 1024; // 50MB

    form.parse(req, async (err, fields, files) => {
        if (err) {
            console.error("❌ Error parsing form:", err);
            return res.status(500).send("Error parsing form data");
        }

        console.log("✅ Parsed fields:", fields);
        console.log("✅ Parsed files:", files);

        // Validate rental data
        const { error } = rentalValidation(fields);
        if (error) {
            console.error("❌ Validation error:", error.details[0].message);
            return res.status(400).send(error.details[0].message);
        }

        // Check if user exists
        const findUser = await User.findById(req.user._id);
        if (!findUser) {
            console.error("❌ User not found:", req.user._id);
            return res.status(404).send("User not found");
        }

        // Handle file upload
        if (!files.rentalImage) {
            console.error("❌ No image uploaded");
            return res.status(400).send("Rental image is required");
        }

        const oldPath = files.rentalImage.path;
        const newFileName = `rentalImage_${Date.now()}.jpg`;
        const newPath = path.join(__dirname, '../uploads', newFileName);

        console.log("🖼️ Saving image to:", newPath);

        const rawData = fs.readFileSync(oldPath);

        // Create rental property
        const rental = new Rental({
            userId: findUser._id,
            address: fields.address,
            rentalImage: `uploads/${newFileName}`
        });

        try {
            fs.writeFileSync(newPath, rawData);
            console.log("✅ Image successfully saved");

            const savedRental = await rental.save();
            console.log("✅ Rental property saved successfully:", savedRental);

            res.status(201).send({ rental: rental._id });
        } catch (err) {
            console.error("❌ Error saving rental property:", err);
            res.status(400).send(err);
        }
    });
});

// * VIEW ALL RENTAL PROPERTIES
router.get('/viewAll', async (req, res) => {
    try {
        console.log("🔹 Fetching all rental properties");
        const rentals = await Rental.find();
        return res.status(200).send(rentals);
    } catch (err) {
        console.error("❌ Error fetching rentals:", err);
        res.status(500).send("Error fetching rental properties");
    }
});

// * VIEW LOGGED IN USER RENTAL PROPERTIES
router.get('/viewMyProperties', verify, async (req, res) => {
    try {
        console.log("🔹 Received request to fetch user properties");
        console.log("✅ User ID from Token:", req.user ? req.user._id : "No user ID");

        if (!req.user || !req.user._id) {
            return res.status(401).send("Unauthorized: No user ID found");
        }

        const properties = await Rental.find({ userId: req.user._id });

        console.log("✅ Rental properties found:", properties.length);
        if (properties.length === 0) return res.status(404).send("No properties found");

        return res.status(200).json(properties);
    } catch (error) {
        console.error("❌ Error fetching user rental properties:", error.message);
        return res.status(500).send("Internal Server Error");
    }
});

// * VIEW SINGLE RENTAL PROPERTY BY ID
router.get('/view/:id', async (req, res) => {
    try {
        if (!req.params.id.match(/^[0-9a-fA-F]{24}$/)) return res.status(400).send("Invalid ID");

        const rental = await Rental.findById(req.params.id);
        if (!rental) return res.status(404).send("Property not found");

        return res.status(200).send(rental);
    } catch (err) {
        console.error("❌ Error fetching rental property:", err);
        res.status(500).send("Error fetching property");
    }
});

// * UPDATE RENTAL PROPERTY
router.put('/update/:id', verify, async (req, res) => {
    if (!req.params.id.match(/^[0-9a-fA-F]{24}$/)) return res.status(400).send("Invalid ID");

    const form = formidable.IncomingForm();
    form.multiples = true;
    form.maxFileSize = 50 * 1024 * 1024;

    form.parse(req, async (err, fields, files) => {
        if (err) {
            console.error("❌ Error parsing update form:", err);
            return res.status(500).send("Error parsing form data");
        }

        console.log("✅ Update fields:", fields);

        const { error } = rentalValidation(fields);
        if (error) return res.status(400).send(error.details[0].message);

        try {
            let updateData = { address: fields.address };

            if (files.rentalImage) {
                const oldPath = files.rentalImage.path;
                const newFileName = `rentalImage_${Date.now()}.jpg`;
                const newPath = path.join(__dirname, '../uploads', newFileName);

                fs.writeFileSync(newPath, fs.readFileSync(oldPath));
                updateData.rentalImage = `uploads/${newFileName}`;
            }

            const updatedRental = await Rental.findByIdAndUpdate(req.params.id, updateData, { new: true });
            if (!updatedRental) return res.status(404).send("Property not found");

            res.status(200).send(updatedRental);
        } catch (err) {
            console.error("❌ Error updating rental property:", err);
            res.status(500).send("Error updating property");
        }
    });
});

// * DELETE RENTAL PROPERTY
router.delete('/delete/:id', verify, async (req, res) => {
    console.log("🔹 Received request to delete rental property");

    if (!req.params.id.match(/^[0-9a-fA-F]{24}$/)) return res.status(400).send("Invalid ID");

    try {
        const deletedProperty = await Rental.findByIdAndDelete(req.params.id);
        if (!deletedProperty) return res.status(404).send("Property not found");

        fs.unlink(deletedProperty.rentalImage, (err) => {
            if (err) console.warn("⚠️ Image delete failed:", err);
            else console.log("✅ Image deleted:", deletedProperty.rentalImage);
        });

        res.status(204).send("Deleted property");
    } catch (err) {
        console.error("❌ Error deleting property:", err);
        res.status(500).send("Error deleting property");
    }
});

module.exports = router;
