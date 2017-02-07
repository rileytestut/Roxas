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
    // According to documentation:
    // Move is reported when an object changes in a manner that affects its position in the results.  An update of the object is assumed in this case, no separate update message is sent to the delegate.
    
    // Therefore, we need to manually send another update message to items that moved after move is complete
    // (because it may crash if you try to update an item that is moving in the same batch updates block...)
    NSMutableArray<RSTFetchedResultsChangeOperation *> *postMoveUpdateOperations = [NSMutableArray array];
    for (RSTFetchedResultsChangeOperation *operation in self.rst_operationQueue.operations)
    {
        if (operation.change.type != NSFetchedResultsChangeMove)
        {
            continue;
        }
        
        RSTFetchedResultsChange *change = [[RSTFetchedResultsChange alloc] initWithType:NSFetchedResultsChangeUpdate currentIndexPath:operation.change.destinationIndexPath destinationIndexPath:nil];
        
        RSTFetchedResultsChangeOperation *updateOperation = [[RSTFetchedResultsChangeOperation alloc] initWithChange:change collectionView:self];
        [postMoveUpdateOperations addObject:updateOperation];
    }
    
    [self performBatchUpdates:^{
        [self.rst_operationQueue setSuspended:NO];
        [self.rst_operationQueue waitUntilAllOperationsAreFinished];
    } completion:^(BOOL finished) {
        
        // Perform additional updates after any moved items have been moved
        [self performBatchUpdates:^{
            [self.rst_operationQueue addOperations:postMoveUpdateOperations waitUntilFinished:YES];
        } completion:^(BOOL finished) {
            self.rst_operationQueue = nil;
        }];
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
