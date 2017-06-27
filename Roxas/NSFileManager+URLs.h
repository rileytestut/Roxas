//
//  NSFileManager+URLs.h
//  Roxas
//
//  Created by Riley Testut on 12/21/14.
//  Copyright (c) 2014 Riley Testut. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (URLs)

@property (readonly, copy) NSURL *documentsDirectory;
@property (readonly, copy) NSURL *libraryDirectory;
@property (readonly, copy) NSURL *applicationSupportDirectory;
@property (readonly, copy) NSURL *cachesDirectory;

- (NSURL *)uniqueTemporaryURL;

// Automatically removes item at temporaryURL upon returning from block. Synchronous.
- (void)prepareTemporaryURL:(void(^)(NSURL *temporaryURL))fileHandlingBlock;

@end

NS_ASSUME_NONNULL_END
