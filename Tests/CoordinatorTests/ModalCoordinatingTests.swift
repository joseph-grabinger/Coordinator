//
//  ModalCoordinatingTests.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 26.04.25.
//

import Testing
import SwiftUI

@testable import Coordinator

@MainActor
@Suite("Modal Coordinator Tests") struct ModalCoordinatingTests {
    
    // - MARK: Present Modal Tests
    
    @Test func testPresentSheet() {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockModalCoordinator()
        #expect(sut.sheet == nil)

        // WHEN: A new sheet is presented.
        let newSheet = MockModalRoute.route1
        sut.present(newSheet, as: .sheet)
        
        // THEN: The new sheet is expected to be set in the SUT.
        #expect(sut.sheet == newSheet)
    }
    
    @Test func testPresentFullScreenCover() {
        // GIVEN: An initialized coordinator (SUT).
        let sut = MockModalCoordinator()
        #expect(sut.fullScreenCover == nil)
        
        // WHEN: A new fullScreenCover is presented.
        let newFullScreenCover = MockModalRoute.route1
        sut.present(newFullScreenCover, as: .fullScreenCover)
        
        // THEN: The new fullScreenCover is expected to be set in the SUT.
        #expect(sut.fullScreenCover == newFullScreenCover)
    }
    
    // - MARK: Dismiss Modal Tests
    
    @Test func testDismissSheet() {
        // GIVEN: An initialized coordinator (SUT) with a presented sheet.
        let sut = MockModalCoordinator(sheet: .route1)
        
        // WHEN: The sheet is dismissed.
        sut.dismiss(.sheet)
        
        // THEN: The sheet is expected to be nil.
        #expect(sut.sheet == nil)
    }
    
    @Test func testDismissFullScreenCover() {
        // GIVEN: An initialized coordinator (SUT) with a presented fullScreenCover.
        let sut = MockModalCoordinator(fullScreenCover: .route1)
        
        // WHEN: The fullScreenCover is dismissed.
        sut.dismiss(.fullScreenCover)
        
        // THEN: The fullScreenCover is expected to be nil.
        #expect(sut.fullScreenCover == nil)
    }
}

// - MARK: MockModalCoordinator

final class MockModalCoordinator: ModalCoordinating {
    var sheet: MockModalRoute?
    var fullScreenCover: MockModalRoute?
    
    /// Initializes a `MockModalCoordinator`.
    /// - Parameters:
    ///   - sheet: The cooridnator's initial sheet.
    ///   - fullScreenCover: The cooridnator's initial fullScreenCover.
    init(sheet: MockModalRoute? = nil, fullScreenCover: MockModalRoute? = nil) {
        self.sheet = sheet
        self.fullScreenCover = fullScreenCover
    }
}

// - MARK: MockModalRoute

enum MockModalRoute: Int, Routable {
    case route1
    case route2
    
    nonisolated var id: Int { self.rawValue }
    
    var body: some View {
        EmptyView()
    }
}
