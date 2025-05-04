# Coordinator Example Project

This is an example Xcode project showcasing different use-cases of the `Coordinator`-package.

## Project Structure

The example project consists of one `TabView` (namely `CoordinatedTabView`) with two tabs which are coordinated by the `TabViewCoordinator`.

The first tab within the `TabViewCoordinator` contains a `NavigationStack` (namely `CoordinatedStack`) which is coordinated by the `HomeCoordinator`. 

The second tab within the `TabViewCoordinator` contains a simple `View` showcasing the programmatic navigation within a `TabView`.

From the `HomeCoordinator` a variety of different `Screen`s can be pushed (where `Screen` is the `Route` type of the `StackCoordinating`-conforming `HomeCoordinator`).

Furthermore, from the `HomeCoordinator` a subsequent `StackCoordinating`-conforming (namely `NewFlowCoordinator`) can be pushed **onto the same `NavigationStack`**.

Since the `HomeCoordinator` is also `ModalCoordinating`-conforming, it can also present any of its routes (namely `Screen`s) modally (either as a `.sheet` or a `.fullScreenCover`).

## Deep Linking

The example project is configured to handle URL starting with the `coordinator-example://` scheme.

Thus, any valid `URL` (e.g. `coordinator-example://tab1/view1/view2/newFlowRoot/view1`) will open the app and produce the app-state corresponding to the `DeepLink` URL.

Any invalid `URL` (e.g. `coordinator-example://some-invalid-uri/`) will result in an error message being displayed using an `.overlay`.

### Testing Deep Links

Testing deep links can be done from the simulator by opening Safari and entering a `DeepLink` URL.

Alternatively, a deep link can also be triggered from within the app. For example, a button could be added to a SwiftUI view to open a `DeepLink` from any place:

```swift
Button("Open Second Tab") {
    UIApplication
        .shared
        .open(URL(string: "coordinator-example://tab2")!)
}
```
