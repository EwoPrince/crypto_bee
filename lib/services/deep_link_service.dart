// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class DeepLinkService {
//   DeepLinkService._();
//   static DeepLinkService? _instance;

//   static DeepLinkService? get instance {
//     if (_instance == null) {
//       _instance = DeepLinkService._();
//     }
//     return _instance;
//   }

//   String? referrerCode;

//   final dynamicLink = FirebaseDynamicLinks.instance;

//   Future<void> handleDynamicLinks() async {
//     //Get initial dynamic link if app is started using the link
//     final data = await dynamicLink.getInitialLink();
//     if (data != null) {
//       _handleDeepLink(data);
//     }
//     //handle foreground
//     dynamicLink.onLink;
//   }

//   Future<String> createReferLink(String referCode) async {
//     final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
//       uriPrefix: 'https://ewoindustry.page.link/cryptobeeshare',
//       link: Uri.parse('https://cryptobee.page.link/cryptobeeshare.refer?code=$referCode'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.ewoindustry.cryptobee',
//       ),
//       socialMetaTagParameters: SocialMetaTagParameters(
//         title: 'REFER A FRIEND & EARN',
//         description: 'Earn 100 Gold fish on every referral',
//         imageUrl: Uri.parse('https://drive.google.com/file/d/1HBo853GBe8Li77XRrF-hw8_u8Rwoql69/view?usp=drivesdk'),
//       ),
//     );

//     //final ShortDynamicLink shortLink = await dynamicLink.buildShortLink(dynamicLinkParameters);

//     var shortLink = await dynamicLink.buildShortLink(dynamicLinkParameters);
//     //var shortUrl = shortLink.shortUrl;

//     //final ShortDynamicLink shortLink = (await dynamicLinkParameters.link) as ShortDynamicLink;
//     //final Uri dynamicUrl = shortLink.shortUrl;

//     return shortLink.toString();
//   }

//   Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
//     final Uri deepLink = data.link;
//     var isRefer = deepLink.pathSegments.contains('refer');
//     if (isRefer) {
//       var code = deepLink.queryParameters['code'];
//       if (code != null) {
//         referrerCode = code;
//         print('ReferrerCode $referrerCode');
//       }
//     }
//   }
// }
