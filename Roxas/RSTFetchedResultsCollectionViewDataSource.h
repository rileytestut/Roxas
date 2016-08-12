//
//  RSTFetchedResultsCollectionViewDataSource.h
//  Roxas
//
//  Created by Riley Testut on 8/12/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSTFetchedResultsCollectionViewDataSource<ResultType: NSManagedObject *> : RSTFetchedResultsDataSource<ResultType> <UICollectionViewDataSource>

@property (nullable, copy, nonatomic) void (^cellConfigurationHandler)(__kindof UICollectionViewCell *, NSIndexPath *);

@end

NS_ASSUME_NONNULL_END
