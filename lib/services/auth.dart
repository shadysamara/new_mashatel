import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/sign_in/models/sp_user.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:mashatel/splach.dart';
import 'package:mashatel/utils/HandleFirebaseErrorMessages.dart';
import 'package:mashatel/utils/custom_dialoug.dart';

class FireMessaging {
  static final firebaseMessaging = FireMessaging._();

  FireMessaging._();

  Future<void> saveDeviceToken(String userId) async {
    // Add logic to save the device token for the user
    print('Device token saved for user: $userId');
  }
}

class Auth {
  Auth._();
  static Auth authInstance = Auth._();
  FirebaseAuth auth = FirebaseAuth.instance;
  final SignInGetx signInGetx = Get.put(SignInGetx());
  final AppGet appGet = Get.put(AppGet());
////////////////////////////////////////////////////////////////////////////////////////
  Future<SpUser?> registerUsingEmailAndPassword(
      {required String email,
      required String password,
      bool isAdmin = false,
      bool isCustomer = false,
      bool isMarket = false}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.uid == null) {
        signInGetx.pr.hide();
        CustomDialougs.utils
            .showDialoug(messageKey: 'Failed', titleKey: 'alert');

        return null;
      }
      FireMessaging.firebaseMessaging.saveDeviceToken(userCredential.user!.uid);
      String userId = userCredential.user!.uid;
      SpUser spUser = await SPHelper.spHelper.setUserCredintials(
          isAdmin: isAdmin,
          isCustomer: isCustomer,
          isMarket: isMarket,
          userId: userId);
      return spUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        signInGetx.pr.hide();
        CustomDialougs.utils
            .showDialoug(messageKey: 'week_password', titleKey: 'alert');
      } else {
        signInGetx.pr.hide();
        throw ('used_email');
      }
    } catch (e) {
      print(e.toString());
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////
  Future<SpUser?> signInWithEmailAndPassword(
      {required String email,
      required String password,
      bool isAdmin = false,
      bool isCustomer = false,
      bool isMarket = false}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.uid == null) {
        signInGetx.pr.hide();
        CustomDialougs.utils
            .showDialoug(messageKey: 'Failed', titleKey: 'alert');

        return null;
      }
      FireMessaging.firebaseMessaging.saveDeviceToken(userCredential.user!.uid);

      String userId = userCredential.user!.uid;
      SpUser spUser = await SPHelper.spHelper.setUserCredintials(
          isAdmin: isAdmin,
          isCustomer: isCustomer,
          isMarket: isMarket,
          userId: userId);
      return spUser;
    } on FirebaseAuthException catch (e) {
      signInGetx.pr.hide();
      if (e.code == 'user-not-found') {
        CustomDialougs.utils
            .showDialoug(messageKey: 'invalid_email', titleKey: 'alert');
      } else if (e.code == 'wrong-password') {
        CustomDialougs.utils
            .showDialoug(messageKey: 'invalid_password', titleKey: 'alert');
      }
    } catch (e) {
      HandleFirebaseErrorMessages.showErrorMessage(e);
    }
  }

////////////////////////////////////////////////////////////////////////
  signOut() async {
    await FirebaseAuth.instance.signOut();
    SPHelper.spHelper.clearUserCredintials();
    signInGetx.clearUserType();
    appGet.clearVariables();
    Get.off(SplashScreen());
  }
}
