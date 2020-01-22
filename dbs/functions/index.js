// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// admin.initializeApp(functions.config().firebase);

// exports.sendNotification = functions.firestore
//   .document("Sellers/{uid}/oders/{oders}")
//   .onCreate(snap, async context => {
//     const uid = context.auth.uid;
//     // const authVar = context.auth;
//     // console.log(userId);
//     console.log(uid);
//     return admin
//       .firestore()
//       .collection("Sellers")
//       .doc(uid)
//       .get()
//       .then(async queryResult => {
//         const senderUserEmail = queryResult.data().senderUserEmail;
//         const notificationMessage = queryResult.data().notificationMessage;
//         const fromUser = admin
//           .firestore()
//           .collection("Sellers")
//           .doc(senderUserEmail)
//           .get();
//         const toUser = admin
//           .firestore()
//           .collection("Sellers")
//           .doc(userEmail)
//           .get();
//         // console.log(userId);
//         return Promise.all([fromUser, toUser]).then(async result => {
//           const fromUserName = result[0].data().name;
//           //   const toUserName = result[1].data().name;
//           const tokenId = result[1].data().userToken;
//           console.log(fromUserName);
//           console.log(toUserName);
//           console.log(tokenId);
//           const notificationContent = {
//             notification: {
//               title: fromUserName + " is shopping",
//               body: notificationMessage,
//               icon: "default"
//             }
//           };

//           return admin
//             .messaging()
//             .sendToDevice(tokenId, notificationContent)
//             .then(result => {
//               console.log("Notification sent!");
//               //admin.firestore().collection("notifications").doc(userEmail).collection("userNotifications").doc(notificationId).delete();
//             });
//         });
//       });
//   });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.OderNotifications = functions.firestore
  .document("Sellers/{uid}/oders/{oders}")
  .onCreate(async (docSnapshot, context) => {
    const oders = docSnapshot.data();
    const uid = oders["id"];
    const user = oders["user"];
    const oderTitle = oders["title"];
    // const senderName = oders["senderName"];

    const userDoc = await admin
      .firestore()
      .doc("Sellers/" + uid)
      .get();
    const registrationTokens = userDoc.get("userToken");
    console.log(registrationTokens);
    // const notificationBody =
    //   message["type"] === "TEXT"
    //     ? message["text"]
    //     : "You received a new image message.";
    const payload = {
      notification: {
        title: user + " Buyed Your Product!",
        body: oderTitle,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        sound: "default"
      },
      data: {
        title: user + " Buyed Your Product!",
        body: oderTitle,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        sound: "default",
        status: "done",
        screen: "OderPage"
      }
    };

    // const stillRegisteredTokens = registrationTokens;
    // response.results.forEach((result, index) => {
    //   const error = result.error;
    //   if (error) {
    //     const failedRegistrationToken = registrationTokens[index];
    //     console.error("blah", failedRegistrationToken, error);
    //     if (
    //       error.code === "messaging/invalid-registration-token" ||
    //       error.code === "messaging/registration-token-not-registered"
    //     ) {
    //       const failedIndex = stillRegisteredTokens.indexOf(
    //         failedRegistrationToken
    //       );
    //       if (failedIndex > -1) {
    //         stillRegisteredTokens.splice(failedIndex, 1);
    //       }
    //     }
    //   }
    // });
    return await admin
      .messaging()
      .sendToDevice(registrationTokens, payload)
      .then(response => {
        console.log("Successfully sent message:", response);
      })
      .catch(error => {
        console.log("Error sending message:", error);
      });

    // admin
    //   .firestore()
    //   .doc("users/" + uid)
    //   .update({
    //     registrationTokens: stillRegisteredTokens
    //   });
  });

exports.AccountApprove = functions.firestore
  .document("Sellers/{uid}")
  .onUpdate(async (docSnapshot, context) => {
    const oders = docSnapshot.after.data();
    const uid = oders["id"];
    const name = oders["name"];
    // const senderName = oders["senderName"];
    console.log(oders);
    const userDoc = await admin
      .firestore()
      .doc("Sellers/" + uid)
      .get();
    const Verification = userDoc.get("Verification");
    const registrationTokens = userDoc.get("userToken");
    console.log(Verification);
    console.log(registrationTokens);
    var trim = name.indexOf(" ");
    var sendingName = name.slice(0, trim);
    // const notificationBody =
    //   message["type"] === "TEXT"
    //     ? message["text"]
    //     : "You received a new image message.";
    //verification
    if (Verification === true) {
      const payload = {
        notification: {
          title: sendingName + " - Your Account Is Now  Approved!",
          body: "Check Your First impression 😊",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          sound: "default"
        }
      };

      return await admin
        .messaging()
        .sendToDevice(registrationTokens, payload)
        .then(response => {
          console.log("Successfully sent message:", response);
        })
        .catch(error => {
          console.log("Error sending message:", error);
        });
    } else if (Verification === false) {
      console.log("Account in Pending");
    }

    // const stillRegisteredTokens = registrationTokens;
    // response.results.forEach((result, index) => {
    //   const error = result.error;
    //   if (error) {
    //     const failedRegistrationToken = registrationTokens[index];
    //     console.error("blah", failedRegistrationToken, error);
    //     if (
    //       error.code === "messaging/invalid-registration-token" ||
    //       error.code === "messaging/registration-token-not-registered"
    //     ) {
    //       const failedIndex = stillRegisteredTokens.indexOf(
    //         failedRegistrationToken
    //       );
    //       if (failedIndex > -1) {
    //         stillRegisteredTokens.splice(failedIndex, 1);
    //       }
    //     }
    //   }
    // });

    // admin
    //   .firestore()
    //   .doc("users/" + uid)
    //   .update({
    //     registrationTokens: stillRegisteredTokens
    //   });
  });
