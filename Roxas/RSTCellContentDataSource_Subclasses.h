//
//  RSTCellContentDataSource_Subclasses.h
//  Roxas
//
//  Created by Riley Testut on 2/7/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTCellContentDataSource.h"

NS_ASSUME_NONNULL_BEGIN

// Privately declare conformance to DataSource protocols so clients must use a concrete subclass (which provides correct generic parameters to superclass).
@interface RSTCellContentDataSource () <UITableViewDataSource, UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInContentView:(__kindof UIView<RSTCellContentView> *)contentView;
- (NSInteger)contentView:(__kindof UIView<RSTCellContentView> *)contentView numberOfItemsInSection:(NSInteger)section;

- (void)filterContentWithPredicate:(nullable NSPredicate *)predicate;

@end

NS_ASSUME_NONNULL_END
