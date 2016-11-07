//
//  UITableView+FetchedResultsChanges.h
//  Roxas
//
//  Created by Riley Testut on 10/21/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsChange.h"

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (FetchedResultsChanges)

- (void)rst_addChange:(RSTFetchedResultsChange *)change withRowAnimation:(UITableViewRowAnimation)rowAnimation NS_SWIFT_NAME(add(_:withRowAnimation:));

@end

NS_ASSUME_NONNULL_END
