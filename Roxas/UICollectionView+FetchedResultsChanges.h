//
//  UICollectionView+FetchedResultsChanges.h
//  Roxas
//
//  Created by Riley Testut on 8/2/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsChange.h"

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (FetchedResultsChanges)

- (void)rst_beginUpdates NS_SWIFT_NAME(beginUpdates());
- (void)rst_endUpdates NS_SWIFT_NAME(endUpdates());

- (void)rst_addChange:(RSTFetchedResultsChange *)change NS_SWIFT_NAME(add(_:));

@end

NS_ASSUME_NONNULL_END
