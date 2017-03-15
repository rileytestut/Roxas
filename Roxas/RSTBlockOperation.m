//
//  RSTBlockOperation.m
//  Roxas
//
//  Created by Riley Testut on 2/20/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTBlockOperation.h"
#import "RSTOperation_Subclasses.h"

@interface RSTBlockOperation ()

@property (copy, nonatomic, readwrite) void (^executionBlock)(__weak RSTBlockOperation *);

@end

@implementation RSTBlockOperation

- (instancetype)initWithExecutionBlock:(void (^)(__weak RSTBlockOperation * _Nonnull))executionBlock
{
    self = [super init];
    if (self)
    {
        _executionBlock = [executionBlock copy];
    }
    
    return self;
}

+ (instancetype)blockOperationWithExecutionBlock:(void (^)(__weak RSTBlockOperation * _Nonnull))executionBlock
{
    RSTBlockOperation *operation = [[RSTBlockOperation alloc] initWithExecutionBlock:executionBlock];
    return operation;
}

- (void)main
{
    self.executionBlock(self);
}

@end
