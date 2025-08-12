//
//  Roxas.swift
//  Roxas
//
//  Created by Riley Testut on 7/30/25.
//  Copyright © 2025 Riley Testut. All rights reserved.
//

@attached(member, names: named(errorTitle), named(errorFailure), named(sourceFile), named(sourceLine))
@attached(extension, conformances: RSTLocalizedError)
public macro RSTLocalizedError() = #externalMacro(module: "RoxasMacros", type: "RSTLocalizedErrorMacro")
