//
//  NavPath.swift
//  Coordinator
//
//  Created by Joseph Grabinger on 22.02.25.
//

import Foundation

public struct NavPath {
    
    // MARK: - Public Properties
    
    var value: [AnyRoutable]
    
    var prefixCount: Int
    
    var count: Int {
        value.count
    }
    
    // MARK: - Initialization
    
    init(_ value: [AnyRoutable] = []) {
        self.value = value
        self.prefixCount = value.count
    }
    
    // MARK: - Public Methods

    mutating func append(_ value: AnyRoutable) {
        self.value.append(value)
        self.prefixCount += 1
    }
    
    mutating func append(_ path: NavPath) {
        self.value.append(contentsOf: path.value)
    }
    
    mutating func remove(_ path: NavPath) {
        self.value.removeLast(path.count)
        self.prefixCount -= 1
    }
    
    mutating func removeLast(_ k: Int = 1) {
        self.value.removeLast(k)
        self.prefixCount -= k
    }
}
