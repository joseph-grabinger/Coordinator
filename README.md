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
 - Coordination of `NavigationStack`s
 - Coordination of modal `View`s like `.sheet`s & `.fullScreenCover`s
 - URL-based Deep Linking
 - Validity checking for deep link URLs

## Usage

This package exposes three basic protocols for coordinators - `TabViewCoordinating`, `StackCoordinating` & `ModalCoordinating`.
For the `TabView` & `NavigationStack` coordinators there is a designated `View` - `CoordinatedTabView` & `CoordinatedStack`. 
However, for the modal coordinator there is a designated `ViewModifier` - `.modalRoutes(_:)`.
For deep linking an additional `DeepLinkHandling` protocol is exposed. Checking the validity of deep link URLs can be done by conforming to the `DeppLinkValidityChecking` protocol.


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

Next, a `StackCoordinating`-conforming coordinator class is created. 

```swift
class MyStackCoordinator: StackCoordinating {
    let initialRoute = MyScreen.view1

    @Published var path = NavigationPath()

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

To programmatically navigate to a new route, the coordinator offers several methods for the presentation of routes:
 - `push(_:)` - pushes a new route onto the `NavigationStack`
 - `pop()` - pops a route of the `NavigationStack`
 - `popToRoot()` - pops to the initial route of the coordinator
 - `pushCoordinator(_:)` - pushes a new coordinator onto the `NavigationStack`

 ## Modal Coordinator
 
 To create a coordinator for modals like `.sheet`s & `.fullScreenCover`s, first a modal route type is needed. Just like the route type for stack coordinators, this route type must be `Routable`-conforming and defines the routes the coordinator should handle.
 
 ```swift
enum MyModal: String, Routable {
    case view1 = "view1"
    case view2 = "view2"

    var id: String { self.rawValue }

    var body: some View {
        switch self {
        case .view1:
            MyModal1()
        case .view2:
            MyModal2()
        }
    }
}
```

Next, a `ModalCoordinating`-conforming coordinator class is created.

```swift
class MyModalCoordinator: ModalCoordinating {
    @Published var sheet: MyModal?
    @Published var fullScreenCover: MyModal?
}
```

Finally, the newly created `MyModalCoordinator` can be used in a `View`.

```swift
struct ContentView: View {
    @StateObject var coordinator = MyModalCoordinator()
    
    var body: some View {
        SomeView(coordinator: coordinator)
            .modalRoutes(for: coordinator)
    }
}
```

**Note:** Any `View` that is supposed to present modals for a `ModalCoordinating`-conforming coordinator class needs to first apply the `.modalRoutes(:_)` modifier, such that the modal routes for the coordinator can be resolved. 

To programmatically present a modal route, the coordinator offers two methods for the presentation of routes:
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

**Note:** The `tabs` can only be defined as a constant (`let`) if the `TabRoutable`-conforming enum is `CaseIterable`. If not a `lazy var` or computed properties can be used.

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

## Parameterized Routes

To pass data to routes (`Routable` or `TabRoutable`) enums with associated values can be used. 

This is especially useful to for example pass the corresponding coordinator to a route.

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

## Deep Linking

To add deep linking support to an existing coordinator of any kind - only the `DeepLinkHandling`-conformance is needed.

```swift
extension MyTabCoordinator: DeepLinkHandling {
    func handleDeepLink(_ deepLink: DeepLink) throws {
        switch deepLink.remainingRoutes.first {
        case "tab1":
            select(MyTab.tab1)
        case "tab2":
            select(MyTab.tab2)
        default: 
            throw DeepLinkingError.invalidDeepLink(deepLink.remainingRoutes.first)
        }
    }
}
```

To then handle incoming deep links - the `.onOpenDeepLink` View-extension can be used. 

**Note:** Make sure to **only** use `.onOpenDeepLink` **once** within your app, to ensure all URL parameters are validated and discarded in case of malformed URLs. Thus, `.onOpenDeepLink` should ideally be used within the `View` owning the initial coordinator of the app. 

```swift
struct ContentView: View {
    @StateObject var coordinator = MyTabCoordinator()
    
    var body: some View {
        CoordinatedTabView(for: coordinator)
            .onOpenDeepLink { deepLink in
                coordinator.handleDeepLink(deepLink)
            }
    }
}
```

**Note:** For your app to be able to open custom `URL`s, a custom URL scheme must be defined first. See more about: [Defining a custom URL scheme for your app](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app).

### Handling URLs in an AppDelegate or SceneDelegate

If an app is not using the SwiftUI App life cycle - deep link URLs can also be handled from within an `AppDelegate` using the `URL`. 

```swift
func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {
    let deepLink = DeepLink(from: url)

    // Handle the DeepLink property accordingly.
}
```

Or alternatively, from inside the `SceneDelegate` by extracting the URL from the `ConnectionOptions`.

```swift
func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
) {
    guard let url = connectionOptions.urlContexts.first?.url {
        return
    }
    
    let deepLink = DeepLink(from: url)
    
    // Handle the URL property accordingly.
}
``` 

### Validity Checking of Deep Link URLs

Since URL schemes offer a potential attack vector into your app, all deep link URL should be properly validated before performing an action. 

In certain scenarios where all deep linkable routes an app offers can't be checked from within the first entry point of a deep link (e.g. where `.onOpenDeepLink` is used or within the `AppDelegate` or `SceneDelegate`), the `DeppLinkValidityChecking` protocol can be used.

Using a `TabCoordinator` similar to the one from the [Example project](./Example), this could look the following: 

```swift
struct ContentView: View {
    @StateObject private var coordinator = TabCoordinator()
    
    var body: some View {
        CoordinatedTabView(for: coordinator)
            .onOpenDeepLink { deepLink in
                // The DeepLink property is checked for validity.
                // This is done using a copy of the deep link, since the original deep link is used to handle the deep link.
                guard TabCoordinator.canHandleDeepLink(deepLink.copy()) else {
                    deepLinkingError = DeepLinkingError.invalidDeepLink(deepLink)
                    return
                }
                // The DeepLink property is handled only if it is valid.
                try? coordinator.handleDeepLink(deepLink)
            }
    }
}
```

The `TabCoordinator` must conform to `DeepLinkValidityChecking` and provide the static `canHandleDeepLink` function. 

**Note:** The implementation logic of `canHandleDeepLink` is heavily tied to your app's business logic and depends on which routes can be presented on which.

```swift
extension TabCoordinator: DeepLinkValidityChecking {
    static func canHandleDeepLink(_ deepLink: DeepLink) -> Bool {
        guard let firstRoute = deepLink.remainingRoutes.first else {
            return false
        }
        
        if firstRoute == "tab1" {
            deepLink.remainingRoutes.removeFirst()
            return HomeCoordinator.canHandleDeepLink(deepLink)
        } else {
            return firstRoute == "tab2" && deepLink.remainingRoutes.count == 1
        }
    }
}
```

**Note:** If an app offers only a handful of deep linkable routes, adopting `DeppLinkValidityChecking` doesn't make much sense. In such cases the opened URL can be checked against all available deep linkable routes.

## Example Project

An example Xcode project showcasing different use-cases of the `Coordinator`-package can be found [here](./Example).

### Features

- nesting of coordinators (including deep linking)
- pushing one coordinator onto a previous coordinator's stack
- coordinators managing a stack & modal presentation at once 

