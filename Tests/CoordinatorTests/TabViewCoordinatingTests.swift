//
//  TabViewCoordinatingTests.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 21.04.25.
//

import Testing
import SwiftUI

@testable import Coordinator

@MainActor
@Suite("Tab View Coordinator Tests") struct TabViewCoordinatingTests {
        
    // - MARK: Select Tab Tests
    
    @Test func testSelectTabSuccess() {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockTabViewCoordinator(selectedTab: .route1)
        
        // WHEN: A new tab is selected.
        let newTab = MockTabRoute.route3
        sut.select(newTab)
        
        // THEN: The new tab is expected to be the SUT's selected tab.
        #expect(sut.selectedTab == newTab)
    }
    
    @Test func testSelectTabError() {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockTabViewCoordinator(selectedTab: .route1, tabs: [.route1, .route2])
        
        // WHEN: A new tab is selected which is not in the SUT's tabs.
        let newTab = MockTabRoute.route3
        sut.select(newTab)
        
        // THEN: The new tab is expected to be the SUT's selected tab.
        #expect(sut.selectedTab != newTab)
        
        // AND: The SUT's initial tab is still selected.
        #expect(sut.selectedTab == .route1)
    }
}

// - MARK: MockTabViewCoordinator

final class MockTabViewCoordinator: TabViewCoordinating {

    let id: String = "MockTabViewCoordinator"
    let tabs: [MockTabRoute]

    var selectedTab: MockTabRoute
    
    /// Initializes a `MockTabViewCoordinator`.
    /// - Parameters:
    ///   - selectedTab: The coordinator's initial route.
    ///   - tabs: The coordinator's tabs.
    init(selectedTab: MockTabRoute = .route1, tabs: [MockTabRoute] = MockTabRoute.allCases) {
        self.selectedTab = selectedTab
        self.tabs = tabs
    }
    
    static nonisolated func == (lhs: MockTabViewCoordinator, rhs: MockTabViewCoordinator) -> Bool {
        lhs.id == rhs.id
    }
}

// - MARK: MockTabRoute

enum MockTabRoute: String, TabRoutable, CaseIterable {
    case route1
    case route2
    case route3
    case route4
    case route5
    
    var id: String { self.rawValue }

    var view: some View {
        EmptyView()
    }
    
    var label: Label<Text, Image> {
        Label("title", image: "")
    }
}
