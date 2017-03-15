//
//  RSTFetchedResultsDataSource.m
//  Roxas
//
//  Created by Riley Testut on 8/12/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsDataSource.h"
#import "RSTCellContentDataSource_Subclasses.h"

#import "RSTBlockOperation.h"
#import "RSTSearchController.h"

#import "RSTHelperFile.h"

static void *RSTFetchedResultsDataSourceContext = &RSTFetchedResultsDataSourceContext;


NS_ASSUME_NONNULL_BEGIN

// Declare custom NSPredicate subclass so we can detect whether NSFetchedResultsController's predicate was changed externally or by us.
@interface RSTProxyPredicate : NSCompoundPredicate

- (instancetype)initWithPredicate:(nullable NSPredicate *)predicate externalPredicate:(nullable NSPredicate *)externalPredicate;

@end

NS_ASSUME_NONNULL_END


@implementation RSTProxyPredicate

- (instancetype)initWithPredicate:(nullable NSPredicate *)predicate externalPredicate:(nullable NSPredicate *)externalPredicate
{
    NSMutableArray *subpredicates = [NSMutableArray array];
    
    if (externalPredicate != nil)
    {
        [subpredicates addObject:externalPredicate];
    }
    
    if (predicate != nil)
    {
        [subpredicates addObject:predicate];
    }
    
    self = [super initWithType:NSAndPredicateType subpredicates:subpredicates];
    return self;
}

@end


NS_ASSUME_NONNULL_BEGIN

@interface RSTFetchedResultsDataSource ()

@property (nonatomic, copy, nullable) NSPredicate *externalPredicate;

@end

NS_ASSUME_NONNULL_END


@implementation RSTFetchedResultsDataSource

- (instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self = [self initWithFetchedResultsController:fetchedResultsController];
    return self;
}

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    self = [super init];
    if (self)
    {
        [self setFetchedResultsController:fetchedResultsController];
        
        __weak RSTFetchedResultsDataSource *weakSelf = self;
        self.defaultSearchHandler = ^NSOperation *(RSTSearchValue *searchValue, RSTSearchValue *previousSearchValue) {
            return [RSTBlockOperation blockOperationWithExecutionBlock:^(RSTBlockOperation * _Nonnull __weak operation) {
                [weakSelf setPredicate:searchValue.predicate refreshContent:NO];
                
                // Only refresh content if search operation has not been cancelled, such as when the search text changes.
                if (operation != nil && ![operation isCancelled])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.contentView reloadData];
                    });
                }
            }];
        };
    }
    
    return self;
}

- (void)dealloc
{
    [_fetchedResultsController removeObserver:self forKeyPath:@"fetchRequest.predicate" context:RSTFetchedResultsDataSourceContext];
}

#pragma mark - RSTCellContentViewDataSource -

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return item;
}

- (NSInteger)numberOfSectionsInContentView:(__kindof UIView<RSTCellContentView> *)contentView
{
    if (self.fetchedResultsController.sections == nil)
    {
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error])
        {
            ELog(error);
        }
    }
    
    NSInteger numberOfSections = self.fetchedResultsController.sections.count;
    return numberOfSections;
}

- (NSInteger)contentView:(__kindof UIView<RSTCellContentView> *)contentView numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (void)filterContentWithPredicate:(nullable NSPredicate *)predicate refreshContent:(BOOL)refreshContent
{
    RSTProxyPredicate *proxyPredicate = [[RSTProxyPredicate alloc] initWithPredicate:predicate externalPredicate:self.externalPredicate];
    self.fetchedResultsController.fetchRequest.predicate = proxyPredicate;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        ELog(error);
    }
    
    if (refreshContent)
    {
        rst_dispatch_sync_on_main_thread(^{
            [self.contentView reloadData];
        });
    }
}

#pragma mark - KVO -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != RSTFetchedResultsDataSourceContext)
    {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    NSPredicate *predicate = change[NSKeyValueChangeNewKey];
    self.externalPredicate = predicate;
    
    if (![predicate isKindOfClass:[RSTProxyPredicate class]])
    {
        RSTProxyPredicate *proxyPredicate = [[RSTProxyPredicate alloc] initWithPredicate:self.predicate externalPredicate:self.externalPredicate];
        [[(NSFetchedResultsController *)object fetchRequest] setPredicate:proxyPredicate];
    }
}

#pragma mark - <NSFetchedResultsControllerDelegate> -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.contentView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    RSTCellContentChangeType changeType = RSTCellContentChangeTypeFromFetchedResultsChangeType(type);
    
    RSTCellContentChange *change = [[RSTCellContentChange alloc] initWithType:changeType sectionIndex:sectionIndex];
    change.rowAnimation = self.rowAnimation;
    [self.contentView addChange:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    RSTCellContentChangeType changeType = RSTCellContentChangeTypeFromFetchedResultsChangeType(type);
    
    RSTCellContentChange *change = [[RSTCellContentChange alloc] initWithType:changeType currentIndexPath:indexPath destinationIndexPath:newIndexPath];
    change.rowAnimation = self.rowAnimation;
    [self.contentView addChange:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.contentView endUpdates];
}

#pragma mark - Getters/Setters -

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == _fetchedResultsController)
    {
        return;
    }
    
    // Clean up previous _fetchedResultsController.
    [_fetchedResultsController removeObserver:self forKeyPath:@"fetchRequest.predicate" context:RSTFetchedResultsDataSourceContext];
    
    _fetchedResultsController.fetchRequest.predicate = self.externalPredicate;
    self.externalPredicate = nil;
    
    
    // Prepare new _fetchedResultsController.
    _fetchedResultsController = fetchedResultsController;
    
    if (_fetchedResultsController.delegate == nil)
    {
        _fetchedResultsController.delegate = self;
    }
    
    self.externalPredicate = _fetchedResultsController.fetchRequest.predicate;
    
    RSTProxyPredicate *proxyPredicate = [[RSTProxyPredicate alloc] initWithPredicate:self.predicate externalPredicate:self.externalPredicate];
    _fetchedResultsController.fetchRequest.predicate = proxyPredicate;
    
    [_fetchedResultsController addObserver:self forKeyPath:@"fetchRequest.predicate" options:NSKeyValueObservingOptionNew context:RSTFetchedResultsDataSourceContext];
    
    rst_dispatch_sync_on_main_thread(^{
        [self.contentView reloadData];
    });
}

@end

@implementation RSTFetchedResultsTableViewDataSource
@end

@implementation RSTFetchedResultsCollectionViewDataSource
@end
