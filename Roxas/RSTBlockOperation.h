//
//  RSTBlockOperation.h
//  Roxas
//
//  Created by Riley Testut on 2/20/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTOperation.h"

NS_ASSUME_NONNULL_BEGIN

// Similar to NSBlockOperation, but passes a reference to itself into executionBlock.
// This allows the code inside executionBlock to determine whether the operation has been cancelled,
// without resulting in a strong reference cycle.
@interface RSTBlockOperation : RSTOperation

@property (copy, nonatomic, readonly) void (^executionBlock)(__weak RSTBlockOperation *);

+ (instancetype)blockOperationWithExecutionBlock:(void (^)(__weak RSTBlockOperation *))executionBlock;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
