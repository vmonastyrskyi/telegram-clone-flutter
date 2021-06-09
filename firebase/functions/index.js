const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

exports.chatMessagesCounter = functions.firestore
  .document('/chats/{chatId}/messages/{messageId}')
  .onWrite((change, context) => {
    const chatId = context.params.chatId;

    const chatRef = db.collection('chats').doc(chatId);
    const messagesRef = chatRef.collection('messages');

    return db.runTransaction((transaction) => {
      return transaction.get(messagesRef).then((messagesQuery) => {
        const messagesCount = messagesQuery.size;
        return transaction.update(chatRef, {
          message_counter: messagesCount,
        });
      });
    });
  });

exports.createChatMessagesCounter = functions.firestore
  .document('/chats/{chatId}')
  .onCreate((snapshot, context) => {
    const chatId = context.params.chatId;

    const chatRef = db.collection('chats').doc(chatId);

    return db.runTransaction((transaction) => {
      return transaction.get(chatRef).then((chatSnapshot) => {
        return transaction.update(chatRef, {
          message_counter: 0,
        });
      });
    });
  });
