//
//  DeepLinkingTests.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 05.05.25.
//

import Testing
import Foundation

@testable import Coordinator

@Suite("URL remaining Deep Link Routes tests")
struct URLRemainingRoutesTests {
    
    @Test
    func testURLWithHostAndPath() {
        let url = URL(string: "https://example.com/foo/bar")!
        #expect(url.remainingRoutes() == ["example.com", "foo", "bar"])
    }
    
    @Test
    func testURLWithOnlyHost() {
        let url = URL(string: "https://example.com")!
        #expect(url.remainingRoutes() == ["example.com"])
    }
    
    @Test
    func testURLWithTrailingSlash() {
        let url = URL(string: "https://example.com/foo/bar/")!
        #expect(url.remainingRoutes() == ["example.com", "foo", "bar"])
    }

    @Test
    func testURLWithoutHost() {
        let url = URL(string: "/foo/bar")!
        #expect(url.remainingRoutes() == ["foo", "bar"])
    }
    
    @Test
    func testURLWithQueryParameters() {
        let url = URL(string: "https://example.com/foo/bar?user=123&debug=true")!
        #expect(url.remainingRoutes() == ["example.com", "foo", "bar"])
    }
    
    @Test
    func testFileURL() {
        let url = URL(fileURLWithPath: "/Users/john/Documents/file.txt")
        #expect(url.remainingRoutes() == ["Users", "john", "Documents", "file.txt"])
    }
}

// - MARK: Remaining Routes With Args

@Suite("URL remaining Deep Link Routes with Query Args tests")
struct URLRemainingRoutesWithArgsTests {
    
    @Test
    func testURLWithHostAndPath() {
        let url = URL(string: "https://example.com/foo/bar")
        #expect(url?.remainingRoutesWithArgs() == ["example.com", "foo", "bar"])
    }
    
    @Test
    func testURLWithOnlyHost() {
        let url = URL(string: "https://example.com")
        #expect(url?.remainingRoutesWithArgs() == ["example.com"])
    }

    @Test
    func testURLWithTrailingSlash() {
        let url = URL(string: "https://example.com/foo/bar/")
        #expect(url?.remainingRoutesWithArgs() == ["example.com", "foo", "bar", ""])
    }

    @Test
    func testURLWithQueryParameters() {
        let url = URL(string: "https://example.com/foo/bar?user=123&debug=true")
        #expect(url?.remainingRoutesWithArgs() == ["example.com", "foo", "bar?user=123&debug=true"])
    }

    @Test
    func testURLWithoutScheme() {
        let url = URL(string: "/foo/bar")
        #expect(url?.remainingRoutesWithArgs() == ["", "foo", "bar"])
    }

    @Test
    func testFileURL() {
        let url = URL(fileURLWithPath: "/Users/john/Documents/file.txt")
        #expect(url.remainingRoutesWithArgs() == ["", "Users", "john", "Documents", "file.txt"])
    }
}
