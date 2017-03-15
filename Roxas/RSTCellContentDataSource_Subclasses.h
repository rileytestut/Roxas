//
//  RSTCellContentDataSource_Subclasses.h
//  Roxas
//
//  Created by Riley Testut on 2/7/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTCellContentDataSource.h"

@class RSTSearchValue;

NS_ASSUME_NONNULL_BEGIN

// Privately declare conformance to DataSource protocols so clients must use a concrete subclass (which provides correct generic parameters to superclass).
@interface RSTCellContentDataSource () <UITableViewDataSource, UICollectionViewDataSource>

// Defaults to synchronously setting RSTCellContentDataSource's predicate to searchValue.predicate.
// Subclasses can customize if needed, such as by returning an NSOperation inside handler to enable asynchronous RSTSearchController search results.
@property (copy, nonatomic) NSOperation * (^defaultSearchHandler)(RSTSearchValue *searchValue, RSTSearchValue *_Nullable previousSearchValue);

- (NSInteger)numberOfSectionsInContentView:(__kindof UIScrollView<RSTCellContentView> *)contentView;
- (NSInteger)contentView:(__kindof UIScrollView<RSTCellContentView> *)contentView numberOfItemsInSection:(NSInteger)section;

- (void)filterContentWithPredicate:(nullable NSPredicate *)predicate refreshContent:(BOOL)refreshContent;

@end

NS_ASSUME_NONNULL_END
