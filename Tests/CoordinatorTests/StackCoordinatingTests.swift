//
//  StackCoordinatingTests.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import Testing
import Foundation
import SwiftUI

@testable import Coordinator

@MainActor
@Suite("Stack Coordinator Tests") struct StackCoordinatingTests {

    // - MARK: Initialization Tests
    
    @Test func testInit() async {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockStackCoordinator()
        
        // WHEN: A root coordinator is initialized with the SUT.
        let root = RootStackCoordinator(coordinator: sut)
        
        // THEN: The SUT's root is set.
        #expect(sut.root != nil, "Root is expected to be non-nil")
        #expect(sut.root is RootStackCoordinator<MockRoute>, "Root is expected to have type RootStackCoordinator")
        #expect(sut.root?.initialRoute.hashValue == root.initialRoute.hashValue, "Initial routes are expected to match")
    }
    
    @Test func testInitPath() async {
        // GIVEN: An initialized coordinator (SUT) with an initial path.
        let path = NavigationPath([MockRoute.route1, MockRoute.route2])
        let sut = MockStackCoordinator(path: path)
        
        // WHEN: A root coordinator is initialized with the SUT.
        let root = RootStackCoordinator(coordinator: sut)
        
        // THEN: The root coordinator's path matches the SUT's path.
        #expect(sut.path == root.path, "SUT and root path's are expected to be equal")
        #expect(sut.root?.initialRoute.hashValue == root.initialRoute.hashValue, "Initial routes are expected to match")
    }
    
    // - MARK: Push Route Tests
    
    @Test func testPushRouteSuccess() async {
        // GIVEN: An initialized coordinator (sut) & root coordinator.
        let sut = MockStackCoordinator()
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: A route is pushed.
        let route = MockRoute.route2
        sut.push(route)
        
        // THEN: The SUT's path contains the pushed route.
        #expect(sut.path.count == 1, "SUT path is expected to have one element")
        
        // AND: The root coordinator's path contains the pushed route.
        #expect(root.path.count == 1, "Root path is expected to have one element")
    }
    
    @Test func testPushRouteError() async {
        // GIVEN: An initialized coordinator (sut) whose root is nil.
        let sut = MockStackCoordinator()
        #expect(sut.root == nil)
        let oldPath = sut.path
        
        // WHEN: A route is pushed.
        sut.push(MockRoute.route2)
        
        // THEN: The SUT's path is expected to not change.
        #expect(sut.path == oldPath, "SUT path is expected to equal the old path")
    }
    
    // - MARK: Pop Route Tests
    
    @Test func testPopRouteSuccess() async {
        // GIVEN: An initialized coordinator (sut) & root coordinator.
        let path = NavigationPath([MockRoute.route1, MockRoute.route2])
        let sut = MockStackCoordinator(path: path)
        let root = RootStackCoordinator(coordinator: sut)
        #expect(sut.path == path, "SUT path is expected to equal the initial path")
        #expect(root.path == path, "Root path is expected to equal the initial path")
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The paths contain one route less.
        #expect(sut.path.count == 1, "SUT path is expected to have one element")
        #expect(root.path.count == 1, "Root path is expected to have one element")
        
        // AND: The paths are still equal
        #expect(root.path == sut.path, "Root path is expected to match the SUT's path")
    }
    
    @Test func testPopRouteErrorEmptyPath() async {
        // GIVEN: An initialized coordinator (sut) & root coordinator without an initial path.
        let sut = MockStackCoordinator()
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The paths are expected to be empty.
        #expect(sut.path.isEmpty, "SUT path is expected to be empty")
        #expect(root.path.isEmpty, "Root path is expected to be empty")
    }
    
    @Test func testPopRouteErrorNilRoot() async {
        // GIVEN: An initialized coordinator (sut) with an initial path.
        let path = NavigationPath([MockRoute.route1, MockRoute.route2])
        let sut = MockStackCoordinator(path: path)
        
        // WHEN: A route is popped.
        sut.pop()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.path == path, "The SUT's path is expected to equal the initial path")
    }
    
    // - MARK: PopToRoot Tests
    
    @Test func testPopToRootSuccessNonEmptyPath() async {
        // GIVEN: An initialized coordinator (sut) & root coordinator with an initial path.
        let path = NavigationPath([MockRoute.route1, MockRoute.route2])
        let sut = MockStackCoordinator(path: path)
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: The SUT pop to root.
        sut.popToRoot()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.path.isEmpty, "The SUT's path is expected to be empty")
        
        // AND: The SUT's path equals the root's path.
        #expect(sut.path == root.path, "The SUT path and root path are expected to be equal")
    }
    
    @Test func testPopToRootSuccessEmptyPath() async {
        // GIVEN: An initialized coordinator (sut) & root coordinator without an initial path.
        let sut = MockStackCoordinator()
        let root = RootStackCoordinator(coordinator: sut)
        
        // WHEN: The SUT pop to root.
        sut.popToRoot()
        
        // THEN: The SUT's path is expected not to change.
        #expect(sut.path.isEmpty, "The SUT's path is expected to be empty")
        
        // AND: The SUT's path equals the root's path.
        #expect(sut.path == root.path, "The SUT path and root path are expected to be equal")
    }
    
    @Test func testPopToRootError() async {
        // GIVEN: An initialized coordinator with an initial path.
        let path = NavigationPath([MockRoute.route1, MockRoute.route2])
        let sut = MockStackCoordinator(path: path)
        
        // WHEN: The SUT pop to root.
        sut.popToRoot()
        
        // THEN: The SUT's path is expected equal the initial path.
        #expect(sut.path == path, "The SUT's path is expected to equal the initial path")
    }
}

// - MARK: MockStackCoordinator

final class MockStackCoordinator: StackCoordinating {
    lazy var initialRoute = MockRoute.route1
    
    var path: NavigationPath
    var root: (any StackCoordinating)?
    
    @Published var sheet: MockRoute?
    @Published var fullScreenCover: MockRoute?
    
    init(path: NavigationPath = NavigationPath()) {
        self.path = path
    }
    
    static nonisolated func == (lhs: MockStackCoordinator, rhs: MockStackCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}

// - MARK: MockRoute

enum MockRoute: Routable {
    nonisolated var id: UUID { UUID() }
    
    case route1
    case route2
    case route3
    case route4
    case route5
    
    var body: some View {
        EmptyView()
    }
}
