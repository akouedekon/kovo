[![CI](https://github.com/<OWNER>/<REPO>/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/<OWNER>/<REPO>/actions/workflows/ci.yml)

Kovo — Application de covoiturage (Bénin)

Contenu du dépôt:
- backend/  -> Spring Boot API (PostgreSQL)
- mobile/   -> Flutter app (Android & iOS)
- admin/    -> React + TypeScript admin panel
- api/openapi.yaml -> Spécification OpenAPI
- docker-compose.yml -> Postgres + services

Objectif: fournir un MVP avec recherche de trajets, réservation, auth par SMS OTP, intégration Kkiapay.

Instructions rapides:
- Backend: mvn spring-boot:run (dans backend)
- Mobile: flutter run (dans mobile)
- Admin: npm install && npm run dev (dans admin)

Note: Remplacez <OWNER>/<REPO> dans le badge par le propriétaire et le nom de votre dépôt GitHub pour afficher le statut CI réel.
