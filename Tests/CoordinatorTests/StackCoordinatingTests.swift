//
//  StackCoordinatingTests.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

// TODO: Review:
// 1. `SharedPathManaging` no longer has an `initialRoute`
// 2. Cannot compare array of `Routable` types to `NavigationPath`

import Testing
import SwiftUI

@testable import Coordinator

@MainActor
@Suite("Stack Coordinating Tests") struct StackCoordinatingTests {

    // - MARK: Initialization Tests
    
    @Test func testInit() {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockStackCoordinator()
        
        // WHEN: A root coordinator is initialized with the SUT.
        let root = SharedPathManager(coordinator: sut)

        // THEN: The SUT's root is set.
        #expect(sut.root != nil, "Root is expected to be non-nil")
        #expect(sut.root is SharedPathManager<MockRoute>, "Root is expected to have type SharedPathManager")
        #expect(sut.root?.initialRoute.hashValue == root.initialRoute.hashValue, "Initial routes are expected to match")
    }
    
    @Test func testInitPath() {
        // GIVEN: An initialized coordinator (SUT) with an initial path.
        let path = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: path)

        // WHEN: A root coordinator is initialized with the SUT.
        let root = SharedPathManager(coordinator: sut)

        // THEN: The root coordinator's path matches the SUT's path.
        #expect(sut.presentedRoutes == root.path, "SUT and root path's are expected to be equal")
        #expect(sut.root?.initialRoute.hashValue == root.initialRoute.hashValue, "Initial routes are expected to match")
    }
    
    // - MARK: Push Coordinating Tests

    @Test func testPushCoordinatorSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = SharedPathManager(coordinator: sut)

        // WHEN: A child coordinator is pushed.
        let child = MockStackCoordinator(initialRoute: .route5)
        sut.pushCoordinator(child)

        // THEN: The child's initial route is added to the root's path.
        #expect(root.path.count == 1, "Root's path is expected to contain one element")
        
        // AND: The child's root is non-nil.
        #expect(child.root != nil, "Child's root is expected to be non-nil")
    }
    
    @Test func testPushCoordinatorError() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()

        // WHEN: A child coordinator is pushed.
        let child = MockStackCoordinator(initialRoute: .route5)
        sut.pushCoordinator(child)

        // THEN: The child's root is still nil.
        #expect(child.root == nil, "Child's root is expected to be nil")
    }
    
    // - MARK: Push Route Tests
    
    @Test func testPushRouteSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = SharedPathManager(coordinator: sut)

        // WHEN: A route is pushed.
        let route = MockRoute.route2
        sut.pushRoute(route)

        // THEN: The SUT's path contains the pushed route.
        #expect(sut.presentedRoutes.count == 1, "SUT path is expected to have one element")

        // AND: The root coordinator's path contains the pushed route.
        #expect(root.path.count == 1, "Root path is expected to have one element")
    }
    
    @Test func testPushRouteError() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()
        let oldPath = sut.presentedRoutes

        // WHEN: A route is pushed.
        sut.pushRoute(MockRoute.route2)

        // THEN: The SUT's path is expected to not change.
        #expect(sut.presentedRoutes == oldPath, "SUT path is expected to equal the old path")
    }
    
    // - MARK: Pop Route Tests
    
    @Test func testPopRouteSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let path = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: path)
        let root = SharedPathManager(coordinator: sut)
        #expect(sut.presentedRoutes == path, "SUT path is expected to equal the initial path")
        #expect(root.path == path, "Root path is expected to equal the initial path")
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The paths contain one route less.
        #expect(sut.presentedRoutes.count == 1, "SUT path is expected to have one element")
        #expect(root.path.count == 1, "Root path is expected to have one element")
        
        // AND: The paths are still equal
        #expect(root.path == sut.presentedRoutes, "Root path is expected to match the SUT's path")
    }
    
    @Test func testPopRouteErrorEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator without an initial path.
        let sut = MockStackCoordinator()
        let root = SharedPathManager(coordinator: sut)

        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The paths are expected to be empty.
        #expect(sut.presentedRoutes.isEmpty, "SUT path is expected to be empty")
        #expect(root.path.isEmpty, "Root path is expected to be empty")
    }
    
    @Test func testPopRouteErrorNilRoot() {
        // GIVEN: An initialized coordinator (SUT) with an initial path.
        let path = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: path)

        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.presentedRoutes == path, "The SUT's path is expected to equal the initial path")
    }
    
    // - MARK: PopToRoot Tests
    
    @Test func testPopToRootSuccessNonEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator with an initial path.
        let path = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: path)
        let root = SharedPathManager(coordinator: sut)

        // WHEN: The SUT pop to root.
        sut.popToInitialRoute()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.presentedRoutes.isEmpty, "The SUT's path is expected to be empty")
        
        // AND: The SUT's path equals the root's path.
        #expect(sut.presentedRoutes == root.path, "The SUT path and root path are expected to be equal")
    }
    
    @Test func testPopToRootSuccessEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator without an initial path.
        let sut = MockStackCoordinator()
        let root = SharedPathManager(coordinator: sut)

        // WHEN: The SUT pop to root.
        sut.popToInitialRoute()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.presentedRoutes.isEmpty, "The SUT's path is expected to be empty")

        // AND: The SUT's path equals the root's path.
        #expect(sut.presentedRoutes == root.path, "The SUT path and root path are expected to be equal")
    }
    
    @Test func testPopToRootError() {
        // GIVEN: An initialized coordinator (SUT) with an initial path.
        let path = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: path)

        // WHEN: The SUT pop to root.
        sut.popToInitialRoute()
        
        // THEN: The SUT's path is expected equal the initial path.
        #expect(sut.presentedRoutes == path, "The SUT's path is expected to equal the initial path")
    }
}

// - MARK: MockStackCoordinator

final class MockStackCoordinator: StackCoordinating {

    let id: String = "MockStackCoordinator"
    let initialRoute: MockRoute
    weak var root: (any SharedPathManaging)?
    var presentedRoutes: [MockRoute]

    /// Initializes a `MockStackCoordinator`.
    /// - Parameters:
    ///   - initialRoute: The coordinator's initial route.
    ///   - path: The coordinator's initial path.
    init(initialRoute: MockRoute = .route1, presentedRoutes: [MockRoute] = []) {
        self.initialRoute = initialRoute
        self.presentedRoutes = presentedRoutes
    }
}

// - MARK: MockRoute

enum MockRoute: String, Routable {
    case route1
    case route2
    case route3
    case route4
    case route5

    var id: String { self.rawValue }

    var view: some View {
        EmptyView()
    }
}
