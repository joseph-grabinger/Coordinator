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
    
    @Test func initialization() throws {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockStackCoordinator()
        
        // WHEN: A root coordinator is initialized with the SUT.
        let root = NavigationPathManager(coordinator: sut)
        
        // THEN: The SUT's root is set.
        #expect(sut.root != nil, "Root is expected to be non-nil")
        let sutRoot = try #require(sut.root as? NavigationPathManager<MockRoute>, "Root is expected to have type RootStackCoordinator")
        #expect(sutRoot.initialRoute == root.initialRoute, "Initial routes are expected to match")
    }
    
    // - MARK: Push Coordinator Tests

    @Test func pushCoordinatorSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)

        // WHEN: A child coordinator is pushed.
        let child = MockStackCoordinator(initialRoute: .route5)
        sut.push(coordinator: child)
        
        // THEN: The child's initial route is added to the root's path.
        #expect(root.path.count == 1, "Root's path is expected to contain one element")
        
        // AND: The child's root is non-nil.
        #expect(child.root != nil, "Child's root is expected to be non-nil")
    }
    
    @Test func pushCoordinatorError() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()

        // WHEN: A child coordinator is pushed.
        let child = MockStackCoordinator(initialRoute: .route5)
        sut.push(coordinator: child)
        
        // THEN: The child's root is still nil.
        #expect(child.root == nil, "Child's root is expected to be nil")
    }
    
    // - MARK: Push Route Tests
    
    @Test func pushRouteSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)
        
        // WHEN: A route is pushed.
        let route = MockRoute.route2
        sut.push(route: route)
        
        // THEN: The root coordinator's path contains the pushed route.
        #expect(root.path.count == 1, "Root path is expected to have one element")
    }
    
    @Test func pushRouteError() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()
        
        // WHEN: A route is pushed.
        sut.push(route: MockRoute.route2)
        
        // THEN: It does not crash.
        #expect(true, "No exception was thrown")
    }
    
    // - MARK: Pop Route Tests
    
    @Test func popRouteSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)
        
        // AND: A route is pushed.
        sut.push(route: .route2)
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The paths contain one route less.
        #expect(root.path.count == 0, "Root path is expected to be empty")
    }
    
    @Test func popRouteErrorEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator without a pushed route.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The root path is expected to be empty.
        #expect(root.path.isEmpty, "Root path is expected to be empty")
        
        // AND: No exception was thrown.
        #expect(true, "No exception was thrown")
    }
    
    @Test func popRouteErrorNilRoot() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: It does not crash.
        #expect(true, "No exception was thrown")
    }
    
    // - MARK: PopToPreviousCoordinator Tests
    
    @Test func popToPreviousCoordinatorSuccess() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)
        
        // AND: A route is pushed.
        sut.push(route: .route2)
        #expect(root.path.count == 1)
        
        // AND: A second coordinator is pushed.
        let coordinator = MockStackCoordinator()
        sut.push(coordinator: coordinator)
        #expect(root.path.count == 2)
        
        // WHEN: Popped to the previous coordinator.
        coordinator.popToPreviousCoordinator()
        
        // THEN: The previous coordinator is presented.
        #expect(root.path.count == 1, "Root path is expected to have one element")
    }
    
    @Test func popToPreviousCoordinatorErrorNoPreviousCoordinator() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)
        
        // AND: A route is pushed.
        sut.push(route: .route2)
        #expect(root.path.count == 1)
        
        // WHEN: Popped to the previous coordinator.
        sut.popToPreviousCoordinator()
        
        // THEN: The previous coordinator is presented.
        #expect(root.path.count == 1, "Root path is expected to have one element")
    }
    
    @Test func popToPreviousCoordinatorErrorRootNil() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()
        
        // WHEN: Popped to the previous coordinator.
        sut.popToPreviousCoordinator()
        
        // THEN: It does not crash.
        #expect(true, "No exception was thrown")
    }
    
    // - MARK: PopToInitialRoute Tests
    
    @Test func popToInitialRouteSuccess() {
        // GIVEN: An initialized coordinator & root coordinator.
        let coordinator = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: coordinator)
        
        // AND: A routes is pushed.
        coordinator.push(route: .route2)
        #expect(root.path.count == 1)
        
        // WHEN: A second coordinator (SUT) is pushed.
        let sut = MockStackCoordinator()
        coordinator.push(coordinator: sut)
        #expect(root.path.count == 2)

        // AND: The second coordinator  (SUT) has a route pushed.
        sut.push(route: .route3)
        #expect(root.path.count == 3)
        
        // AND: The coordinator pops to the initial route.
        sut.popToInitialRoute()
        
        // THEN: The initial route of the second coordinator is presented.
        #expect(root.path.count == 2)
    }
    
    @Test func popToInitialRouteSuccessEmptyPath() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator without an initial path.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)
        
        // WHEN: The SUT pop to initial route.
        sut.popToInitialRoute()
        
        // THEN: The SUT's path is expected not to change.
        #expect(root.path.isEmpty, "The root's path is expected to be empty")
    }
    
    @Test func popToInitialRouteErrorOnRoot() {
        // GIVEN: An initialized coordinator (SUT) & root coordinator.
        let sut = MockStackCoordinator()
        let root = NavigationPathManager(coordinator: sut)
        
        // AND: Routes are pushed.
        sut.push(route: .route2)
        sut.push(route: .route3)
        #expect(root.path.count == 2)
        
        // WHEN: The SUT pop to initial route.
        sut.popToInitialRoute()
        
        // THEN: The SUT's path is expected not to change.
        #expect(root.path.count == 2, "The root's path is expected to remain unchanged")
    }
    
    @Test func popToInitialRouteErrorNilRoot() {
        // GIVEN: An initialized coordinator (SUT) whose root is nil.
        let sut = MockStackCoordinator()
        
        // WHEN: The SUT pop to root.
        sut.popToInitialRoute()
        
        // THEN: It does not crash.
        #expect(true, "No exception was thrown")
    }
    
    
}

// - MARK: MockStackCoordinator

final class MockStackCoordinator: StackCoordinating {
    nonisolated let id = "MockStackCoordinator"

    let initialRoute: MockRoute
    
    weak var root: (any StackNavigating)?

    init(initialRoute: MockRoute = .route1) {
        self.initialRoute = initialRoute
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
