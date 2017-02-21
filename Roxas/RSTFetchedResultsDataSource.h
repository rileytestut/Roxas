//
//  RSTFetchedResultsDataSource.h
//  Roxas
//
//  Created by Riley Testut on 8/12/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTCellContentDataSource.h"

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface RSTFetchedResultsDataSource<ContentType: NSManagedObject *, CellType: UIView<RSTCellContentCell> *, ViewType: UIScrollView<RSTCellContentView> *, DataSourceType> : RSTCellContentDataSource<ContentType, CellType, ViewType, DataSourceType> <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController<ContentType> *fetchedResultsController;

- (instancetype)initWithFetchRequest:(NSFetchRequest<ContentType> *)fetchRequest managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController<ContentType> *)fetchedResultsController NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


// Concrete Subclasses

NS_ASSUME_NONNULL_BEGIN

@interface RSTFetchedResultsTableViewDataSource<ContentType: NSManagedObject *> : RSTFetchedResultsDataSource<ContentType, UITableViewCell *, UITableView *, id<UITableViewDataSource>> <UITableViewDataSource>
@end

@interface RSTFetchedResultsCollectionViewDataSource<ContentType: NSManagedObject *> : RSTFetchedResultsDataSource<ContentType, UICollectionViewCell *, UICollectionView *, id<UICollectionViewDataSource>> <UICollectionViewDataSource>
@end

NS_ASSUME_NONNULL_END
