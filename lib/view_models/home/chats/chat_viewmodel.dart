import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_clone_mobile/models/chat.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

abstract class ChatViewModel extends BaseViewModel {
  ChatViewModel({
    required DocumentSnapshot<Chat> snapshot,
  }) : _snapshot = snapshot;

  DocumentSnapshot<Chat> _snapshot;

  DocumentSnapshot<Chat> get snapshot => _snapshot;
}
