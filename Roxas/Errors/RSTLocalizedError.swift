//
//  RSTLocalizedError.swift
//  AltStore
//
//  Created by Riley Testut on 10/14/22.
//  Copyright © 2022 Riley Testut. All rights reserved.
//

import Foundation

public protocol RSTLocalizedError<Code>: LocalizedError, CustomNSError, CustomStringConvertible
{
    associatedtype Code: RSTErrorCode

    var code: Code { get }
    var errorFailureReason: String { get }
    
    var errorTitle: String? { get set }
    var errorFailure: String? { get set }
    
    var sourceFile: String? { get set }
    var sourceLine: Int? { get set }
}

public extension RSTLocalizedError
{
    var localizedErrorCode: String {
        let nsError = self as NSError
        let localizedErrorCode = String(format: NSLocalizedString("%@ %@", comment: ""), nsError.domain, nsError.code)
        return localizedErrorCode
    }
    
    // Allows us to initialize errors with localizedTitle + localizedFailure
    // while still using the error's custom initializer at callsite.
    init(_ error: Self, localizedTitle: String? = nil, localizedFailure: String? = nil, sourceFile: String? = #fileID, sourceLine: Int? = #line)
    {
        self = error
        
        if let localizedTitle
        {
            self.errorTitle = localizedTitle
        }
        
        if let localizedFailure
        {
            self.errorFailure = localizedFailure
        }
        
        if let sourceFile
        {
            self.sourceFile = sourceFile
        }
        
        if let sourceLine
        {
            self.sourceLine = sourceLine
        }
    }
}

public protocol RSTErrorCode: RawRepresentable where RawValue == Int
{
    associatedtype Error: RSTLocalizedError where Error.Code == Self
    
    static var errorDomain: String { get } // Optional
}

public protocol RSTErrorEnum: RSTErrorCode
{
    associatedtype Error = DefaultLocalizedError<Self>
    
    var errorFailureReason: String { get }
}

/// LocalizedError & CustomNSError & CustomStringConvertible
public extension RSTLocalizedError
{
    var errorCode: Int { self.code.rawValue }
    
    var errorDescription: String? {
        guard (self as NSError).localizedFailure == nil else {
            // Error has localizedFailure, so return nil to construct localizedDescription from it + localizedFailureReason.
            return nil
        }
        
        // Otherwise, return failureReason for localizedDescription to avoid system prepending "Operation Failed" message.
        return self.failureReason
    }
    
    var failureReason: String? {
        return self.errorFailureReason
    }
    
    var errorUserInfo: [String : Any] {
        var userInfo: [String: Any?] = [
            NSLocalizedFailureErrorKey: self.errorFailure,
            RSTLocalizedTitleErrorKey: self.errorTitle,
            RSTSourceFileErrorKey: self.sourceFile,
            RSTSourceLineErrorKey: self.sourceLine,
        ]
        
        userInfo.merge(self.userInfoValues) { (_, new) in new }
        
        return userInfo.compactMapValues { $0 }
    }
    
    var description: String {
        let description = "\(self.localizedErrorCode) “\(self.localizedDescription)”"
        return description
    }
}

/// Default Implementations
public extension RSTLocalizedError where Code: RSTErrorEnum
{
    static var errorDomain: String {
        return Code.errorDomain
    }
    
    // ALTErrorEnum Codes provide their failure reason directly.
    var errorFailureReason: String {
        return self.code.errorFailureReason
    }
}

/// Default Implementations
public extension RSTErrorCode
{
    static var errorDomain: String {
        let typeName = String(reflecting: Self.self) // "\(Self.self)" doesn't include module name, but String(reflecting:) does.
        let errorDomain = typeName.replacingOccurrences(of: "ErrorCode", with: "Error").replacingOccurrences(of: "Error.Code", with: "Error")
        return errorDomain
    }
}

private extension RSTLocalizedError
{
    var userInfoValues: [(String, Any)] {
        let userInfoValues = Mirror(reflecting: self).children.compactMap { (label, value) -> (String, Any)? in
            guard let userInfoValue = value as? any UserInfoValueProtocol,
                  let key: any StringProtocol = userInfoValue.key ?? label?.dropFirst() // Remove leading underscore
            else { return nil }

            return (String(key), userInfoValue.wrappedValue)
        }
        
        return userInfoValues
    }
}

public struct DefaultLocalizedError<Code: RSTErrorEnum>: RSTLocalizedError
{
    public let code: Code

    public var errorTitle: String?
    public var errorFailure: String?
    public var sourceFile: String?
    public var sourceLine: Int?

    public init(_ code: Code, localizedTitle: String? = nil, localizedFailure: String? = nil, sourceFile: String? = #fileID, sourceLine: Int? = #line)
    {
        self.code = code
        self.errorTitle = localizedTitle
        self.errorFailure = localizedFailure
        self.sourceFile = sourceFile
        self.sourceLine = sourceLine
    }
}

/// Custom Operators
/// These allow us to pattern match RSTErrorCodes against arbitrary errors via ~ prefix.
prefix operator ~
public prefix func ~<Code: RSTErrorCode>(expression: Code) -> NSError
{
    let nsError = NSError(domain: Code.errorDomain, code: expression.rawValue)
    return nsError
}

public func ~=(pattern: any Swift.Error, value: any Swift.Error) -> Bool
{
    let isMatch = pattern._domain == value._domain && pattern._code == value._code
    return isMatch
}

// These operators *should* allow us to match RSTErrorCodes against arbitrary errors,
// but they don't work as of iOS 16.1 and Swift 5.7.
//
//public func ~=<Error: RSTLocalizedError>(pattern: Error, value: Swift.Error) -> Bool
//{
//    let isMatch = pattern._domain == value._domain && pattern._code == value._code
//    return isMatch
//}
//
//public func ~=<Code: RSTErrorCode>(pattern: Code, value: Swift.Error) -> Bool
//{
//    let isMatch = Code.errorDomain == value._domain && pattern.rawValue == value._code
//    return isMatch
//}
