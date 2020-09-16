import 'dart:math';

import 'package:livemeet/AgoraIntegration/src/pages/call.dart';
import 'package:livemeet/Login.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class BackendCode {
  static String receiverId;
  static String channelIdString;
  static Random _rnd = Random();
  static String stringId;
  static String channelId;

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static Future<void> generateString() {
    channelIdString = getRandomString(8);
    print(channelIdString);
  }

  static Future<void> getUsers(context) => usersRefrance
          .where("Gender", isGreaterThanOrEqualTo: "Female")
          .where("isRequestToJoin", isEqualTo: true)
          // .where("id", isLessThan: currentUser.id)
          .getDocuments()
          .then((doc) {
        stringId = doc.documents.first.data['channelId'];
        print(stringId + " id");
        if (doc.documents.isEmpty) {
          print("ok");
        } else {
          usersRefrance.document(currentUser.id).updateData({
            "channelId": stringId,
            "isRequestToJoin": true,
          });
          usersRefrance.document(currentUser.id).get().then((doc) {
            if (doc.exists) {
              channelId = doc.data['channelId'];
            }
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CallPage(
                      channelName: channelId, role: ClientRole.Broadcaster)));
        }
      }).catchError((e) {
        usersRefrance.document(currentUser.id).updateData({
          "isRequestToJoin": true,
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CallPage(
                    channelName: currentUser.channelId,
                    role: ClientRole.Broadcaster)));
      //  interstatialAds.createADinterstatial();
      });

  // static Future<void> getCurrentUser() =>
  //     usersRefrance.document(currentUser.id).updateData({
  //       "channelId": stringId,
  //       "isRequestToJoin": true,
  //     });
}
