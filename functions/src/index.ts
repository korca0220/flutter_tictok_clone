import * as admin from "firebase-admin";
import * as functions from "firebase-functions";


admin.initializeApp();

export const onVideoCreated = functions.firestore
    .document("videos/{videoId}")
    .onCreate(async (snapshot, context) => {
        const spawn = require("child-process-promise").spawn;
        const video = snapshot.data();
        await spawn("ffmpeg", [
            "-i",
            video.fileUrl,
            "-ss",
            "00:00:01.000",
            "-vframes",
            "1",
            "-vf",
            "scale=150:-1",
            `/tmp/${snapshot.id}.jpg`,
        ]);
        const storage = admin.storage();

        const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
            destination: `thumbnails/${snapshot.id}.jpg`,
        });

        await snapshot.ref.update({
            'thumbnailUrl': file.publicUrl(),
        });

        const db = admin.firestore();


        await file.makePublic();
        db.collection("users").doc(video.creatorUid).collection("videos").doc(snapshot.id).set({
            thumbnailUrl: file.publicUrl(),
            videoId: snapshot.id,
        });

    });


export const onLikedCreated = functions.firestore
    .document("likes/{likeId}")
    .onCreate(async (snapshot, context) => {
        const db = admin.firestore();
        const [videoId, userId] = snapshot.id.split("000");

        await db.collection("videos")
            .doc(videoId)
            .update({
                likes: admin.firestore.FieldValue.increment(1),
            });

        await db
            .collection("users")
            .doc(userId)
            .collection("likes")
            .doc(videoId)
            .set({
                createdAt: Date.now()
            });
    });

export const onLikedRemoved = functions.firestore
    .document("likes/{likeId}")
    .onDelete(async (snapshot, context) => {
        const db = admin.firestore();
        const [videoId, userId] = snapshot.id.split("000");

        await db.collection("videos")
            .doc(videoId)
            .update({
                likes: admin.firestore.FieldValue.increment(-1),
            });

        await db
            .collection("users")
            .doc(userId)
            .collection("likes")
            .doc(videoId)
            .delete();
    })