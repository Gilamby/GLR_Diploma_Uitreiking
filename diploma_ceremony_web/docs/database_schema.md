# Firestore Schema

## Collections

### `users/{uid}`
- `role` (string): `student`, `family`, `friend`, `mentor`, `photographer`
- `examClass` (string): exam class code
- `displayName` (string)
- `createdAt` (timestamp)

### `access_codes/{code}`
- `email` (string)
- `password` (string)
- `role` (string)
- `examClass` (string)
- `isActive` (bool)
- `createdAt` (timestamp)

### `photos/{photoId}`
- `url` (string)
- `path` (string)
- `examClass` (string)
- `uploadedBy` (string)
- `createdAt` (timestamp)

### `livestream/config`
- `showcaseId` (string)
- `updatedAt` (timestamp)

## Backup and Export

- Use `gcloud firestore export` for scheduled exports to Cloud Storage.
- Use Firebase Console export to JSON for ad-hoc snapshots.
- Store export scripts in CI for repeatability.
