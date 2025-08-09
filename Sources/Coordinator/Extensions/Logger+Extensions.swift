//
//  Logger+Extensions.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 12.05.25.
//

import OSLog

extension Logger {

    /// Logger used by the **Coordinator** package.
    static let coordinator = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Coordinator",
        category: "default"
    )
}
