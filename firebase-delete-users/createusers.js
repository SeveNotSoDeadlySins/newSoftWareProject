const admin = require("firebase-admin");
const fs = require("fs");

admin.initializeApp({
  credential: admin.credential.cert(require("./serviceAccountKey.json")),
});

async function createUsersBatch(batchSize = 1000, prefix = "testuser") {
  for (let i = 0; i < batchSize; i++) {
    const email = `${prefix}${i}@example.com`;
    const password = "TestPass123";

    try {
      const userRecord = await admin.auth().createUser({
        email: email,
        password: password,
      });

      // Create Firestore document for the user
      await admin.firestore().collection("users").doc(userRecord.uid).set({
        uid: userRecord.uid,
        username: email.split("@")[0],
        email: email,
        coins: 0,
        xp: 0,
        ownedItems: [],
        equipped: {
          background: "default_bg",
          accessory: "none",
        },
        isVerified: false,
        createdAt: new Date(),
      });

      console.log(`Created user + Firestore doc: ${email}`);
    } catch (err) {
      console.error(`Error creating ${email}:`, err.message);
    }
  }

  console.log(`Done! Created ${batchSize} users with Firestore data.`);
}

createUsersBatch(); // or createUsersBatch(500) if you want fewer
