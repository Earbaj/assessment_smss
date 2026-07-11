# SMS Console — Studio Butterfly Take-Home

A rebuilt version of the SMS-send + monthly-cost screen from the take-home
assignment. The original AI-generated starter file is reviewed in
[`REVIEW.md`](./REVIEW.md); this project is the fix.

## What this is

A single Flutter screen that:
- Sends an SMS through the Formwork channel API
- Shows a monthly cost breakdown by provider
- Handles loading, empty, error (with retry), and success states
- Works at both phone (360px) and desktop (1400px) widths

## Getting started

```bash
flutter pub get
flutter run \
  --dart-define=API_BASE_URL=https://api.formwork.example.com \
  --dart-define=API_KEY=your_key_here \
  --dart-define=TENANT_ID=your_tenant_id_here
```

No real backend is required to try this out. The app defaults to an
in-memory fake repository (`FakeSmsRepository` in `lib/main.dart`) so it
runs standalone. To point it at a real backend, swap in `HttpSmsRepository`
as shown in the comment in `main.dart`.

### Running tests

```bash
flutter test
```

<!-- TODO: fill in once golden tests are added -->
Golden test images live under `test/goldens/`. If you change the UI and
need to regenerate them:

```bash
flutter test --update-goldens
```

## Architecture

```
lib/
  core/       # money handling, typed models, API client, repository
  state/      # BLoC(s) — one event/state pair per screen concern
  ui/         # widgets; read state, dispatch events, never call the network directly
```

- **`core/money.dart`** — money is never a `double`. Amounts are parsed from
  the API's decimal strings into integer minor units, so there's no
  floating-point rounding error across large volumes of messages.
- **`core/models.dart`** — every API response is parsed into a typed class
  before it reaches state or UI code. No `dynamic`/`Map` access outside this
  file.
- **`core/api_client.dart`** — the single place that attaches
  `Authorization` and `X-Tenant-Id` to every request, and maps HTTP status
  codes to typed failures (`ApiFailure` subtypes) instead of throwing raw
  exceptions.
- **`core/sms_repository.dart`** — an interface between the API client and
  the BLoC, so the backend can be swapped for a fake/stub without touching
  UI or state code.
- **`state/`** — <!-- TODO: describe your actual Bloc/Cubit classes, their
  events and states, here. See ADR 0001 for why BLoC was chosen. -->
- **`ui/sms_console_page.dart`** — renders one of four states (loading /
  empty / error+retry / success) based on what the BLoC emits. Never
  fetches data itself, and never reads a `recipient` field on the cost
  breakdown screen (see REVIEW.md Finding 6).

See [`docs/adr/0001-state-management-choice.md`](./docs/adr/0001-state-management-choice.md)
for the reasoning behind the state-management choice.

## What's fixed from the starter

All 8 findings in [`REVIEW.md`](./REVIEW.md) are addressed here — hardcoded
API key removed, `X-Tenant-Id` sent on every request, money handled without
`double`, cost taken from the server response instead of recomputed
client-side, no `context` use after an unguarded `await`, no recipient
number shown on the cost screen, no sensitive data logged, and no network
call inside `build()`.

## What's scoped down / cut

Time-boxed to ~6–8 hours per the assignment. Cut, in priority order:

<!-- TODO: replace with what you actually cut. Example: -->
- [ ] Pagination on message history (cost breakdown only covers current month)
- [ ] Token refresh flow (a real login/refresh cycle, not just a static define)
- [ ] Full accessibility pass beyond basic Semantics labels and tap targets
- [ ] Second golden test for the desktop (1400px) layout

## Tested on

<!-- TODO: fill in which platforms you actually ran this on and what broke -->
- [ ] iOS Simulator / Android Emulator
- [ ] Web (Chrome) at 360px and 1400px
- Known issues at small widths: <!-- e.g. long provider names wrap awkwardly -->
