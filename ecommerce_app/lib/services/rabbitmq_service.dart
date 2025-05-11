// import 'package:amqp/amqp.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';
//
// class RabbitMQService {
//   late Client _client;
//   late Channel _channel;
//   bool _isConnected = false;
//
//   // Singleton pattern
//   static final RabbitMQService _instance = RabbitMQService._internal();
//   factory RabbitMQService() => _instance;
//   RabbitMQService._internal();
//
//   // Connection settings
//   final String _host = dotenv.env['RABBITMQ_HOST'] ?? 'localhost';
//   final int _port = int.parse(dotenv.env['RABBITMQ_PORT'] ?? '5672');
//   final String _username = dotenv.env['RABBITMQ_USERNAME'] ?? 'guest';
//   final String _password = dotenv.env['RABBITMQ_PASSWORD'] ?? 'guest';
//   final String _vhost = dotenv.env['RABBITMQ_VHOST'] ?? '/';
//
//   // Queue names
//   static const String orderQueue = 'order_queue';
//   static const String notificationQueue = 'notification_queue';
//   static const String orderExchange = 'order_exchange';
//   static const String notificationExchange = 'notification_exchange';
//
//   Future<void> connect() async {
//     if (_isConnected) return;
//
//     try {
//       final settings = ConnectionSettings(
//         host: _host,
//         port: _port,
//         username: _username,
//         password: _password,
//         vhost: _vhost,
//       );
//
//       _client = Client(settings: settings);
//       await _client.connect();
//       _channel = await _client.channel();
//
//       // Declare exchanges
//       await _channel.exchangeDeclare(
//         orderExchange,
//         ExchangeType.direct,
//         durable: true,
//       );
//       await _channel.exchangeDeclare(
//         notificationExchange,
//         ExchangeType.fanout,
//         durable: true,
//       );
//
//       // Declare queues
//       await _channel.queueDeclare(orderQueue, durable: true);
//       await _channel.queueDeclare(notificationQueue, durable: true);
//
//       // Bind queues to exchanges
//       await _channel.queueBind(orderQueue, orderExchange, 'order');
//       await _channel.queueBind(notificationQueue, notificationExchange, '');
//
//       _isConnected = true;
//       print('Connected to RabbitMQ');
//     } catch (e) {
//       print('Failed to connect to RabbitMQ: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> disconnect() async {
//     if (!_isConnected) return;
//
//     try {
//       await _channel.close();
//       await _client.close();
//       _isConnected = false;
//       print('Disconnected from RabbitMQ');
//     } catch (e) {
//       print('Error disconnecting from RabbitMQ: $e');
//       rethrow;
//     }
//   }
//
//   // Publish a message to the order queue
//   Future<void> publishOrder(Map<String, dynamic> orderData) async {
//     if (!_isConnected) await connect();
//
//     try {
//       final message = jsonEncode(orderData);
//       await _channel.basicPublish(
//         message,
//         orderExchange,
//         'order',
//         properties: MessageProperties(
//           contentType: 'application/json',
//           deliveryMode: DeliveryMode.persistent,
//         ),
//       );
//       print('Order published: $message');
//     } catch (e) {
//       print('Error publishing order: $e');
//       rethrow;
//     }
//   }
//
//   // Publish a notification
//   Future<void> publishNotification(Map<String, dynamic> notification) async {
//     if (!_isConnected) await connect();
//
//     try {
//       final message = jsonEncode(notification);
//       await _channel.basicPublish(
//         message,
//         notificationExchange,
//         '',
//         properties: MessageProperties(
//           contentType: 'application/json',
//           deliveryMode: DeliveryMode.persistent,
//         ),
//       );
//       print('Notification published: $message');
//     } catch (e) {
//       print('Error publishing notification: $e');
//       rethrow;
//     }
//   }
//
//   // Subscribe to order queue
//   Stream<Map<String, dynamic>> subscribeToOrders() async* {
//     if (!_isConnected) await connect();
//
//     try {
//       final consumer = await _channel.basicConsume(
//         orderQueue,
//         consumerTag: 'order_consumer',
//         noAck: false,
//       );
//
//       await for (final message in consumer) {
//         try {
//           final data = jsonDecode(message.payload) as Map<String, dynamic>;
//           yield data;
//           await _channel.basicAck(message.deliveryTag);
//         } catch (e) {
//           print('Error processing order message: $e');
//           await _channel.basicReject(message.deliveryTag, requeue: true);
//         }
//       }
//     } catch (e) {
//       print('Error subscribing to orders: $e');
//       rethrow;
//     }
//   }
//
//   // Subscribe to notifications
//   Stream<Map<String, dynamic>> subscribeToNotifications() async* {
//     if (!_isConnected) await connect();
//
//     try {
//       final consumer = await _channel.basicConsume(
//         notificationQueue,
//         consumerTag: 'notification_consumer',
//         noAck: false,
//       );
//
//       await for (final message in consumer) {
//         try {
//           final data = jsonDecode(message.payload) as Map<String, dynamic>;
//           yield data;
//           await _channel.basicAck(message.deliveryTag);
//         } catch (e) {
//           print('Error processing notification message: $e');
//           await _channel.basicReject(message.deliveryTag, requeue: true);
//         }
//       }
//     } catch (e) {
//       print('Error subscribing to notifications: $e');
//       rethrow;
//     }
//   }
// }
