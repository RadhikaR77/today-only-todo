# Today-Only Todo App

A minimal iOS todo application built around a strict constraint:

> Tasks only exist for the current day
> Every new day automatically starts fresh

Built using **SwiftUI + MVVM + Repository Pattern + CoreData**

---

## Product Interpretation

The constraint *“today only”* changes the nature of the app.

This is not a traditional task manager — it is a **daily intention list**.

The goal is to reduce backlog anxiety and encourage focus only on what matters today.

Because of this, I intentionally optimized for:

• Fast task entry
• Zero cleanup by the user
• Automatic reset of mental state each day

And intentionally avoided:

• Future scheduling
• Overdue tasks
• History tracking

These features contradict the product’s purpose.

---

## Architecture

The project follows a layered structure:

**Views → ViewModel → Repository → CoreData**

### Why this separation?

The UI should not know how data is stored.
The ViewModel should not know about CoreData.
The repository isolates persistence from business logic.

This makes the app:

* Easier to reason about
* Testable
* Replaceable (CoreData → SwiftData/File later)

---

## Handling the “Today-Only” Constraint

Instead of deleting tasks at midnight, each task stores a creation date.

When fetching tasks, the repository filters using the current day range:

`startOfDay(today) ≤ task.date < startOfDay(tomorrow)`

### Why this approach?

• Old tasks disappear automatically
• No background jobs or timers required
• Works even if the app stays closed for days
• Prevents accidental data deletion

The system derives truth from time rather than mutating stored data.

---

## State Management

`TodayViewModel` acts as the single source of truth:

* Separates completed vs active tasks
* Updates UI reactively
* Keeps business logic out of views

Views remain simple renderers of state.

---

## Persistence Choice (Why CoreData?)

CoreData was chosen over SwiftData because:

* Predictable behavior on iOS 16
* Explicit fetch control
* Clear separation from SwiftUI lifecycle

SwiftData would reduce code but hide persistence behavior,
which is undesirable in a constraint-driven application where data lifetime is central.

---

## Edge Cases Considered

• App unopened for multiple days → handled by date filtering
• Midnight boundary → no cleanup required
• Time zone change → uses `Calendar.current.startOfDay`
• Partial-day usage → tasks remain until next calendar day

---

## UX Decisions

I kept the UI intentionally minimal to support quick daily usage.

Enhancements added:

* Haptic feedback on complete/delete
* Completion animations
* Dark mode support
* Guided empty state

I avoided feature creep to keep the daily-focus constraint central.

---

## Tradeoffs

Not implemented:

* Notifications
* Widgets
* Time-based expiration within the day

Reason: prioritizing correctness of the constraint and architecture clarity over feature breadth.

---

## What I Would Improve With More Time

* Unit tests for date filtering logic
* Injected clock abstraction for deterministic testing
* SwiftData migration evaluation
* Reminder notification before end of day
* Home screen widget

---

## Running the App

1. Open `Todo_hackathon.xcodeproj`
2. Run on iOS 16+ simulator
3. Add tasks — they automatically reset the next day

---

## Demo Video

The demo demonstrates:

1. Adding tasks
2. Completing tasks
3. Relaunching the app (tasks persist same day)
4. Simulating next day (tasks automatically disappear)

[Watch the demo](./demo.mov)

---

## Author

Radhika Rathi

