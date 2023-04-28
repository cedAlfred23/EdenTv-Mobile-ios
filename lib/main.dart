import 'dart:developer';
import 'package:eden/presentation/login/reset_password.dart';
import 'package:eden/presentation/setting/update_user_page.dart';
import 'package:eden/presentation/splash.dart';
import 'package:eden/utils/authentication.dart';
import 'package:eden/presentation/home/home.dart';
import 'package:eden/presentation/setting/politique_confidentialite.dart';
import 'package:eden/presentation/setting/profile_update.dart';
import 'package:eden/presentation/setting/setting.dart';
import 'package:eden/presentation/signup/inscription.dart';
import 'package:eden/presentation/login/login.dart';
import 'package:eden/presentation/signup/inscription_2.dart';
import 'package:eden/utils/constante.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/date_symbol_data_local.dart'; //for date locale
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    playSound: true, importance: Importance.high);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("a bg message ${message.messageId}");
}

final FijkPlayer player = FijkPlayer();
final RadioPlayer radioPlayer = RadioPlayer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('fr_FR', null);
  await Firebase.initializeApp();
  await radioPlayer.setChannel(
      title: "Diaspora FM", url: urlRadio, imagePath: imageBetaFM);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  openDatabase(join(await getDatabasesPath(), "edentv_bdd.db"),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE favoris(id STRING PRIMARY KEY, programme STRING, user STRING)');
  }, version: 3);

  runApp(
    ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        builder: (context, _) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    sharedPrefInit();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification!.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: primaryColors,
                    playSound: true,
                    icon: '@mipmap/ic_laucher')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
 
      }
    });

    return MaterialApp(
      initialRoute: "/",
      home: const Splash(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(350, name: MOBILE),
            ResponsiveBreakpoint.autoScale(600, name: TABLET),
            ResponsiveBreakpoint.resize(800, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ]),
      routes: {
        signUpLink: (context) => const SignUpPage(),
        signUpNextUrl: (context) => const SignUpNextPage(),
        loginUrl: (context) => const LoginPage(),
        resetPwdUrl: (context) => const ResetPasswordPage(),
        homeUrl: (context) => HomePage(
              selectedIndexForBottomNavigation: 0,
              selectedIndexForTabBar: 0,
            ),
        // profilAnimateurUrl: (context) => const AnimateurProfilePage(),
        settingUrl: (context) => const SettingPage(),
        userProfileUrl: (context) => const ProfileUpdatePage(),
        cguUrl: (context) => const PolitiqueConfidentialitePage(),
        updateUserProfileUrl: (context) => const UpdateUserPage(),
      },
    );
  }

  void sharedPrefInit() async {
    try {
      /// Checks if shared preference exist
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.getString("app-name");
    } catch (err) {
      /// setMockInitialValues initiates shared preference
      /// Adds app-name
      // SharedPreferences.setMockInitialValues({});
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("app-name", "my-app");
    }
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedId;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }

      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAdress;
    notifyListeners();
  }

  void verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains("password")) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAdress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
