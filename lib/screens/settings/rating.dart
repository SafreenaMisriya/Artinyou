// import 'package:flutter/material.dart';
// import 'package:rate_my_app/rate_my_app.dart';

// class AppRating extends StatefulWidget {
//   const AppRating({super.key});

//   @override
//   State<AppRating> createState() => _AppRatingState();
// }

// class _AppRatingState extends State<AppRating> {
//   RateMyApp rateMyApp = RateMyApp(
//     preferencesPrefix: 'rateMyApp_',
//     minDays: 3,
//     minLaunches: 7,
//     remindDays: 2,
//     remindLaunches: 7,
//     // googlePlayIdentifier: 'fr.skyost.example',
//     // appStoreIdentifier: '1491556149',
//   );
//   @override
//   void initState() {
//     rateMyApp.init().then((_) {
//       if (rateMyApp.shouldOpenDialog) {
//         rateMyApp.showStarRateDialog(
//           context,
//           title: 'Rate this app',
//           message: 'Please leave a rating!',
//           actionsBuilder: (context, stars){
//             return[
              
//             ]
//           },
//           dialogStyle: DialogStyle(
//             titleAlign: TextAlign.center,
//             messageAlign: TextAlign.center,
//             messagePadding: EdgeInsets.only(bottom: 20),
//           ),
//           starRatingOptions: StarRatingOptions()
//         );
//       }
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
