# Jobzshala – Job Matches (Flutter)

A small Flutter app with three screens (Job Matches list, Job Detail, Apply
confirmation) running on a mock API that behaves like a real network.
Built for the Jobzshala | Akshaki India Pvt. Ltd. assignment.

## How to run

```bash
# 1. In this folder, generate the platform folders (android/, ios/) once
flutter create . --project-name task --platforms=android,ios

# 2. Install packages and run
flutter pub get
flutter run

# 3. Unit tests (apply logic)
flutter test
```

## What is done

**Job Matches list**
- Card shows title, employer display name, city/country, salary range (AED/month), match score % and up to 3 skill chips.
- Sorted by match score (highest first) by the mock API.
- Country filter: All / UAE / Saudi Arabia / Qatar.
- Pull-to-refresh (also works on the empty screen).
- Loading (skeleton cards), empty ("No matches yet") and error (with Retry) states. No blank screens.
- Infinite scroll using the paginated endpoint (20 per page), with a footer loader and a retry button if the next page fails.
- Jobs already applied show an "Applied" tag.

**Job Detail**
- Description, requirements, benefits (accommodation, food, visa) and the AI match reason.
- Sticky Apply button at the bottom.

**Apply**
- Optimistic: the button changes to "Applied" immediately and the list card updates too.
- Success shows a confirmation dialog.
- If the call fails the change is rolled back and a red error message is shown.
- Applied job ids are saved with `shared_preferences`, so they survive an app restart.

**Everywhere**
- English / Hindi toggle in the app bar for all UI labels. Job content stays in English. The choice is saved.
- Offline: last cached jobs are shown with the banner "You're offline — showing saved jobs". Apply is disabled and a message says why. When the network comes back the list reloads by itself.

## API

`lib/data/mock_api.dart`

| Endpoint | Behaviour |
|---|---|
| `GET /jobs/matches?country=UAE&page=1` | filtered, sorted, 20 per page, `hasMore` flag |
| `GET /jobs/:id` | single job |
| `POST /jobs/:id/apply` | `{ "status": "APPLIED" }` |

Every call waits 800–1500 ms and fails with a 500 about 1 time in 5. 220 jobs are generated with a fixed random seed, so the data is the same on every run. There is no employer contact field anywhere, only the generic display name.

## Libraries and why

| Package | Why |
|---|---|
| `provider` | Simple, official-recommended state management. Easy to read and explain, no code generation. |
| `shared_preferences` | We only store small things (applied ids, language, cached jobs as JSON). A database would be overkill. |
| `connectivity_plus` | Detects online/offline and tells us when the network comes back. |
| `flutter_localizations` | Makes Material widgets (tooltips, dialogs) follow the selected language too. |

No HTTP package (mock API is in-app) and no UI kit. All widgets are written by hand.

## Project structure

```
lib/
├── main.dart                 providers + MaterialApp
├── core/                     theme, English/Hindi strings (s.dart)
├── models/job.dart           Job + Benefits (fromJson / toJson)
├── data/mock_api.dart        fake backend
├── providers/
│   ├── language_provider     current language, saved
│   ├── connectivity_provider online / offline
│   ├── job_list_provider     list, filter, pagination, cache, states
│   └── apply_provider        optimistic apply + rollback + saved ids
├── screens/                  splash, job list, job detail
└── widgets/                  job card, filter, state views, banner, dialog
test/apply_provider_test.dart
```

One provider = one job. The screens only read state and call methods.

## Decisions worth knowing

- **Optimistic apply**: `ApplyProvider.apply()` adds the id and calls `notifyListeners()` first, then calls the API. On a 500 it removes the id again. Saving to disk happens only after success, so a failed apply never comes back after restart.
- **Stale responses**: `JobListProvider` gives every list request a number (`_reqId`). If the user changes the country while an older request is still running, the old response is ignored.
- **Offline cache**: every job that was loaded is stored as JSON in `shared_preferences`. Offline mode reads from that and applies the country filter and sorting locally.
- **Performance with 200+ items**: `ListView.builder` (only visible cards are built), `RepaintBoundary` around cards, `const` widgets where possible, and `context.select` so applying to one job rebuilds only that card.
- **Localization**: a small `S` class (English) with a `$hi` subclass (Hindi) and a delegate. `MaterialApp.locale` comes from `LanguageProvider`, so toggling rebuilds the whole app.

## Bonus items

- Unit tests for the apply logic (optimistic update, rollback, persistence): done.
- Infinite scroll with the paginated endpoint: done, with a retry button if the next page fails.
- Voice note on the Apply screen: not done. I had limited time and chose to
  finish the core features properly instead of adding a half-working recorder.
- Accessibility: no separate pass. Material buttons and chips give default
  labels and 48 dp targets, but I did not add custom semantics.


## Submission notes

- **Demo video:** not included, I did not have time to record one. The steps to
  run the app are above, and the app works with the mock API without any setup.
- **Git history:** the brief asked for gradual commits. I built and tested the
  app locally and pushed it in one go, so the history is a single commit
  and does not reflect my actual working steps. I would rather say this
  clearly than make the history look different.