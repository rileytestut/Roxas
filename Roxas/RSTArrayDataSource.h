//
//  RSTArrayDataSource.h
//  Roxas
//
//  Created by Riley Testut on 2/13/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTCellContentDataSource.h"

@class RSTCellContentChange;

NS_ASSUME_NONNULL_BEGIN

@interface RSTArrayDataSource<ContentType, CellType: UIView<RSTCellContentCell> *, ViewType: UIScrollView<RSTCellContentView> *, DataSourceType> : RSTCellContentDataSource<ContentType, CellType, ViewType, DataSourceType>

@property (copy, nonatomic) NSArray<ContentType> *items;

- (instancetype)initWithItems:(NSArray<ContentType> *)items NS_DESIGNATED_INITIALIZER;

- (void)setItems:(NSArray<ContentType> *)items withChanges:(nullable NSArray<RSTCellContentChange *> *)changes;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


// Concrete Subclasses

NS_ASSUME_NONNULL_BEGIN

@interface RSTArrayTableViewDataSource<ContentType> : RSTArrayDataSource<ContentType, UITableViewCell *, UITableView *, id<UITableViewDataSource>> <UITableViewDataSource>
@end

@interface RSTArrayCollectionViewDataSource<ContentType> : RSTArrayDataSource<ContentType, UICollectionViewCell *, UICollectionView *, id<UICollectionViewDataSource>> <UICollectionViewDataSource>
@end

NS_ASSUME_NONNULL_END
