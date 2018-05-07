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

@interface RSTCompositeDataSource () <RSTCellContentIndexPathTranslating>

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
        
        for (RSTCellContentDataSource *dataSource in _dataSources)
        {
            dataSource.indexPathTranslator = self;
        }
        
        __weak RSTCompositeDataSource *weakSelf = self;
        
        self.cellIdentifierHandler = ^NSString * _Nonnull(NSIndexPath *_Nonnull indexPath) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil)
            {
                return RSTCellContentGenericCellIdentifier;
            }
            
            NSIndexPath *localIndexPath = [weakSelf dataSource:dataSource localIndexPathForGlobalIndexPath:indexPath];
            
            NSString *identifier = dataSource.cellIdentifierHandler(localIndexPath);
            return identifier;
        };
        
        self.cellConfigurationHandler = ^(id _Nonnull cell, id _Nonnull item, NSIndexPath *_Nonnull indexPath) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil)
            {
                return;
            }
            
            NSIndexPath *localIndexPath = [weakSelf dataSource:dataSource localIndexPathForGlobalIndexPath:indexPath];
            dataSource.cellConfigurationHandler(cell, item, localIndexPath);
        };
        
        self.prefetchHandler = ^NSOperation * _Nullable(id  _Nonnull item, NSIndexPath * _Nonnull indexPath, void (^ _Nonnull completionHandler)(id _Nullable, NSError * _Nullable)) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil || dataSource.prefetchHandler == nil)
            {
                return nil;
            }
            
            NSIndexPath *localIndexPath = [weakSelf dataSource:dataSource localIndexPathForGlobalIndexPath:indexPath];
            
            NSOperation *operation = dataSource.prefetchHandler(item, localIndexPath, completionHandler);
            return operation;
        };
        
        self.prefetchCompletionHandler = ^(__kindof UIView<RSTCellContentCell> * _Nonnull cell, id  _Nullable item, NSIndexPath * _Nonnull indexPath, NSError * _Nullable error) {
            RSTCellContentDataSource *dataSource = [weakSelf dataSourceForIndexPath:indexPath];
            if (dataSource == nil || dataSource.prefetchCompletionHandler == nil)
            {
                return;
            }
            
            NSIndexPath *localIndexPath = [weakSelf dataSource:dataSource localIndexPathForGlobalIndexPath:indexPath];
            dataSource.prefetchCompletionHandler(cell, item, localIndexPath, error);
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
    
    NSIndexPath *localIndexPath = [self dataSource:dataSource localIndexPathForGlobalIndexPath:indexPath];
    
    NSInteger numberOfItems = [dataSource contentView:contentView numberOfItemsInSection:localIndexPath.section];
    return numberOfItems;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    RSTCellContentDataSource *dataSource = [self dataSourceForIndexPath:indexPath];
    if (dataSource == nil)
    {
        @throw [NSException exceptionWithName:NSRangeException reason:nil userInfo:nil];
    }
    
    NSIndexPath *localIndexPath = [self dataSource:dataSource localIndexPathForGlobalIndexPath:indexPath];
    
    id item = [dataSource itemAtIndexPath:localIndexPath];
    return item;
}

- (void)filterContentWithPredicate:(nullable NSPredicate *)predicate
{
    for (RSTCellContentDataSource *dataSource in self.dataSources)
    {
        [dataSource filterContentWithPredicate:predicate];
    }
}

#pragma mark - <RSTCellContentIndexPathTranslating> -

- (nullable NSIndexPath *)dataSource:(RSTCellContentDataSource *)dataSource localIndexPathForGlobalIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSValue *rangeValue = [self.dataSourceSectionRanges objectForKey:dataSource];
    if (rangeValue == nil)
    {
        return nil;
    }
    
    NSRange range = [rangeValue rangeValue];
    
    NSIndexPath *localIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section - range.location];
    return localIndexPath;
}

- (nullable NSIndexPath *)dataSource:(RSTCellContentDataSource *)dataSource globalIndexPathForLocalIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSValue *rangeValue = [self.dataSourceSectionRanges objectForKey:dataSource];
    if (rangeValue == nil)
    {
        return nil;
    }
    
    NSRange range = [rangeValue rangeValue];
    
    NSIndexPath *globalIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section + range.location];
    return globalIndexPath;
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
