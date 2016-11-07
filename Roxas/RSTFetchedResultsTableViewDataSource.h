//
//  RSTFetchedResultsTableViewDataSource.h
//  Roxas
//
//  Created by Riley Testut on 10/21/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSTFetchedResultsTableViewDataSource<ResultType: NSManagedObject *> : RSTFetchedResultsDataSource<ResultType> <UITableViewDataSource>

@property (nullable, copy, nonatomic) void (^cellConfigurationHandler)(__kindof UITableViewCell *, NSIndexPath *);

@property (nonatomic) UITableViewRowAnimation rowAnimation;

@end

NS_ASSUME_NONNULL_END
