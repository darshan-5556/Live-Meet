import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String url;
  final String email;
  final int state;
  bool isRequestToJoin;
  final String channelId;

  User({
    this.id,
    this.profileName,
    this.url,
    this.email,
    this.state,
    this.isRequestToJoin,
    this.channelId,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc.documentID,
        email: doc['email'],
        url: doc['url'],
        profileName: doc['profileName'],
        state: doc['state'],
        isRequestToJoin: doc['isRequestToJoin'],
        channelId: doc['channelId']);
  }
}
