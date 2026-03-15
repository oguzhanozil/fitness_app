# Fitness App

A Flutter-based AI coach application with multiple personas (Dietitian, Fitness, Pilates, Yoga), chat history, and a themed mobile-first UI.

## Architecture Decisions

The app is structured by feature and follows a lightweight clean architecture split:

- `lib/core`: Cross-cutting concerns (constants, app theme, shared services).
- `lib/data`: External integrations and persistence (`firebase_ai`, `remote_config`, local storage).
- `lib/domain`: Business models used across layers (`CoachPersona`, conversation models).
- `lib/features`: UI + state management per feature (`coaches`, `chat`, `history`, `home`).

Key decisions:

- **State management with `flutter_bloc` (Cubit):** chosen for predictable UI state and simple unidirectional data flow.
- **Repository pattern:** `CoachRepository` and `ChatRepository` isolate data sources from UI and make feature code easier to test.
- **Theming via central `ThemeColors`:** all colors are defined in one place to keep visual consistency and simplify design changes.
- **Persona-driven UI composition:** `CoachCard` accepts explicit inputs (`coachName`, `coachBranch`, etc.) while still supporting optional themed color overrides.
- **Asset-based avatars with fallback icons:** improves UX when an image is missing and avoids broken UI states.

## Project Structure

```text
lib/
	core/
	data/
	domain/
	features/
		coaches/
		chat/
		history/
		home/
```

## Screenshots

These screenshots reflect the current running app:

![Coaches Screen](docs/screenshots/coaches.png)
![History Screen](docs/screenshots/history.png)
![Chat Screen](docs/screenshots/chat.png)

## Notes

- Coach avatars are loaded from `assets/avatars/`.
