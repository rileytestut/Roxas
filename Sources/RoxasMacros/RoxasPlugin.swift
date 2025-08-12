//
//  RoxasPlugin.swift
//  Roxas
//
//  Created by Riley Testut on 7/30/25.
//  Copyright © 2025 Riley Testut. All rights reserved.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct RoxasPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
    ]
}
