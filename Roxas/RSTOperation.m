//
//  RSTOperation.m
//  Roxas
//
//  Created by Riley Testut on 3/14/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTOperation.h"
#import "RSTOperation_Subclasses.h"

@implementation RSTOperation

- (void)start
{
    if (![self isAsynchronous])
    {
        return [super start];
    }
    
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
    else
    {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }    
}

- (void)finish
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting
{
    if (![self isAsynchronous])
    {
        return [super isExecuting];
    }
    
    return _isExecuting;
}

- (BOOL)isFinished
{
    if (![self isAsynchronous])
    {
        return [super isFinished];
    }
    
    return _isFinished;
}

@end
