import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/provider/earning_provider.dart';
import 'package:investorapp/view/bottom_bar_screens/bottom_bar.dart';
import 'package:investorapp/view/login_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// THIS IS CRUCIAL: Background message handler must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  // IMPORTANT: Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  requestPermission(); // Ask for notification permissions
  setupFCM(); // Set up Firebase Cloud Messaging listeners
  runApp(const MyApp());
}

/// Request notification permissions
void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false);

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  } else {}
}

void setupFCM() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {}
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleNotificationTap(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      handleNotificationTap(message);
    }
  });

  FirebaseMessaging.instance.getToken().then((token) {});

  // Listen for token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((token) {
    // Send the new token to your server
  });
}

void handleNotificationTap(RemoteMessage message) {
  if (message.data['screen'] == 'earnings') {
    Get.to(() => const BottomBar());
  } else if (message.data['screen'] == 'profile') {
    Get.to(() => const BottomBar());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EarningProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animationController.forward();
    checkLogin();
  }

  Future<void> checkLogin() async {
    const storage = FlutterSecureStorage();
    DateTime startTime = DateTime.now();
    try {
      final token = await storage.read(key: 'auth_token');
      if (token != null) {
        _navigateWithMinDelay(startTime, () {
          Get.offAll(() => const BottomBar(),
              transition: Transition.downToUp,
              duration: const Duration(milliseconds: 500));
        });
      } else {
        _navigateWithMinDelay(startTime, () {
          Get.offAll(() => const LoginPage(),
              transition: Transition.downToUp,
              duration: const Duration(milliseconds: 500));
        });
      }
    } catch (e) {
      await storage.delete(key: 'auth_token');
      _navigateWithMinDelay(startTime, () {
        Get.offAll(() => const LoginPage(),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 500));
      });
    }
  }

  void _navigateWithMinDelay(DateTime startTime, VoidCallback navigate) {
    Duration elapsedTime = DateTime.now().difference(startTime);
    int remainingTime = 3000 - elapsedTime.inMilliseconds;

    if (remainingTime > 0) {
      Future.delayed(Duration(milliseconds: remainingTime), navigate);
    } else {
      navigate();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(toolbarHeight: 0, backgroundColor: const Color(0xFFFFA50F)),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Center(
                    child:
                        Image.asset('assets/loader.png', fit: BoxFit.cover)))));
  }
}
