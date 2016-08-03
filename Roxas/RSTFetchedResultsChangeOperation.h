//
//  RSTFetchedResultsChangeOperation.h
//  Roxas
//
//  Created by Riley Testut on 8/2/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTOperation.h"

@import UIKit;

@class RSTFetchedResultsChange;

NS_ASSUME_NONNULL_BEGIN

@interface RSTFetchedResultsChangeOperation : RSTOperation

@property (copy, nonatomic, readonly) RSTFetchedResultsChange *change;
@property (nullable, weak, nonatomic, readonly) UICollectionView *collectionView;

- (instancetype)initWithChange:(RSTFetchedResultsChange *)change collectionView:(nullable UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
