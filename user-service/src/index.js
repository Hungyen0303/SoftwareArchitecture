require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { body } = require('express-validator');
const { auth, adminAuth } = require('./middleware/auth');
const userController = require('./controllers/userController');

const app = express();
const port = process.env.PORT || 8082;

// Middleware
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

// Connect to MongoDB
const connectDB = async () => {
    try {
        const mongoURI = "mongodb+srv://nguyenhungyen0000:Hungyen%402003@cluster0.djkgyu0.mongodb.net";
        await mongoose.connect(mongoURI, {
            serverSelectionTimeoutMS: 5000,
            socketTimeoutMS: 45000,
        });
        console.log('Connected to MongoDB');
    } catch (err) {
        console.error('MongoDB connection error:', err);
        // Retry connection after 5 seconds
        setTimeout(connectDB, 5000);
    }
};

// Handle MongoDB connection events
mongoose.connection.on('error', err => {
    console.error('MongoDB connection error:', err);
});

mongoose.connection.on('disconnected', () => {
    console.log('MongoDB disconnected. Attempting to reconnect...');
    connectDB();
});

// Initial connection
connectDB();

// Validation middleware
const registerValidation = [
    body('email').isEmail().withMessage('Please enter a valid email'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long'),
    body('firstName').notEmpty().withMessage('First name is required'),
    body('lastName').notEmpty().withMessage('Last name is required')
];

const loginValidation = [
    body('email').isEmail().withMessage('Please enter a valid email'),
    body('password').notEmpty().withMessage('Password is required')
];

const updateProfileValidation = [
    body('firstName').optional().trim().notEmpty().withMessage('First name cannot be empty'),
    body('lastName').optional().trim().notEmpty().withMessage('Last name cannot be empty'),
    body('phoneNumber').optional().trim().matches(/^\+?[\d\s-]{10,}$/).withMessage('Invalid phone number format'),
    body('address').optional().isObject().withMessage('Address must be an object'),
    body('address.street').optional().trim().notEmpty().withMessage('Street cannot be empty'),
    body('address.city').optional().trim().notEmpty().withMessage('City cannot be empty'),
    body('address.state').optional().trim().notEmpty().withMessage('State cannot be empty'),
    body('address.country').optional().trim().notEmpty().withMessage('Country cannot be empty'),
    body('address.zipCode').optional().trim().matches(/^\d{5}(-\d{4})?$/).withMessage('Invalid zip code format')
];

// Routes
app.post('/api/v1/users/register', registerValidation, userController.register);
app.post('/api/v1/users/login', loginValidation, userController.login);
app.get('/api/v1/users/profile', auth, userController.getProfile);
app.patch('/api/v1/users/profile', auth, updateProfileValidation, userController.updateProfile);
app.delete('/api/v1/users/profile', auth, userController.deleteAccount);
app.get('/api/v1/users', adminAuth, userController.getAllUsers);

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'UP' });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        message: 'Internal Server Error',
        error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
});

app.listen(port, () => {
    console.log(`User Service listening on port ${port}`);
}); 