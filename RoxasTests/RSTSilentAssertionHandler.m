//
//  RSTSilentAssertionHandler.m
//  Roxas
//
//  Created by Riley Testut on 1/13/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTSilentAssertionHandler.h"

@implementation RSTSilentAssertionHandler

+ (void)enable
{
    RSTSilentAssertionHandler *assertionHandler = [[RSTSilentAssertionHandler alloc] init];
    [[[NSThread currentThread] threadDictionary] setValue:assertionHandler forKey:NSAssertionHandlerKey];
}

+ (void)disable
{
    [[[NSThread currentThread] threadDictionary] setValue:nil forKey:NSAssertionHandlerKey];
}

- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
{
    // Do nothing
}

- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
{
    // Do nothing
}

@end
