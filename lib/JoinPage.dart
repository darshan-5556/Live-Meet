import 'package:livemeet/AgoraIntegration/src/pages/call.dart';
import 'package:livemeet/Backend.dart';
import 'package:livemeet/Login.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  String channelId;
  Random _rnd = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeCode();
    setCode();
  }

  changeCode() async {
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    channelId = getRandomString(8);
  }

  setCode() {
    usersRefrance.document(currentUser.id).updateData({"channelId": channelId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: Center(
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.yellow, Colors.red])),
              width: 220.0,
              height: 110.0,
              alignment: Alignment.center,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0)),
                color: Colors.green,
                icon: Icon(
                  Icons.record_voice_over,
                  color: Colors.white,
                ),
                splashColor: Colors.red,
                onPressed: () async {
                  ///Perform backend here////
                  await _handleCameraAndMic();

                  await BackendCode.generateString();
                  await BackendCode.getUsers(context);
                  // await BackendCode.getCurrentUser();
                  // await pushUser();
                },
                label: Text(
                  "Join",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // pushUser() {
  //   usersRefrance.document(currentUser.id).get().then((doc) {
  //     if (doc.exists) {
  //       channelId = doc.data['channelId'];
  //     }
  //   });

  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => CallPage(
  //               channelName: channelId, role: ClientRole.Broadcaster)));
  // }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
