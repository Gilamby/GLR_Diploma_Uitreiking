# Backend configuration

Use **[SETUP_TUTORIAL.md](SETUP_TUTORIAL.md)** for step-by-step Firebase, Firestore, Authentication, and `.env` setup.

**Summary**

- **Auth:** Email/Password enabled; one shared **viewer** user; stream code in `.env` gates the UI before Firebase sign-in.
- **Roles / exam class:** Stored in Firestore `users/{uid}` — see [database_schema.md](database_schema.md).
- **Rules:** `firebase/firestore.rules`, `firebase/storage.rules` — deploy from the `firebase/` folder (`firebase deploy --only firestore:rules,storage`).
- **Vimeo:** Token and showcase ID in `.env`; details in SETUP_TUTORIAL.
