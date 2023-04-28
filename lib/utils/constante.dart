// import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

const bool isBeta = false;
//constante code
const telKey = "tel";
const isPwdSaved = "isPwdSaved";
const pwdKey = "pwdSaved";
const emailKey = "emailSaved";
const signUpModeKey = "signup_mode";
const signUpEmailPwdVal = "email_pwd_signup";
const signUpGoogle = "google_signup";
const signUpFacebook = "facebook_signup";
const signUpApple = "apple_signup";
const nomKey = "nomSaved";
const prenomKey = "prenomSved";
const pseudoKey = "pseudoSaved";
const photoKey = "photoSaved";
const uidKey = "uidSaved";
const idKey = "idKey";
const firestoreDocId = "user_doc_id";
const userCollection = "usersCollection";
const userToken = "userToken";
const userConnectKey = "userConnect";
//urlRadio
const String urlRadio = "https://radio.edentv.bj/stream";
const String urlRadioFM =
    "https://audio.bfmtv.com/bfmbusiness_128.mp3?aw_0_1st.aggredator=radio_fr";
const String urlRTMPtv =
    "http:rtmp.edentv.bj:8080/hls/stream.m3u8"; //"rtmp://74.207.242.11/radio-live/test";
// final FijkPlayer player = FijkPlayer();

const String urlYoutubeEden = "https://www.youtube.com/c/BeninEdenTv";
const String urlYoutubeDiaspora =
    "https://www.youtube.com/channel/UCH817QGoaMfTSqtbytCX0_w";

const String urlTwitterEden = "https://twitter.com/BeninEdenTV";
const String urlTwitterDiaspora = "https://twitter.com/beninradiodiasp";

const String urlFacebookEden = "https://www.facebook.com/BeninEdenTV/";
const String urlFacebookDiaspora =
    "https://www.facebook.com/beninradiodiaspora";

const String urlCGU = "https://benin-eden.tv/cgu/";
//API URL
const String baseApiUrl = "https://api.edentv.bj/api/v1";
// const String baseApiUrl = "http://edentvapi.herokuapp.com/api/v1";
String apiUsername = "admin@admin.com";
String apiPwd = "admin";

const String getServiceUrl = "/service/";
const String postCreateLoginSocialUrl = "/user/loginSocial";
const String putAccountUrl = "/account";
const String getLoginSocialUrl = "/user/loginSocial";
const String getAnimateursUrl = "/animateur/";
const String getEspacePubUrl = "/espacePublicitaire/";
const String postContact = "/contact/";
const String programmeUrl = "/programme/";
const String favorisUrl = "/favoris/";
const String subProgrammeUrl = "/subProgramme/";
const String newsListUrl = "/news/";

//=======design constante
//image constante
const String logoFacebook = "assets/images/Facebook.png";
const String logoAppel = "assets/images/apel.png";
const String logoGooglePlus = "assets/images/googlePlus.png";
const String editIcon = "assets/images/edit-regular.png";
const String avataImg = "assets/images/avatar.png";
const String cameraIcon = "assets/images/camera.png";
const String contactIcon = 'assets/images/contact.png';
const String alauneIcon = 'assets/images/alaune.png';
const String homeIcon = 'assets/images/home.png';
const String programeIcon = 'assets/images/programme.png';
const String imageBetaFM = 'assets/images/image-fm.jpg';
const String imagePlayBtn = 'assets/images/play-btn-icon.png';
const String imagePauseBtn = 'assets/images/pause-btn-icon.png';
const String imageRetryBtn = 'assets/images/retry-btn-icon.png';
const String imageLove = 'assets/images/love.png';
const String imageUnLove = 'assets/images/unlove.png';
const String imagePlay = 'assets/images/clarity_play-solid.png';
const String imageStop = 'assets/images/carbon_stop-filled-alt.png';
const String imagePause = 'assets/images/carbon_pause-filled.png';
const String imageDefaultRadio = 'assets/images/default_radio.png';
const String imageErrorLive = "assets/images/error_live.png";
const String imagePodcast = "assets/images/podcast.png";
const String imagetempo = "assets/images/tempo.png";

const String whatsappImage = 'assets/images/whatsapp-symbol-logo.png';
const String youtubeImage = 'assets/images/youtube.png';
const String facebookImage = 'assets/images/facebook-3-logo.png';
const String twitterImage = 'assets/images/twitter-3-logo.png';

const String alertDialogError = "error";
const String alertDialogWarning = "warning";
const String alertDialogSuccess = "success";
const String alertDialogInfo = "info";
const String alertTitleError = "Erreur";
const String alertTitleWarning = "Attention";
const String alertTitleInfo = "Info";
const String alertTitleSuccess = "Succès";
//Link value
const String signUpLink = '/signup';
const String signUpNextUrl = '/signup_next';
const String loginUrl = '/login';
const String resetPwdUrl = '/reset_pwd';
const String homeUrl = '/home';
const String profilAnimateurUrl = '/home/profil_animateur';
const String settingUrl = '/setting';
const String userProfileUrl = '/setting/profile';
const String cguUrl = '/setting/cgu';
const String updateUserProfileUrl = '/setting/update_profile';
//primary color
const primaryColors = Color.fromRGBO(42, 82, 190, 1);
const primaryColorsMinus = Color.fromRGBO(42, 82, 190, 0.3);

const notDataTextStyle = TextStyle(fontFamily: fontFamilly, fontSize: 14.0);

//secondary color
const secondaryColor = Color.fromRGBO(140, 200, 255, 1);
//diaspora menu color
const menuIconBgColor = Color.fromRGBO(252, 250, 254, 1);
//email envelop color
const iconColor = Color.fromRGBO(75, 75, 75, 1);
//serviceBorderolor
const serviceBorderColor = Color.fromRGBO(196, 196, 196, 1);
//menu deco
const inActiveMenuItem = BoxDecoration(
  color: Color.fromRGBO(247, 247, 247, 1),
  borderRadius: BorderRadius.all(Radius.circular(100.0)),
);
const activeMenuItem = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(100.0)),
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromRGBO(42, 82, 190, 1),
          Color.fromRGBO(112, 200, 255, 1)
        ]));

//font using
const String fontFamilly = "Montserrat";

//style des texte coloré en bleu
const coloredText = TextStyle(
    color: primaryColors,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilly);

//title textStyle
const titleTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 27,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilly);

const politiqueConfidentialiteTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilly);

const styleSmallText = TextStyle(
    color: Colors.black,
    fontSize: 13,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamilly);

const normalTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 15,
  fontFamily: fontFamilly,
);

const linkTextStyle =
    TextStyle(color: primaryColors, fontSize: 14, fontFamily: fontFamilly);

const fakeTabItemStyle = TextStyle(
  color: Colors.black,
  fontSize: 15,
  fontWeight: FontWeight.w600,
  fontFamily: fontFamilly,
);
const decorationActiveTab = BoxDecoration(
    border: Border(
        bottom: BorderSide(
  color: primaryColors,
  width: 4.0,
)));

const valueRadioTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 14,
  fontWeight: FontWeight.normal,
  fontFamily: fontFamilly,
);

const valueTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
    fontFamily: fontFamilly);

const settingStyle = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: fontFamilly,
    fontWeight: FontWeight.w500);

const infoPersoStyle = TextStyle(
    color: Colors.black,
    fontSize: 21,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilly);
const serviceTitleStyle = TextStyle(
    color: Colors.black,
    fontFamily: fontFamilly,
    fontSize: 12,
    fontWeight: FontWeight.w600);
const serviceDescStyle = TextStyle(
    fontFamily: fontFamilly,
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: Color.fromRGBO(110, 110, 110, 1));
const discuterStyle = TextStyle(
    fontFamily: fontFamilly,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(130, 130, 130, 1));
const typeRadioStyle = TextStyle(
    fontFamily: fontFamilly,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(130, 130, 130, 1));
const dayDesignDefault = TextStyle(
    fontFamily: fontFamilly,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black);

const dayDesignSelected = TextStyle(
    fontFamily: fontFamilly,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white);

const animateurDesign = TextStyle(
    fontFamily: fontFamilly,
    color: primaryColors,
    fontSize: 15,
    fontWeight: FontWeight.w500);
const alaunetitleDesign = TextStyle(
    fontFamily: fontFamilly,
    color: primaryColors,
    fontSize: 13,
    fontWeight: FontWeight.w500);
const descStyle = TextStyle(
    fontFamily: fontFamilly,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(130, 130, 130, 1));
