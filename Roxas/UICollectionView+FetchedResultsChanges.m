//
//  UICollectionView+FetchedResultsChanges.m
//  Roxas
//
//  Created by Riley Testut on 8/2/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "UICollectionView+FetchedResultsChanges.h"

#import "RSTFetchedResultsChangeOperation.h"

@import ObjectiveC.runtime;

@interface UICollectionView ()

@property (nullable, nonatomic, strong) NSOperationQueue *rst_operationQueue;

@end

@implementation UICollectionView (FetchedResultsChanges)

- (void)rst_beginUpdates
{
    self.rst_operationQueue = [[NSOperationQueue alloc] init];
    self.rst_operationQueue.maxConcurrentOperationCount = 1;
    self.rst_operationQueue.suspended = YES;
}

- (void)rst_endUpdates
{
    [self performBatchUpdates:^{
        [self.rst_operationQueue setSuspended:NO];
        [self.rst_operationQueue waitUntilAllOperationsAreFinished];
    } completion:^(BOOL finished) {
        self.rst_operationQueue = nil;
    }];
}

- (void)rst_addChange:(RSTFetchedResultsChange *)change
{
    RSTFetchedResultsChangeOperation *operation = [[RSTFetchedResultsChangeOperation alloc] initWithChange:change collectionView:self];
    [self.rst_operationQueue addOperation:operation];
}

#pragma mark - Getters/Setters -

- (NSOperationQueue *)rst_operationQueue
{
    return objc_getAssociatedObject(self, @selector(rst_operationQueue));
}

- (void)setRst_operationQueue:(NSOperationQueue *)rst_operationQueue
{
    objc_setAssociatedObject(self, @selector(rst_operationQueue), rst_operationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
