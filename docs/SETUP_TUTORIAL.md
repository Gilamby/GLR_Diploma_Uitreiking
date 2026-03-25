# Complete setup tutorial (Firebase, Firestore, login)

Follow these steps **in order**. You only need a Google account. Skip nothing: the app expects **Authentication**, **Firestore data**, and **`.env`** to work together.

---

## What you are building (mental model)

| Piece | What it does |
|--------|----------------|
| **Firebase project** | Hosts Auth, database (Firestore), and file storage for your school. |
| **Web app in Firebase** | Gives you the six `FIREBASE_*` keys for `.env`. |
| **Authentication user** | A real email/password account (e.g. `viewer@school.nl`). The app signs everyone in as **this one user** after they type the stream code. |
| **Firestore `users/{uid}`** | A **profile document** for that user: `role` and `examClass`. Without it, security rules block the gallery and uploads. |
| **`.env`** | Stream code + same email/password as the Auth user + Firebase web config + Vimeo. |

---

## Step 1 — Create a Firebase project

1. Open [Firebase Console](https://console.firebase.google.com/).
2. Click **Add project** (or **Create a project**).
3. Enter a name → continue → Analytics optional → **Create project**.

---

## Step 2 — Add a Web app and fill `FIREBASE_*` in `.env`

1. In the project **overview**, click **`</>`** (Add a **Web** app).
2. Register a nickname (e.g. `diploma-web`). You do not need Hosting for local testing.
3. Firebase shows a `firebaseConfig` object. Copy values into your project’s **`.env`** (create it from `.env.example` if needed):

| Console field | `.env` variable |
|---------------|-----------------|
| `apiKey` | `FIREBASE_API_KEY` |
| `authDomain` | `FIREBASE_AUTH_DOMAIN` |
| `projectId` | `FIREBASE_PROJECT_ID` |
| `storageBucket` | `FIREBASE_STORAGE_BUCKET` |
| `messagingSenderId` | `FIREBASE_MESSAGING_SENDER_ID` |
| `appId` | `FIREBASE_APP_ID` |

**Find config later:** ⚙️ **Project settings** → **Your apps** → your Web app → **SDK setup and configuration**.

---

## Step 3 — Enable Authentication (Email/Password)

1. Left menu: **Build** → **Authentication** → **Get started**.
2. **Sign-in method** tab → **Email/Password** → **Enable** → Save.

---

## Step 4 — Create the “viewer” user (the account everyone shares behind the stream code)

1. Still under **Authentication** → **Users** tab → **Add user**.
2. Enter an email and password you will remember (e.g. `ceremony@your-school.nl` and a strong password).
3. After the user is created, **click the user row** and copy the **User UID** (long string like `xY8z...`). You need it in Step 6.

4. Put the **same** email and password into `.env`:

```env
EVENT_VIEWER_EMAIL=the-exact-email@you-created.com
EVENT_VIEWER_PASSWORD=the-exact-password-you-set
```

5. Set the code guests will type:

```env
STREAM_ACCESS_CODE=123
```

(Use any code you like; visitors must type it exactly.)

---

## Step 5 — Create the Firestore database

1. Left menu: **Build** → **Firestore Database** → **Create database**.
2. Choose a **location** close to you (cannot be changed later easily).
3. For your **first** run you can pick **Start in test mode** (temporary open rules). **Before production**, switch to the rules in this repo (Step 7).
4. Finish the wizard. You should see an empty database.

---

## Step 6 — Add the user profile document (this is what you were missing)

Security rules read **`users/{uid}`** to know `role` and `examClass`. The `{uid}` must be the **User UID** from Step 4, not the email.

1. In Firestore, click **Start collection**.
2. Collection ID: `users`
3. Document ID: paste the **User UID** exactly (Firebase may offer “Auto-ID” — switch to **custom ID** and paste the UID).
4. Add fields (type **string** unless noted):

| Field | Example value | Notes |
|--------|----------------|--------|
| `role` | `student` | Use `student`, `family`, `friend`, `mentor`, or `photographer`. Upload screen needs `mentor` or `photographer`. |
| `examClass` | `2025-A` | Any label you use for your class; **photos** are scoped by this string. |
| `displayName` | `Ceremony guest` | Optional but nice. |
| `createdAt` | *(timestamp)* | Optional; in Console choose **timestamp** type if you add it. |

5. **Save.**

**Checklist:** `users` → one document whose **ID equals** the Auth user’s **UID**.

---

## Step 7 — Deploy security rules (production-style)

The files `firebase/firestore.rules` and `firebase/storage.rules` in this project match how the app works. You should deploy them so behavior matches production.

**Option A — Firebase CLI (recommended)**

1. Install [Firebase CLI](https://firebase.google.com/docs/cli) and run `firebase login`.
2. Open a terminal in your **repository root**, then enter the `firebase` folder (this is where `firebase.json` lives):

```bash
cd firebase
firebase use --add
```

Select your Firebase project. (First time only; creates `.firebaserc` in `firebase/`.)

3. Deploy rules:

```bash
firebase deploy --only firestore:rules,storage
```

Still inside the `firebase` directory.

**Option B — Console (manual)**  
Copy the contents of `firebase/firestore.rules` into **Firestore** → **Rules** → Publish.  
Copy `firebase/storage.rules` into **Storage** → **Rules** → Publish.

**If rules are strict and `users/{uid}` is missing:** reads/writes will fail until Step 6 is correct.

---

## Step 8 — Enable Storage

1. **Build** → **Storage** → **Get started** → complete the wizard (default bucket is fine).
2. Deploy **storage** rules (Step 7) so uploads match paths under `photos/{examClass}/...`.

---

## Step 9 — Restart Flutter after every `.env` change

`.env` is bundled as an **asset**. After editing it:

- Stop the app and run `flutter run` again, **or** use **Hot restart** (not only hot reload).

---

## Step 10 — Vimeo (optional, for livestream screen)

1. `.env`: `VIMEO_ACCESS_TOKEN` and `VIMEO_SHOWCASE_ID` (numeric ID from the showcase URL).
2. Token needs permission to read the showcase/album API. See `.env.example` comments.

---

## Step 11 — Verify everything

| Check | |
|--------|---|
| `.env` has all `FIREBASE_*`, `STREAM_ACCESS_CODE`, `EVENT_VIEWER_*`, Vimeo if used | ✓ |
| Auth user exists with **same** email/password as `EVENT_VIEWER_*` | ✓ |
| Firestore has `users/{UID}` with `role` and `examClass` | ✓ |
| Rules deployed (or test mode for Firestore only for a short trial) | ✓ |
| App restarted after `.env` edit | ✓ |

Run:

```bash
flutter pub get
flutter run -d chrome
```

Log in with **stream code** only (not the email — the app uses `.env` for Firebase sign-in after the code matches).

---

## Troubleshooting

| Symptom | Likely cause |
|---------|----------------|
| “Onjuiste streamcode” | `STREAM_ACCESS_CODE` in `.env` ≠ what you typed, or app not restarted after changing `.env`. |
| Firebase / invalid-credential | Wrong `EVENT_VIEWER_EMAIL` or `EVENT_VIEWER_PASSWORD`, or user not created in **this** Firebase project. |
| Gallery empty / permission errors | No `users/{uid}` document, or **document ID ≠ User UID**, or `examClass` mismatch with photo documents. |
| Upload fails | `role` must be `mentor` or `photographer` in `users/{uid}`. |

---

## Security note (web)

Flutter Web **ships `.env` inside the build**. Treat stream code + viewer password as **obscurity**, not bank-grade secrecy. For higher assurance, validate codes on a server or use Firebase App Check / custom tokens.

---

## Where things live in this repo

| Topic | Location |
|--------|-----------|
| Firestore rules | `firebase/firestore.rules` |
| Storage rules | `firebase/storage.rules` |
| Env template | `.env.example` |
| Quick env variable list | `ENV_SETUP.md` |
| Schema cheat sheet | `docs/database_schema.md` |
