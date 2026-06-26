# MericStack

> Applications should evolve. Infrastructure should stay predictable.

## Why MericStack Exists

In most Flutter teams, the architecture inevitably drifts over time. One developer handles errors using exceptions; another uses return types. One feature handles routing in the UI; another buries it in the business logic. 

We realized that while the business logic of every app is unique, the underlying infrastructure—routing, error boundaries, network clients—is completely repetitive. When infrastructure drifts, maintaining multiple projects (or scaling a single one) becomes a massive technical debt.

## What Happens After Scaffolding?

We studied how different teams solve this problem:
* Teams use templates and `Mason` bricks.
* Teams write extensive `architecture.md` files.
* Teams rely on rigorous code reviews and AI prompt instructions.

But here is the reality we observed: **Templates create projects; they don't keep them consistent.** Markdown files don't throw compiler errors when they are ignored by a developer or an AI agent. 

Scaffolding is a Day 0 solution. MericStack is built to protect the architecture on Day 100.

## What MericStack Actually Enforces

MericStack is not a state management library. It does not care how you draw your UI. It only standardizes the plumbing.

**Enforced Boundaries:**
* **The `Result` Pattern:** Every command and repository must strictly return a `Result<T, AppFailure>`. 
* **Failure Normalization:** Exceptions are caught at the edge and mapped to strongly typed `AppFailure` classes.
* **Deterministic Execution:** No hidden `try/catch` blocks. The UI only handles deterministic success or failure states.
* **Strict Linter Rules:** Automated conventions that prevent architectural drift before code is merged.

**What Stays Flexible:**
* UI & Widget composition
* Core Business Logic
* Feature design
* Internal State Management

## The 3-Minute Test

We believe a framework should prove its value in code, not just in documentation. You should understand the entire architecture by looking at a single file. 

Explore our Developer Preview: [**`example/login_example.dart`**](example/login_example.dart)

It demonstrates the complete execution flow in a simplified, highly readable format:

```text
UI (LoginScreen)
 ↓
LoginCommand
 ↓
LoginRepository
 ↓
Result<User, AppFailure>
 ↓
UI handles Success / Failure deterministically
