const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const jwt = require('jsonwebtoken');
const axios = require('axios');
require('dotenv').config();

const app = express();
const port = 8080;

// Middleware
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // Limit each IP to 100 requests per windowMs
});
app.use(limiter);

// JWT Authentication Middleware
const authenticateToken = (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({ message: 'Authentication token required' });
    }

    jwt.verify(token, 'your_jwt_secret_key', (err, user) => {
      if (err) {
        console.error('JWT verification error:', err.message);
        return res.status(403).json({ message: 'Invalid or expired token' });
      }
      req.user = user;
      next();
    });
  } catch (error) {
    console.error('Auth middleware error:', error.message);
    return res.status(500).json({ message: 'Authentication error' });
  }
};

// Hardcoded Service URLs
const SERVICES = {
  PRODUCT: 'http://product-service:8081',
  USER: 'http://user-service:8082',
  ORDER: 'http://order-service:8083'
};

// Simple forward request handler
const forwardRequest = async (req, res, targetService) => {
  try {
    const method = req.method.toLowerCase();
    const url = `${targetService}${req.originalUrl}`;
    
    // Log request
    console.log(`Forwarding ${method.toUpperCase()} ${req.originalUrl} to ${url}`);
    
    const cleanHeaders = { ...req.headers };
    
    delete cleanHeaders['content-length'];
    delete cleanHeaders['transfer-encoding'];
    delete cleanHeaders['host'];
    delete cleanHeaders['connection'];
    
    const headers = {
      ...cleanHeaders,
      'accept': 'application/json',
      'content-type': 'application/json'
    };
    
    // Cấu hình Axios với headers đã được lọc và tăng timeout
    const response = await axios({
      method,
      url,
      data: req.body,
      headers: headers,
      timeout: 30000, // Tăng lên 30 giây để tránh timeout
      maxContentLength: 100 * 1024 * 1024, // Cho phép response lớn (100MB)
      maxBodyLength: 100 * 1024 * 1024, // Cho phép request body lớn (100MB)
      validateStatus: false // Không ném lỗi với status code bất kỳ
    });
    
    // Forward response status, headers and body back to client
    res.status(response.status);
    
    // Copy important headers, skip problematic ones
    Object.entries(response.headers).forEach(([key, value]) => {
      if (!['content-length', 'connection', 'transfer-encoding'].includes(key.toLowerCase())) {
        res.setHeader(key, value);
      }
    });
    
    // Send response data back
    res.send(response.data);
  } catch (error) {
    console.error(`Error forwarding request to ${targetService}:`, error.message);
    
    // Handle common errors with simple messages
    if (error.code === 'ECONNREFUSED') {
      return res.status(503).json({
        message: 'Service Unavailable',
        error: `Service at ${targetService} is not running`
      });
    }
    
    // Generic error response
    res.status(502).json({
      message: 'Bad Gateway',
      error: `Failed to forward request to ${targetService}`
    });
  }
};

// Create route handlers
const userServiceHandler = (req, res) => forwardRequest(req, res, SERVICES.USER);
const productServiceHandler = (req, res) => forwardRequest(req, res, SERVICES.PRODUCT);
const orderServiceHandler = (req, res) => forwardRequest(req, res, SERVICES.ORDER);

// Define routes
// Public routes
app.post('/api/v1/users/login', userServiceHandler);
app.post('/api/v1/users/register', userServiceHandler);
app.get('/api/v1/users/auth', userServiceHandler);

// Protected routes - with authentication
app.all('/api/v1/products*', authenticateToken, productServiceHandler);
app.all('/api/v1/orders*', authenticateToken, orderServiceHandler);
app.all('/api/v1/users/profile*', authenticateToken, userServiceHandler);

// Simple health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(500).json({ 
    message: 'Internal Server Error',
    error: err.message
  });
});

// Start server with increased timeout
const server = app.listen(port, () => {
  console.log(`API Gateway listening on port ${port}`);
});

// Tăng timeout cho server để tránh đóng kết nối sớm
server.timeout = 60000; // 60 giây
server.keepAliveTimeout = 65000; // 65 giây
server.headersTimeout = 66000; // 66 giây