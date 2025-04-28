const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

async function createUsers(count) {
  for (let i = 0; i < count; i++) {
    try {
      const user = await admin.auth().createUser({
        email: `testuser${i}@example.com`,
        password: "testPassword123!",
        displayName: `Test User ${i}`
      });
      console.log(`Created user: ${user.uid}`);
    } catch (err) {
      console.error(`Error creating user ${i}:`, err.message);
    }
  }
}

createUsers(10000);
