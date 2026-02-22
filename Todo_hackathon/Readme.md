# GACS - Eulerity iOS Take-Home Exercise

# Today-Only Todo App

A minimal iOS todo application built around a strict constraint:

> Tasks only exist for the current day.
> Every new day automatically starts fresh.

Built using **SwiftUI + MVVM + Repository Pattern + CoreData**

---

## Architecture

The project follows a layered structure:

Views → ViewModel → Repository → CoreData

**Why?**

The UI should not know how data is stored.
The ViewModel should not know about CoreData.
The repository isolates persistence from business logic.

This keeps the app:

* easier to reason about
* testable
* replaceable (CoreData → SwiftData/File later)

---

## Handling the “Today-Only” Constraint

Instead of deleting tasks at midnight, each task stores a creation date.

When fetching tasks, the repository filters using the current day range:

startOfDay(today) ≤ task.date < startOfDay(tomorrow)

This means:

* Old tasks automatically disappear
* No background cleanup needed
* No risk of accidental deletion

The system behaves correctly even if the app stays closed overnight.

---

## State Management

`TodayViewModel` acts as the single source of truth:

* Separates completed vs active tasks
* Updates UI reactively
* Prevents business logic inside views

Views remain simple renderers of state.

---

## UX Decisions

I intentionally kept the UI minimal and focused on clarity.

Enhancements added:

* Haptic feedback on complete/delete
* Animated completion state
* Dark mode support
* Empty state guidance

I avoided feature creep to keep the constraint central.

---

## Tradeoffs

Not implemented:

* Notifications
* Widgets
* Time-based expiration within the day

Reason: prioritizing correctness and architecture over breadth.

---

## What I Would Improve With More Time

* Unit tests for date filtering logic
* Injected clock abstraction for testability
* SwiftData migration
* Reminder notification before end of day
* Home screen widget

---

## Running the App

1. Open `Todo_hackathon.xcodeproj`
2. Run on iOS 16+ simulator
3. Add tasks — they reset automatically the next day

---

## Demo Video

## Demo

https://github.com/RadhikaR77/today-only-todo/blob/main/Todo_hackathon/Demo-1.mov

---

## Author

Radhika Rathi
