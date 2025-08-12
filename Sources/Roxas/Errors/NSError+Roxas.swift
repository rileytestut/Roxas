//
//  NSError+AltStore.swift
//  AltStore
//
//  Created by Riley Testut on 3/11/20.
//  Copyright © 2020 Riley Testut. All rights reserved.
//

import Foundation

public extension NSError
{
    @objc(rst_localizedFailure)
    var localizedFailure: String? {
        let localizedFailure = (self.userInfo[NSLocalizedFailureErrorKey] as? String) ?? (NSError.userInfoValueProvider(forDomain: self.domain)?(self, NSLocalizedFailureErrorKey) as? String)
        return localizedFailure
    }
    
    @objc(rst_localizedDebugDescription)
    var localizedDebugDescription: String? {
        let debugDescription = (self.userInfo[NSDebugDescriptionErrorKey] as? String) ?? (NSError.userInfoValueProvider(forDomain: self.domain)?(self, NSDebugDescriptionErrorKey) as? String)
        return debugDescription
    }
    
    @objc(rst_localizedTitle)
    var localizedTitle: String? {
        let localizedTitle = self.userInfo[RSTLocalizedTitleErrorKey] as? String
        return localizedTitle
    }
    
    @objc(rst_errorWithLocalizedFailure:)
    func withLocalizedFailure(_ failure: String) -> NSError
    {
        switch self
        {
        case var error as any RSTLocalizedError:
            error.errorFailure = failure
            return error as NSError
            
        default:
            var userInfo = self.userInfo
            userInfo[NSLocalizedFailureErrorKey] = failure
            
            let error = RSTWrappedError(error: self, userInfo: userInfo)
            return error
        }
    }
    
    @objc(rst_errorWithLocalizedTitle:)
    func withLocalizedTitle(_ title: String) -> NSError
    {
        switch self
        {
        case var error as any RSTLocalizedError:
            error.errorTitle = title
            return error as NSError
            
        default:
            var userInfo = self.userInfo
            userInfo[RSTLocalizedTitleErrorKey] = title

            let error = RSTWrappedError(error: self, userInfo: userInfo)
            return error
        }
    }
}
