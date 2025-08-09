//
//  StackCoordinatingTests.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import Testing
import SwiftUI

@testable import Coordinator

@MainActor
@Suite("Stack Coordinator Tests") struct StackCoordinatingTests {

    // - MARK: Initialization Tests
    
    @Test func testInit() throws {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockStackCoordinator()
        
        // WHEN: A root coordinator is initialized with the SUT.
        let root = RootStackCoordinator(coordinator: sut)
        
        // THEN: The SUT's root is set.
        #expect(sut.root != nil, "Root is expected to be non-nil")
        let sutRoot = try #require(sut.root as? RootStackCoordinator<MockRoute>, "Root is expected to have type RootStackCoordinator")
        #expect(sutRoot.initialRoute == root.initialRoute, "Initial routes are expected to match")
    }
    
    @Test func testInitPath() throws {
        // GIVEN: An initialized coordinator (SUT) with an initial path.
        let presentedRoutes = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: presentedRoutes)
        
        // WHEN: A root coordinator is initialized with the SUT.
        let root = RootStackCoordinator(coordinator: sut)
        
        // THEN: The root coordinator's path matches the SUT's path.
        let sutRoot = try #require(sut.root as? RootStackCoordinator<MockRoute>, "Root is expected to have type RootStackCoordinator")
        #expect(sut.presentedRoutes.count == root.path.count, "SUT and root presentedRoutes's are expected to be equal")
        #expect(sutRoot.initialRoute == root.initialRoute, "Initial routes are expected to match")
    }
    
    // - MARK: Push Coordinator Tests

    @Test func testPushCoordinatorSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = RootStackCoordinator(coordinator: sut)

        // WHEN: A child coordinator is pushed.
        let child = MockStackCoordinator(initialRoute: .route5)
        sut.push(coordinator: child)
        
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
        sut.push(coordinator: child)
        
        // THEN: The child's root is still nil.
        #expect(child.root == nil, "Child's root is expected to be nil")
    }
    
    // - MARK: Push Route Tests
    
    @Test func testPushRouteSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: A route is pushed.
        let route = MockRoute.route2
        sut.push(route: route)
        
        // THEN: The SUT's presentedRoutes contains the pushed route.
        #expect(sut.presentedRoutes.count == 1, "SUT presentedRoutes is expected to have one element")
        
        // AND: The root coordinator's path contains the pushed route.
        #expect(root.path.count == 1, "Root path is expected to have one element")
    }
    
    @Test func testPushRouteError() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()
        let oldPath = sut.presentedRoutes
        
        // WHEN: A route is pushed.
        sut.push(route: MockRoute.route2)
        
        // THEN: The SUT's path is expected to not change.
        #expect(sut.presentedRoutes == oldPath, "SUT presentedRoutes is expected to equal the old path")
    }
    
    // - MARK: Pop Route Tests
    
    @Test func testPopRouteSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let presentedRoutes = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: presentedRoutes)
        let root = RootStackCoordinator(coordinator: sut)
        #expect(sut.presentedRoutes == presentedRoutes, "SUT presentedRoutes is expected to equal the initial presentedRoutes")
        #expect(root.path.count == presentedRoutes.count, "Root path is expected to equal the initial presentedRoutes")
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The paths contain one route less.
        #expect(sut.presentedRoutes.count == 1, "SUT presentedRoutes is expected to have one element")
        #expect(root.path.count == 1, "Root path is expected to have one element")
        
        // AND: The paths are still equal
        #expect(root.path.count == sut.presentedRoutes.count, "Root path is expected to match the SUT's path")
    }
    
    @Test func testPopRouteErrorEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator without an initial path.
        let sut = MockStackCoordinator()
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The paths are expected to be empty.
        #expect(sut.presentedRoutes.isEmpty, "SUT presentedRoutes is expected to be empty")
        #expect(root.path.isEmpty, "Root path is expected to be empty")
    }
    
    @Test func testPopRouteErrorNilRoot() {
        // GIVEN: An initialized coordinator (SUT) with an initial path.
        let presentedRoutes = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: presentedRoutes)
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.presentedRoutes == presentedRoutes, "The SUT's presentedRoutes is expected to equal the initial presentedRoutes")
    }
    
    // - MARK: PopToRoot Tests
    
    @Test func testPopToRootSuccessNonEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator with an initial path.
        let presentedRoutes = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: presentedRoutes)
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: The SUT pop to root.
        sut.popToRoot()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.presentedRoutes.isEmpty, "The SUT's presentedRoutes is expected to be empty")
        
        // AND: The SUT's path equals the root's path.
        #expect(sut.presentedRoutes.count == root.path.count, "The SUT presentedRoutes and root path are expected to be equal")
    }
    
    @Test func testPopToRootSuccessEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator without an initial path.
        let sut = MockStackCoordinator()
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: The SUT pop to root.
        sut.popToRoot()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.presentedRoutes.isEmpty, "The SUT's presentedRoutes is expected to be empty")
        
        // AND: The SUT's path equals the root's path.
        #expect(sut.presentedRoutes.count == root.path.count, "The SUT presentedRoutes and root path are expected to be equal")
    }
    
    @Test func testPopToRootError() {
        // GIVEN: An initialized coordinator (SUT) with an initial path.
        let presentedRoutes = [MockRoute.route1, MockRoute.route2]
        let sut = MockStackCoordinator(presentedRoutes: presentedRoutes)
        
        // WHEN: The SUT pop to root.
        sut.popToRoot()
        
        // THEN: The SUT's path is expected equal the initial path.
        #expect(sut.presentedRoutes == presentedRoutes, "The SUT's presentedRoutes is expected to equal the initial presentedRoutes")
    }
}

// - MARK: MockStackCoordinator

final class MockStackCoordinator: StackCoordinating {
    nonisolated let id = "MockStackCoordinator"
    
    let initialRoute: MockRoute
    
    var presentedRoutes: [MockRoute]
    
    weak var root: (any RootStackCoordinating)?
    
    /// Initializes a `MockStackCoordinator`.
    /// - Parameters:
    ///   - initialRoute: The coordinator's initial route.
    ///   - path: The coordinator's initial path.
    init(initialRoute: MockRoute = .route1, presentedRoutes: [MockRoute] = [MockRoute]()) {
        self.initialRoute = initialRoute
        self.presentedRoutes = presentedRoutes
    }
}

// - MARK: MockRoute

enum MockRoute: Int, Routable {
    case route1
    case route2
    case route3
    case route4
    case route5
    
    nonisolated var id: Int { self.rawValue }

    var body: some View {
        EmptyView()
    }
}
