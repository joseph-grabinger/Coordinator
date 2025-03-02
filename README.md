# Coordinator

`Coordinator` is a lightweight and flexible Swift package for managing SwiftUI navigation using the Coordinator pattern.
This pakcage helps to separate navigation logic from the views, making the codebase cleaner and more maintainable.

## What is a Coordinator?

A coordinator is a lightweight object that encapsulates navigation logic and coordiantes between sets of views or even other coordinators.
Instead of embedding navigation logic inside SwiftUI views, a coordinator acts as an intermediary that determines which view should be presented based on user actions. This leads to improved modularity, better testability, and cleaner code.
