//
//  RSTLocalizedErrorMacro.swift
//  Roxas
//
//  Created by Riley Testut on 7/30/25.
//  Copyright © 2025 Riley Testut. All rights reserved.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RSTLocalizedErrorMacro: MemberMacro, ExtensionMacro
{
    // Adds required properties
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return [
            """
            public var errorTitle: String?
            public var errorFailure: String?
            public var sourceFile: String?
            public var sourceLine: Int?
            """
        ]
    }
    
    // Adds protocol conformance via extension
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let typeName = declaration.asProtocol(NamedDeclSyntax.self)?.name.text ??
                declaration.as(StructDeclSyntax.self)?.name.text ??
                declaration.as(ClassDeclSyntax.self)?.name.text else {
            return []
        }
        
        return [
            try ExtensionDeclSyntax("extension \(raw: typeName): RSTLocalizedError {}")
        ]
    }
}
