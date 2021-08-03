import 'package:cloud_functions/cloud_functions.dart';

Future<void> sendNotification() async {
  HttpsCallable call =
      FirebaseFunctions.instance.httpsCallable('sendNotification');
  final results = await call();
  print(results);
}
