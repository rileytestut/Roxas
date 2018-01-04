//
//  RSTCompositeDataSource.m
//  Roxas
//
//  Created by Riley Testut on 12/19/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTCompositeDataSource.h"
#import "RSTCellContentDataSource_Subclasses.h"

#import "RSTHelperFile.h"

// Allow NSValue-boxing literals for NSRange.
typedef struct __attribute__((objc_boxable)) _NSRange NSRange;

NS_ASSUME_NONNULL_BEGIN

@interface RSTCompositeDataSource ()

@property (nonatomic, readonly) NSMapTable<RSTCellContentDataSource *, NSValue *> *dataSourceSectionRanges;

@end

NS_ASSUME_NONNULL_END

@implementation RSTCompositeDataSource

- (instancetype)initWithDataSources:(NSArray *)dataSources
{
    self = [super init];
    if (self)
    {
        _dataSources = [dataSources copy];
        _dataSourceSectionRanges = [NSMapTable strongToStrongObjectsMapTable];
        
        __weak RSTCompositeDataSource *weakSelf = self;
        
        self.cellIdentifierHandler = ^NSString * _Nonnull(NSIndexPath *_Nonnull indexPath) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil)
            {
                return RSTCellContentGenericCellIdentifier;
            }
            
            NSIndexPath *internalIndexPath = [weakSelf internalIndexPathForIndexPath:indexPath dataSource:dataSource];
            
            NSString *identifier = dataSource.cellIdentifierHandler(internalIndexPath);
            return identifier;
        };
        
        self.cellConfigurationHandler = ^(id _Nonnull cell, id _Nonnull item, NSIndexPath *_Nonnull indexPath) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil)
            {
                return;
            }
            
            NSIndexPath *internalIndexPath = [weakSelf internalIndexPathForIndexPath:indexPath dataSource:dataSource];
            dataSource.cellConfigurationHandler(cell, item, internalIndexPath);
        };
        
        self.prefetchHandler = ^NSOperation * _Nullable(id  _Nonnull item, NSIndexPath * _Nonnull indexPath, void (^ _Nonnull completionHandler)(id _Nullable, NSError * _Nullable)) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil || dataSource.prefetchHandler == nil)
            {
                return nil;
            }
            
            NSIndexPath *internalIndexPath = [weakSelf internalIndexPathForIndexPath:indexPath dataSource:dataSource];
            
            NSOperation *operation = dataSource.prefetchHandler(item, internalIndexPath, completionHandler);
            return operation;
        };
        
        self.prefetchCompletionHandler = ^(__kindof UIView<RSTCellContentCell> * _Nonnull cell, id  _Nullable item, NSIndexPath * _Nonnull indexPath, NSError * _Nullable error) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil || dataSource.prefetchCompletionHandler == nil)
            {
                return;
            }
            
            NSIndexPath *internalIndexPath = [weakSelf internalIndexPathForIndexPath:indexPath dataSource:dataSource];
            dataSource.prefetchCompletionHandler(cell, item, internalIndexPath, error);
        };
    }
    
    return self;
}

#pragma mark - RSTCompositeDataSource -

- (RSTCellContentDataSource *)dataSourceForIndexPath:(NSIndexPath *)indexPath
{
    __block RSTCellContentDataSource *dataSource = nil;
    
    for (RSTCellContentDataSource *key in self.dataSourceSectionRanges.copy)
    {
        NSRange range = [[self.dataSourceSectionRanges objectForKey:key] rangeValue];
        if (NSLocationInRange(indexPath.section, range))
        {
            dataSource = key;
            break;
        }
    }
    
    return dataSource;
}

- (NSIndexPath *)internalIndexPathForIndexPath:(NSIndexPath *)indexPath dataSource:(RSTCellContentDataSource *)dataSource
{
    NSRange range = [[self.dataSourceSectionRanges objectForKey:dataSource] rangeValue];
    
    NSIndexPath *internalIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section - range.location];
    return internalIndexPath;
}

#pragma mark - RSTCellContentDataSource -

- (NSInteger)numberOfSectionsInContentView:(__kindof UIView<RSTCellContentView> *)contentView
{
    NSInteger numberOfSections = 0;
    for (RSTCellContentDataSource *dataSource in self.dataSources)
    {
        NSInteger sections = [dataSource numberOfSectionsInContentView:contentView];
        
        NSRange range = NSMakeRange(numberOfSections, sections);
        [self.dataSourceSectionRanges setObject:@(range) forKey:dataSource];
        
        numberOfSections += sections;
    }
    
    return numberOfSections;
}

- (NSInteger)contentView:(__kindof UIView<RSTCellContentView> *)contentView numberOfItemsInSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    
    RSTCellContentDataSource *dataSource = [self dataSourceForIndexPath:indexPath];
    if (dataSource == nil)
    {
        return 0;
    }
    
    NSIndexPath *internalIndexPath = [self internalIndexPathForIndexPath:indexPath dataSource:dataSource];
    
    NSInteger numberOfItems = [dataSource contentView:contentView numberOfItemsInSection:internalIndexPath.section];
    return numberOfItems;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    RSTCellContentDataSource *dataSource = [self dataSourceForIndexPath:indexPath];
    if (dataSource == nil)
    {
        @throw [NSException exceptionWithName:NSRangeException reason:nil userInfo:nil];
    }
    
    NSIndexPath *internalIndexPath = [self internalIndexPathForIndexPath:indexPath dataSource:dataSource];
    
    id item = [dataSource itemAtIndexPath:internalIndexPath];
    return item;
}

- (void)filterContentWithPredicate:(nullable NSPredicate *)predicate
{
    for (RSTCellContentDataSource *dataSource in self.dataSources)
    {
        [dataSource filterContentWithPredicate:predicate];
    }
}

#pragma mark - Getters/Setters -

- (void)setContentView:(UIScrollView<RSTCellContentView> *)contentView
{
    [super setContentView:contentView];
    
    for (RSTCellContentDataSource *dataSource in self.dataSources)
    {
        dataSource.contentView = contentView;
    }
}

@end

@implementation RSTCompositeTableViewDataSource
@end

@implementation RSTCompositeCollectionViewDataSource
@end

@implementation RSTCompositePrefetchingDataSource
@dynamic prefetchItemCache;
@dynamic prefetchHandler;
@dynamic prefetchCompletionHandler;
@end

@implementation RSTCompositeTableViewPrefetchingDataSource
@end

@implementation RSTCompositeCollectionViewPrefetchingDataSource
@end
