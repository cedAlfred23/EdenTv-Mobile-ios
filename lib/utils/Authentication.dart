import 'dart:developer';
import 'dart:io';

import 'package:eden/domaine/user.dart';
import 'package:eden/infrastructure/v1/account.dart';

import 'package:eden/presentation/home/home.dart';
import 'package:eden/utils/constante.dart';
import 'package:eden/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as applsign;

enum ApplicationLoginState {
  loggedOut,
  emailAdress,
  register,
  password,
  loggedId,
}

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Authentication();
  Helpers helpers = Helpers();
  Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((valu) => log("user created"));
  }

  Future<void> signInUserWithEmailAndPasswordP(
      String email, String password, UserCredential value) async {
    var res = value.user;

    CurrentUser currentUser, cUser;
    cUser = await getConnectedUser(res!.uid);
    // bool forSave = false;
    currentUser = CurrentUser(
        id: "",
        uid: res.uid,
        firstName: res.displayName,
        lastName: res.displayName,
        countryCode: res.displayName,
        country: res.displayName,
        providerId: res.uid,
        displayName: res.displayName,
        notifyOnProgram: cUser.notifyOnProgram,
        // pseudo: pseudo,
        numero: cUser.numero,
        email: email,
        photoURL: cUser.photoURL,
        fromFacebook: cUser.fromFacebook,
        fromGoogle: cUser.fromGoogle,
        fromApple: cUser.fromApple,
        forSave: cUser.forSave,
        token: cUser.token);

    await helpers.putString(prenomKey, cUser.lastName);
    await helpers.putString(nomKey, cUser.firstName);
    await helpers.putString(telKey, cUser.numero);
    await helpers.putString(userToken, cUser.token);

    cUser = await createUser(currentUser);
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      if (await setDeviceFcm(token)) {
        log("true");
      } else {
        log("false");
      }
    }

    log("userToken from ${await helpers.getString(userToken)}");

    log("cUser: $cUser");
  }

  Future<User?> getIsUserOnline() async {
    User? user = auth.currentUser;
    return user;
  }

  // Future<CurrentUser> getCurrentUser() async {
  //   User? user = auth.currentUser;
  //   CurrentUser utilisateur = CurrentUser(
  //       displayName: "", pseudo: "", numero: "", email: "", photoURL: "");
  //   if (user != null) {
  //     utilisateur = CurrentUser(
  //         displayName: user.displayName,
  //         pseudo: "",
  //         numero: "",
  //         email: user.email,
  //         photoURL: user.photoURL);
  //     return utilisateur;
  //   } else {
  //     return utilisateur;
  //   }
  // }

  void signOut(context) async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.signOut().whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            selectedIndexForBottomNavigation: 0,
            selectedIndexForTabBar: 0,
          ),
        ),
      );
    });

    helpers.putString(idKey, "");
    helpers.putString(userToken, "");
    helpers.putString(telKey, "");
    helpers.putString(nomKey, "");
  }

  Future<bool> signUpUserOnFireStore(
      bool isUpdate,
      String displayName,
      String firstName,
      String lastName,
      String numero,
      XFile photoURL,
      String countryCode,
      String country,
      bool forSave) async {
    await Firebase.initializeApp();
    User? user = auth.currentUser;
    Directory directory;
    if (user != null) {
      log("user : $user");
      bool fromFacebook = false;
      bool fromGoogle = false;
      bool fromApple = false;
      helpers.getString(signUpModeKey).then((value) {
        if (value == signUpEmailPwdVal) {
          user.sendEmailVerification();
        } else if (value == signUpApple) {
          fromApple = true;
        } else if (value == signUpFacebook) {
          fromFacebook = true;
        } else if (value == signUpGoogle) {
          fromGoogle = true;
        }
      });
      user.updateDisplayName(displayName);

      helpers.saveImage(photoURL.path, photoURL.name);
      if (Platform.isAndroid) {
        directory = await helpers.getExternalStorageDirectory();
        String newPath = "";
        log("directory: $directory");
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        directory = Directory(newPath);
        user.updatePhotoURL(directory.path + "/profile_photo.jpg");
        // print(directory.path + "/" + photoURL.name);
        // this
        //     .firebaseFirestore
        //     .collection("usersCollection")
        //     .add({"uid": user.uid, "numero": numero, "pseudo": pseudo}).then(
        //         (value) => {
        //               if (value != null)
        //                 {helpers.putString(firestoreDocId, value.id)}
        //             });

        CurrentUser currentUser;
        // bool forSave = false;
        currentUser = CurrentUser(
            id: "",
            uid: user.uid,
            firstName: firstName,
            lastName: lastName,
            countryCode: countryCode,
            country: country,
            providerId: user.uid,
            displayName: displayName,
            notifyOnProgram: false,
            // pseudo: pseudo,
            numero: numero,
            email: user.email,
            photoURL: directory.path + "/profile_photo.jpg",
            fromFacebook: fromFacebook,
            fromGoogle: fromGoogle,
            fromApple: fromApple,
            forSave: forSave,
            token: "");
        log("isUpdate: $isUpdate");
        log("num valu = $numero");
        log("user id ${await helpers.getString(idKey)}");
        !isUpdate
            ? await createUser(currentUser)
            : await updateUser(
                currentUser, await helpers.getString(idKey) ?? "", user);

        await helpers.putString(telKey, numero);
        await helpers.putString(nomKey, firstName);
        await helpers.putString(prenomKey, lastName);

        return true;
        // helpers.putString(idKey, cUser.id);
        // u.then((value) => {helpers.putString(userToken, value.token)});

        // helpers.getString(userToken).then((value) => {print(value)});
      } else {
        if (await helpers.requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
          File saveFile = File(directory.path + "/" + photoURL.name);
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);

          CurrentUser currentUser = await getConnectedUser(user.uid);
          // bool forSave = false;
          currentUser = CurrentUser(
              id: "",
              uid: user.uid,
              firstName: firstName,
              lastName: lastName,
              countryCode: countryCode,
              country: country,
              providerId: user.uid,
              displayName: displayName,
              notifyOnProgram: false,
              // pseudo: pseudo,
              numero: numero,
              email: user.email,
              photoURL: directory.path + "/" + photoURL.name,
              fromFacebook: fromFacebook,
              fromGoogle: fromGoogle,
              fromApple: fromApple,
              forSave: forSave,
              token: "");

          !isUpdate
              ? createUser(currentUser)
              : updateUser(
                  currentUser, await helpers.getString(idKey) ?? "", user);

          await helpers.putString(telKey, numero);
          await helpers.putString(nomKey, firstName);
          await helpers.putString(prenomKey, lastName);
          return true;
          // apiAccount
          //     .createUser(currentUser)
          //     .then((value) => {helpers.putString(userToken, value.token)});

          // this.firebaseFirestore.collection("usersCollection").add({
          //   "uid": user.uid,
          //   "numero": numero,
          //   "pseudo": pseudo
          // }).then((value) => {
          //       if (value != null)
          //         {helpers.putString(firestoreDocId, value.id)}
          //     });

        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<UserCredential?> signInWithApple(
      {List<applsign.Scope> scopes = const []}) async {
    log("called");
    final result = await applsign.TheAppleSignIn.performRequests(
        [applsign.AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case applsign.AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(applsign.Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        CurrentUser currentUser =
            await getConnectedUser(userCredential.user!.uid);
        // bool forSave = false;
        currentUser = CurrentUser(
            id: "",
            uid: userCredential.user!.uid,
            firstName: userCredential.user!.displayName,
            lastName: userCredential.user!.displayName,
            countryCode: userCredential.user!.displayName,
            country: userCredential.user!.displayName,
            providerId: userCredential.user!.uid,
            displayName: userCredential.user!.displayName,
            notifyOnProgram: false,
            // pseudo: pseudo,
            numero: currentUser.numero,
            email: userCredential.user!.email,
            photoURL: currentUser.photoURL,
            fromFacebook: currentUser.fromFacebook,
            fromGoogle: currentUser.fromGoogle,
            fromApple: currentUser.fromApple,
            forSave: currentUser.forSave,
            token: currentUser.token);

        await helpers.putString(prenomKey, currentUser.lastName);
        await helpers.putString(nomKey, currentUser.firstName);
        await helpers.putString(telKey, currentUser.numero);
        await helpers.putString(userToken, currentUser.token);

        await createUser(currentUser);
        String? token = await FirebaseMessaging.instance.getToken();

        if (token != null) {
          if (await setDeviceFcm(token)) {
          } else {}
        }
        return userCredential;
      case applsign.AuthorizationStatus.error:
      // throw PlatformException(
      //   code: 'ERROR_AUTHORIZATION_DENIED',
      //   message: result.error.toString(),
      // );

      case applsign.AuthorizationStatus.cancelled:
        // throw PlatformException(
        //   code: 'ERROR_ABORTED_BY_USER',
        //   message: 'Sign in aborted by user',
        // );
        return null;
      default:
        return null;
    }
  }

  Future<UserCredential> signInWithGoogle(bool connexion) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    helpers.putString(signUpModeKey, signUpGoogle);
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var userCred = await FirebaseAuth.instance.signInWithCredential(credential);

    if (connexion == true) {
      CurrentUser c = await getConnectedUser(userCred.user!.uid);
      CurrentUser currentUser;
      // bool forSave = false;
      currentUser = CurrentUser(
          id: "",
          uid: userCred.user!.uid,
          firstName: c.firstName,
          lastName: c.lastName,
          countryCode: userCred.user!.displayName,
          country: userCred.user!.displayName,
          providerId: userCred.user!.uid,
          displayName: userCred.user!.displayName,
          notifyOnProgram: false,
          // pseudo: pseudo,
          numero: c.numero,
          email: userCred.user!.email,
          photoURL: c.photoURL,
          fromFacebook: c.fromFacebook,
          fromGoogle: c.fromGoogle,
          fromApple: c.fromApple,
          forSave: c.forSave,
          token: c.token);

      await helpers.putString(prenomKey, c.lastName);
      await helpers.putString(nomKey, c.firstName);
      await helpers.putString(telKey, c.numero);
      await helpers.putString(userToken, c.token);

      await createUser(currentUser);

      String? token = await FirebaseMessaging.instance.getToken();
      log("userToken from ${await helpers.getString(userToken)}");

      if (token != null) {
        if (await setDeviceFcm(token)) {
          log("true");
        } else {
          log("false");
        }
      }
    }

    return userCred;
  }

  Future<void> sendResetPassword(String email) async {
    auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithFacebook(bool connexion) async {
    var userCred;
   try{
     // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    log("face $loginResult");
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    log("facebook 1 : $facebookAuthCredential");
    helpers.putString(signUpModeKey, signUpFacebook);
    // Once signed in, return the UserCredential
    var userCred = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    log("facebook 1 : $userCred");
    if (connexion == true) {
      CurrentUser currentUser = await getConnectedUser(userCred.user!.uid);
      // bool forSave = false;
      currentUser = CurrentUser(
          id: "",
          uid: userCred.user!.uid,
          firstName: userCred.user!.displayName,
          lastName: userCred.user!.displayName,
          countryCode: userCred.user!.displayName,
          country: userCred.user!.displayName,
          providerId: userCred.user!.uid,
          displayName: userCred.user!.displayName,
          notifyOnProgram: false,
          // pseudo: pseudo,
          numero: currentUser.numero,
          email: userCred.user!.email,
          photoURL: currentUser.photoURL,
          fromFacebook: currentUser.fromFacebook,
          fromGoogle: currentUser.fromGoogle,
          fromApple: currentUser.fromApple,
          forSave: currentUser.forSave,
          token: currentUser.token);

      await helpers.putString(prenomKey, currentUser.lastName);
      await helpers.putString(nomKey, currentUser.firstName);
      await helpers.putString(telKey, currentUser.numero);
      await helpers.putString(userToken, currentUser.token);

      await createUser(currentUser);
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        if (await setDeviceFcm(token)) {
        } else {}
      }
    }
   }catch(e){}
    return userCred;
  }

  Future<void> addToNews(bool addToNews) async {
    CurrentUser cUser =
        await getConnectedUser(await helpers.getString(uidKey) ?? "");
    cUser.notifyOnProgram = addToNews;
    cUser = await updateUser(cUser, cUser.id ?? "", null);
    log("updateUser: $cUser");
  }

  Future<bool> deleteUser(String? userId) async {
    User? user = auth.currentUser;
    if (user != null) {
      await user.delete();
      bool res = await deleteUserAccount(userId);
      return res;
    } else {
      return false;
    }
  }
}
