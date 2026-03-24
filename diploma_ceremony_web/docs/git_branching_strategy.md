# Git Branching Strategy

## Branches

- `main`: production-ready release branch
- `develop`: sprint integration branch
- `feature/<ticket>-<short-name>`: individual development branches
- `release/<date-or-sprint>`: stabilization before milestone
- `hotfix/<issue>`: urgent production fixes

## Team Workflow

- Fabian, Nassim, Salah, Soufyan, and Guusje each pick Trello tasks from `Today`.
- Every task starts in a dedicated `feature/*` branch from `develop`.
- Pull request required into `develop` with at least one reviewer.
- Merge `develop` into `release/*` at sprint end.
- Merge `release/*` into `main` for approved deployment.

## Commit Convention

- `feat:` new feature
- `fix:` bug fix
- `refactor:` internal restructuring
- `chore:` tooling or maintenance
- `docs:` documentation

## Protection Rules

- Protect `main` and `develop`.
- Require status checks before merge.
- Disallow direct pushes to protected branches.
