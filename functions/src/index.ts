import * as admin from "firebase-admin";
import * as functions from "firebase-functions";


admin.initializeApp();

export const onVideoCreated = functions.firestore.document("videos/{videoId}").onCreate(async (snapshot, context) => {
    await snapshot.ref.update({ "hello": "from functions" });
});