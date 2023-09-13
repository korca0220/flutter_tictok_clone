import * as admin from "firebase-admin";
import * as functions from "firebase-functions";


admin.initializeApp();

export const onVideoCreated = functions.firestore
    .document("videos/{videoId}")
    .onCreate(async (snapshot, context) => {
        const { getStorage, getDownloadURL } = require('firebase-admin/storage');
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

        const [file, _] = await getStorage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
            destination: `thumbnails/${snapshot.id}.jpg`,
        });

        await snapshot.ref.update({
            'thumbnailUrl': file.publicUrl(),
        });

        const db = admin.firestore();
        const downloadUrl = await getDownloadURL(file);

        db.collection("users").doc(video.creatorUid).collection("videos").doc(snapshot.id).set({
            thumbnailUrl: downloadUrl,
            videoId: snapshot.id,
        });

    });