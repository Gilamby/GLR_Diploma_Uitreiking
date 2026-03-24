# Backend Configuration

## Firebase Authentication

- Enable Email/Password provider.
- Accounts are provisioned through admin workflow.
- Personal access codes are mapped in `access_codes`.
- Successful code login signs in with mapped account credentials.

## Authorization Model

- Role source of truth is `users/{uid}.role`.
- Exam class scope source of truth is `users/{uid}.examClass`.
- Uploader roles: `mentor`, `photographer`.
- Viewer roles: all authenticated roles scoped by exam class.

## Storage and Firestore Rules

- Firestore and Storage rules are in `firebase/`.
- Read access is restricted to authenticated users with matching exam class.
- Upload access is restricted to uploader roles.

## Vimeo Integration

- Vimeo API token and showcase id are loaded from `.env`.
- App fetches latest video for livestream and replay access.
