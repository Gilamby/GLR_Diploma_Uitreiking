# Firestore schema (reference)

**How to create these in the Console:** [SETUP_TUTORIAL.md](SETUP_TUTORIAL.md) (especially the `users/{uid}` document — required for login + rules).

## `users/{uid}`

`{uid}` must match **Authentication → User UID** (not the email).

| Field | Type | Notes |
|-------|------|--------|
| `role` | string | `student`, `family`, `friend`, `mentor`, `photographer` |
| `examClass` | string | Class code; photos are filtered by this |
| `displayName` | string | Optional |
| `createdAt` | timestamp | Optional |

## `photos/{photoId}`

| Field | Type |
|-------|------|
| `url` | string |
| `path` | string |
| `examClass` | string |
| `uploadedBy` | string |
| `createdAt` | timestamp |

## `livestream/{docId}`

| Field | Type |
|-------|------|
| `showcaseId` | string |
| `updatedAt` | timestamp |

## `access_codes/{code}` (legacy)

Not used by the app for login. Optional for admin tooling.

## Backup

- Scheduled: `gcloud firestore export` to Cloud Storage.
- Ad hoc: Firebase Console export.
