# E-Commerce App

A Flutter-based e-commerce application with features like product browsing, shopping cart, user authentication, and order management.

## Features

- User authentication (login/register)
- Product browsing and search
- Shopping cart management
- Order placement and tracking
- User profile management
- Responsive design

## Prerequisites

- Flutter SDK (version 3.7.2 or higher)
- Dart SDK (version 3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Git

## Setup

1. Clone the repository:

```bash
git clone <repository-url>
cd ecommerce_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Create a `.env` file in the root directory with the following content:

```
API_URL=http://localhost:3000/api
AUTH_TOKEN=your_auth_token_here
```

4. Run the app:

```bash
flutter run
```

## Project Structure

```
lib/
  ├── config/         # Configuration files
  ├── models/         # Data models
  ├── providers/      # State management
  ├── screens/        # UI screens
  ├── services/       # API and other services
  ├── widgets/        # Reusable widgets
  └── main.dart       # Entry point
```

## Dependencies

- provider: ^6.0.5
- go_router: ^10.0.0
- dio: ^5.3.2
- flutter_dotenv: ^5.1.0
- shared_preferences: ^2.2.0
- flutter_secure_storage: ^8.0.0
- cached_network_image: ^3.2.3
- freezed: ^2.4.5
- json_serializable: ^6.7.1

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
