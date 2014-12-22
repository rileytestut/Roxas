//
//  NSFileManager+TemporaryFiles.m
//  Roxas
//
//  Created by Riley Testut on 12/21/14.
//  Copyright (c) 2014 Riley Testut. All rights reserved.
//

#import "NSFileManager+TemporaryFiles.h"

@implementation NSFileManager (TemporaryFiles)

+ (NSURL *)uniqueTemporaryURL
{
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString *uniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
    
    return [temporaryDirectoryURL URLByAppendingPathComponent:uniqueIdentifier];
}

- (void)prepareTemporaryURL:(void (^)(NSURL *))fileHandlingBlock
{
    if (fileHandlingBlock == nil)
    {
        return;
    }
    
    NSURL *temporaryURL = [NSFileManager uniqueTemporaryURL];
    
    fileHandlingBlock(temporaryURL);
    
    NSError *error = nil;
    if (![self removeItemAtURL:temporaryURL error:&error])
    {
        ELog(error);
    }
}

@end
