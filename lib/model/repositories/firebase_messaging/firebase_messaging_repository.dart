import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/repositories/firebase_messaging/topics.dart';

final firebaseMessagingRepositoryProvider =
    Provider<FirebaseMessagingRepository>(
        (ref) => FirebaseMessagingRepository(FirebaseMessaging.instance));

class FirebaseMessagingRepository {
  FirebaseMessagingRepository(this._firebaseMessaging);
  final FirebaseMessaging _firebaseMessaging;

  final _message = PublishSubject<RemoteMessage>();
  final _openedApp = PublishSubject<RemoteMessage>();
  final _token = PublishSubject<String>();
  bool _isFetch = false;

  Stream<RemoteMessage> get message => _message;

  Stream<RemoteMessage> get openedApp => _openedApp;

  Stream<String> get fetchToken => _token;

  Future<String?> get token => _firebaseMessaging.getToken();

  void configureListener() {
    if (_isFetch) {
      return;
    }
    _isFetch = true;
    FirebaseMessaging.onMessage.listen(_message.add);
    FirebaseMessaging.onMessageOpenedApp.listen(_openedApp.add);
    _firebaseMessaging.onTokenRefresh.listen(_token.add);
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission();
    }
  }

  Future<void> subscribeToTopic(Topics topic) =>
      _firebaseMessaging.subscribeToTopic(topic.name);

  Future<void> deleteToken() => _firebaseMessaging.deleteToken();

  Future<void> dispose() async {
    await _message.close();
    await _openedApp.close();
    await _token.close();
  }
}
