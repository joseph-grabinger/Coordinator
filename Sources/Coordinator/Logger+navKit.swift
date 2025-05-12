//
//  Logger+navKit.swift
//  Coordinator
//
//  Created by Adam Kerenyi on 12.05.25.
//

import OSLog

extension Logger {

    /// Logger used by the **NavKit** package.
    static let navKit = Logger(subsystem: "de.dkb.NavKit", category: "default")
}
