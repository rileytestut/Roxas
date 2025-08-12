//
//  RSTWrappedError.h
//  AltStoreCore
//
//  Created by Riley Testut on 11/28/22.
//  Copyright © 2022 Riley Testut. All rights reserved.
//

#import <Roxas/Roxas.h>

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

RST_EXTERN NSErrorUserInfoKey const RSTLocalizedTitleErrorKey;
RST_EXTERN NSErrorUserInfoKey const RSTSourceFileErrorKey;
RST_EXTERN NSErrorUserInfoKey const RSTSourceLineErrorKey;

// Overrides localizedDescription to check userInfoValueProvider for failure reason
// instead of default behavior which just returns NSLocalizedFailureErrorKey if present.
//
// Must be written in Objective-C for Swift.Error <-> NSError bridging to work correctly.
@interface RSTWrappedError : NSError

@property (copy, nonatomic) NSError *wrappedError;

- (instancetype)initWithError:(NSError *)error userInfo:(NSDictionary<NSString *, id> *)userInfo;

@end

NS_ASSUME_NONNULL_END
