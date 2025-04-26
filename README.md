# Coordinator

The Coordinator package is a lightweight and flexible Swift package for managing SwiftUI navigation using the Coordinator pattern.
This package helps to separate navigation logic from the views, making the codebase cleaner and more maintainable.

## Installing

### Swift Package Manager

Coordinator can be installed via [Swift Package Manager](https://github.com/swiftlang/swift-package-manager). 
To integrate `Coordinator` with your Swift project, specify Coordinator as a dependency via the standard
[Swift Package Manager package definition process](https://github.com/swiftlang/swift-package-manager/blob/main/Documentation/Usage.md).

1. In Xcode, select “File” → “Add Packages...”
2. Enter https://github.com/joseph-grabinger/Coordinator.git

Or you can add the following dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/joseph-grabinger/Coordinator.git", from: "1.0.0")
```

## Features

 - Coordination of `TabView`s
 - Coordination of `NavigationStacks`s
 - Coordination of modal `View`s like `.sheet`s & `.fullScreenCover`s

## Usage

This package exposes two basic protocols for coordinators - `TabViewCoordinating` & `StackCoordinating` (which also handles the presentation of modals). For each coordinator there is a designated `View` - `CoordinatedTabView` & `CoordinatedStack`.


## NavigationStack Coordinator

To create a `NavigationStack` coordinator, first a route type is needed. This route type must be `Routable`-conforming and defines the routes the `NavigationStack` and its coordinator should handle.

```swift
enum MyScreen: String, Routable {
    case view1 = "view1"
    case view2 = "view2"

    var id: String { self.rawValue }

    var body: some View {
        switch self {
        case .view1:
            MyScreen1()
        case .view2:
            MyScreen2()
        }
    }
}
```

Next, a `TabViewCoordinating`-conforming coordinator class is created.

```swift
class MyStackCoordinator: StackCoordinating {
    let initialRoute = MyScreen.view1

    @Published var path = NavigationPath()
    @Published var sheet: MyScreen?
    @Published var fullScreenCover: MyScreen?

    var root: (any StackCoordinating)?
    
    static nonisolated func == (lhs: MyStackCoordinator, rhs: MyStackCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}
```

Finally, the newly created `MyStackCoordinator` can be used in a `View`.

```swift
struct ContentView: View {
    @StateObject var coordinator = MyStackCoordinator()
    
    var body: some View {
        CoordinatedStack(for: coordinator)
    }
}
```

To programmatically navigate to a new route, the coordinator offers several methods for the presentation of route:
 - `push(_:)` - pushes a new route onto the `NavigationStack`
 - `pop()` - pops a route of the `NavigationStack`
 - `popToRoot()` - pops to the initial route of the coordinator
 - `pushCoordinator(_:)` - pushes a new coordinator onto the `NavigationStack`
 - `present(_:)` - presents a route modally (can be as `.sheet` or `.fullScreenCover`)
 - `dismiss(_:)` - dismisses a modally presented route

## TabView Coordinator

To create a `TabView` coordinator, first a route type is needed. This route type must be `TabRoutable`-conforming and defines the tabs the `TabView` and its coordinator should handle.

```swift
enum MyTab: String, TabRoutable, CaseIterable {
    case tab1
    case tab2

    var id: String { self.rawValue }
    
    var body: some View {
        switch self {
        case .tab1:
            MyTab1View()
        case .tab2:
             MyTab2View()
        }
    }
    
    var label: Label<Text, Image> {
        switch self {
        case .tab1:
            Label("Tab 1", systemImage: "circle")
        case .tab2:
            Label("Tab 2", systemImage: "star")
        }
    }
}
```

Next, a `TabViewCoordinating`-conforming coordinator class is created.

```swift
class MyTabCoordinator: TabViewCoordinating {
    @Published var selectedTab = MyTab.tab1
    
    let tabs: [MyTab] = MyTab.allCases

    static nonisolated func == (lhs: MyTabCoordinator, rhs: MyTabCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}
```

**Note:** The `tabs` can only be defined as a constant (`let`) if the `TabRoutable`-conforming enum is `CaseIterable`. If not a `lazy var` can be used.

Finally, the newly created `MyTabCoordinator` can be used in a `View`.

```swift
struct ContentView: View {
    @StateObject var coordinator = MyTabCoordinator()
    
    var body: some View {
        CoordinatedTabView(for: coordinator)
    }
}
```

To programmatically change the selected tab, the coordinator's `select(_:)` method can be used.

## Parametrized Routes

To pass data to routes (`Routable` or `TabRoutable`) enums with associated values can be used. 

This is especially useful to for example pass the corresponding coordinator to the route.

However, when using associated values, `String` or any other `RawRepresentable` can't be used. Thus a custom `id` must be constructed based on the associated value.   

```swift
enum MyScreen: Routable {
    case view1(coordinator: MyStackCoordinator)
    case view2(coordinator: MyStackCoordinator)

    var id: String { 
        switch self {
        case .view1(let coordinator):
            "view1_\(coordinator.id)"
        case .view2(let coordinator):
            "view2_\(coordinator.id)"
    }

    var body: some View {
        switch self {
        case .view1:
            MyScreen1()
        case .view2:
            MyScreen2()
        }
    }
}
```

## What is a Coordinator?

A coordinator is a lightweight object that encapsulates navigation logic and coordiantes between sets of views or even other coordinators.
Instead of embedding navigation logic inside SwiftUI views, a coordinator acts as an intermediary that determines which view should be presented based on user actions. This leads to improved modularity, better testability, and cleaner code.
