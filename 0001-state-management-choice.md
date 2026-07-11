# ADR 0001: Use BLoC for screen state management

## Status
Accepted

## Context

The starter file kept all state in a static `AppState` class with mutable
`static` fields (`totalCost`, `history`, `lastError`), read and written
directly by the widget. This has several problems:

- No single source of truth for "what state is the screen in right now" —
  loading, error, and success weren't distinct states, just a `loading`
  bool plus whatever was left over in stale fields.
- Business logic (parsing responses, deciding what counts as an error) was
  interleaved with widget code and `BuildContext`, so it couldn't be unit
  tested without also instantiating a widget tree.
- No way to guard against acting on a network response after the widget
  requesting it was gone (the `mounted`-check bug in REVIEW.md Finding 5).

This project is a screen inside a larger app that will only ever have one
Flutter engineer with no code review. The state-management choice needs to
be something whose failure modes are learnable from the type system and
tests, not from tribal knowledge.

## Decision

Use **BLoC** (`flutter_bloc`) for the screen's state:

- One `Bloc`/`Cubit` per concern (sending an SMS, loading the cost
  breakdown), each with a sealed set of states (e.g. `CostLoading`,
  `CostEmpty`, `CostLoaded`, `CostError`) that the UI switches over
  exhaustively.
- The bloc depends only on `SmsRepository` (an interface), not on
  `ApiClient` or `http` directly, so it can be tested with a fake
  repository and no network.
- The UI layer only dispatches events and rebuilds from emitted states; it
  never touches the repository or `ApiClient` directly, and never holds
  business logic.

## Consequences

**Positive**
- State transitions are explicit and exhaustively handled by the compiler
  (`sealed class` + `switch`), so a new state can't be silently ignored by
  the UI.
- The bloc has no dependency on `BuildContext`, so the crash class in
  Finding 5 (touching a disposed widget's context after an `await`) can't
  happen inside the bloc itself — the UI layer still needs its own
  `mounted` check for anything it does in response to a state change (e.g.
  showing a `SnackBar`), which is a much smaller surface to get right.
- Highly testable in isolation with `bloc_test`, without pumping a widget
  tree, which matters given there's no reviewer to catch a missed test.

**Trade-offs**
- More boilerplate than a single `ChangeNotifier` or raw `setState` for a
  screen this small — events, states, and the bloc itself are three moving
  parts where a simpler screen might get away with one.
- Anyone maintaining this project after me needs to be comfortable with
  BLoC's event/state vocabulary; it's a steeper on-ramp than
  `StatefulWidget` + `setState` for a very junior contributor.
- Given this project will have exactly one Flutter engineer at a time and
  no code review, the "hard to misuse" property of exhaustive state
  handling was weighted more heavily than raw simplicity.

## Alternatives considered

- **`ChangeNotifier` / `Provider`** — simpler, less boilerplate, but states
  are just fields on a mutable object rather than a sealed type; it's
  easier to leave a state combination unhandled (e.g. forgetting to clear
  an error when a new load starts) without the compiler flagging it.
- **Riverpod** — similar benefits to BLoC with less boilerplate for simple
  cases, but the team's existing familiarity and the desire for explicit,
  named states for this particular screen favored BLoC's event/state
  shape.
