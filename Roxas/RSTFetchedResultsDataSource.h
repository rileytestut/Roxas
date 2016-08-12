//
//  RSTFetchedResultsDataSource.h
//  Roxas
//
//  Created by Riley Testut on 8/12/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

@import UIKit;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface RSTFetchedResultsDataSource<ResultType: NSManagedObject *> : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController<ResultType> *fetchedResultsController;

@property (nullable, copy, nonatomic) NSString * (^cellIdentifierHandler)(NSIndexPath *);

- (instancetype)initWithFetchRequest:(NSFetchRequest<ResultType> *)fetchRequest managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController<ResultType> *)fetchedResultsController NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
