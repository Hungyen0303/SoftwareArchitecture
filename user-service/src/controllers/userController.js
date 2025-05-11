const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');

// Generate JWT token
const generateToken = (userId) => {
    return jwt.sign({ userId }, "your_jwt_secret_key", { expiresIn: '24h' });
};

// Register new user
const register = async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { email, password, firstName, lastName } = req.body;

        // Check if user already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ error: 'Email already registered' });
        }

        // Create new user
        const user = new User({
            email,
            password,
            firstName,
            lastName
        });

        await user.save();
        const token = generateToken(user._id);

        res.status(201).json({
            user: user.getPublicProfile(),
            token
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ 
            error: 'Server error',
            message: process.env.NODE_ENV === 'development' ? error.message : 'An error occurred during registration'
        });
    }
};

// Login user
const login = async (req, res) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { email, password } = req.body;

        // Find user by email
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        // Check password
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const token = generateToken(user._id);

        res.json({
            user: user.getPublicProfile(),
            token
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ 
            error: 'Server error',
            message: process.env.NODE_ENV === 'development' ? error.message : 'An error occurred during login'
        });
    }
};

// Get user profile
const getProfile = async (req, res) => {
    try {
        res.json(req.user.getPublicProfile());
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
};

// Update user profile
const updateProfile = async (req, res) => {
    const updates = Object.keys(req.body);
    const allowedUpdates = ['firstName', 'lastName', 'address', 'phoneNumber'];
    const isValidOperation = updates.every(update => allowedUpdates.includes(update));

    if (!isValidOperation) {
        return res.status(400).json({ error: 'Invalid updates' });
    }

    try {
        updates.forEach(update => req.user[update] = req.body[update]);
        await req.user.save();
        res.json(req.user.getPublicProfile());
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Delete user account
const deleteAccount = async (req, res) => {
    try {
        await req.user.remove();
        res.json({ message: 'Account deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
};

// Get all users (admin only)
const getAllUsers = async (req, res) => {
    try {
        const users = await User.find({});
        res.json(users.map(user => user.getPublicProfile()));
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
};

module.exports = {
    register,
    login,
    getProfile,
    updateProfile,
    deleteAccount,
    getAllUsers
}; 