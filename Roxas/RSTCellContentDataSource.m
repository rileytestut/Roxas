//
//  RSTCellContentDataSource.m
//  Roxas
//
//  Created by Riley Testut on 2/7/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTCellContentDataSource_Subclasses.h"
#import "RSTSearchController.h"

@import ObjectiveC.runtime;

NSString *RSTCellContentGenericCellIdentifier = @"Cell";

NS_ASSUME_NONNULL_BEGIN

@interface RSTCellContentDataSource ()

@property (nullable, weak, readwrite) UIScrollView<RSTCellContentView> *contentView;
@property (nonatomic, getter=isPlaceholderViewVisible) BOOL placeholderViewVisible;

@end

NS_ASSUME_NONNULL_END


@implementation RSTCellContentDataSource
{
    UITableViewCellSeparatorStyle _previousSeparatorStyle;
    UIView *_previousBackgroundView;
    BOOL _previousScrollEnabled;
    
    NSInteger _sectionsCount;
    NSInteger _itemsCount;
}
@synthesize searchController = _searchController;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cellIdentifierHandler = [^NSString *(NSIndexPath *indexPath) {
            return RSTCellContentGenericCellIdentifier;
        } copy];
        
        _cellConfigurationHandler = [^(id cell, id item, NSIndexPath *indexPath) {
            if ([cell isKindOfClass:[UITableViewCell class]])
            {
                [(UITableViewCell *)cell textLabel].text = [item description];
            }
        } copy];
        
        _rowAnimation = UITableViewRowAnimationAutomatic;
    }
    
    return self;
}

#pragma mark - NSObject -

- (BOOL)dataSourceProtocolContainsSelector:(SEL)aSelector
{
    Protocol *dataSourceProtocol = self.contentView.dataSourceProtocol;
    if (dataSourceProtocol == nil)
    {
        return NO;
    }
    
    struct objc_method_description dataSourceSelector = protocol_getMethodDescription(dataSourceProtocol, aSelector, NO, YES);
    
    BOOL containsSelector = (dataSourceSelector.name != NULL);
    return containsSelector;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
    {
        return YES;
    }
    
    if ([self dataSourceProtocolContainsSelector:aSelector])
    {
        return [self.proxy respondsToSelector:aSelector];
    }
    
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self dataSourceProtocolContainsSelector:aSelector])
    {
        return self.proxy;
    }
    
    return nil;
}

#pragma mark - RSTCellContentDataSource -

- (void)showPlaceholderView
{
    if ([self isPlaceholderViewVisible])
    {
        return;
    }
    
    if (self.placeholderView == nil || self.contentView == nil)
    {
        return;
    }
    
    self.placeholderViewVisible = YES;
    
    if ([self.contentView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)self.contentView;
        
        _previousSeparatorStyle = tableView.separatorStyle;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    _previousScrollEnabled = self.contentView.scrollEnabled;
    self.contentView.scrollEnabled = NO;
    
    _previousBackgroundView = self.contentView.backgroundView;
    self.contentView.backgroundView = self.placeholderView;
    
}

- (void)hidePlaceholderView
{
    if (![self isPlaceholderViewVisible])
    {
        return;
    }
    
    self.placeholderViewVisible = NO;
    
    if ([self.contentView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)self.contentView;
        tableView.separatorStyle = _previousSeparatorStyle;
    }
    
    self.contentView.scrollEnabled = _previousScrollEnabled;
    self.contentView.backgroundView = _previousBackgroundView;
}

#pragma mark - RSTCellContentDataSource Subclass Methods -

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)filterContentWithPredicate:(NSPredicate *)predicate
{
    [self doesNotRecognizeSelector:_cmd];
}

- (NSInteger)numberOfSectionsInContentView:(__kindof UIView *)contentView
{
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (NSInteger)contentView:(__kindof UIView *)contentView numberOfItemsInSection:(NSInteger)section
{
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

#pragma mark - <UITableViewDataSource> -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.contentView = tableView;
    
    NSInteger sections = [self numberOfSectionsInContentView:tableView];
    
    if (sections == 0)
    {
        [self showPlaceholderView];
    }
    
    _itemsCount = 0;
    _sectionsCount = sections;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self contentView:tableView numberOfItemsInSection:section];
    _itemsCount += rows;
    
    if (section == _sectionsCount - 1)
    {
        if (_itemsCount == 0)
        {
            [self showPlaceholderView];
        }
        else
        {
            [self hidePlaceholderView];
        }
        
        _itemsCount = 0;
        _sectionsCount = 0;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.cellIdentifierHandler(indexPath);
    id item = [self itemAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    self.cellConfigurationHandler(cell, item, indexPath);
    
    return cell;
}

#pragma mark - <UICollectionViewDataSource> -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    self.contentView = collectionView;
    
    NSInteger sections = [self numberOfSectionsInContentView:collectionView];
    
    if (sections == 0)
    {
        self.placeholderViewVisible = YES;
    }
    
    _itemsCount = 0;
    _sectionsCount = sections;
    
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger items = [self contentView:collectionView numberOfItemsInSection:section];
    _itemsCount += items;
    
    if (section == _sectionsCount - 1)
    {
        if (_itemsCount == 0)
        {
            self.placeholderViewVisible = YES;
        }
        else
        {
            self.placeholderViewVisible = NO;
        }
        
        _itemsCount = 0;
        _sectionsCount = 0;
    }
    
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.cellIdentifierHandler(indexPath);
    id item = [self itemAtIndexPath:indexPath];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.cellConfigurationHandler(cell, item, indexPath);
    
    return cell;
}

#pragma mark - Getters/Setters -

- (RSTSearchController *)searchController
{
    if (_searchController == nil)
    {
        _searchController = [[RSTSearchController alloc] initWithSearchResultsController:nil];
        
        __weak RSTCellContentDataSource *weakSelf = self;
        _searchController.searchHandler = ^(RSTSearchValue *searchValue, RSTSearchValue *previousSearchValue) {
            weakSelf.predicate = searchValue.predicate;
        };
    }
    
    return _searchController;
}

- (void)setContentView:(UIScrollView<RSTCellContentView> *)contentView
{
    if (contentView == _contentView)
    {
        return;
    }
    
    _contentView = contentView;
    
    if (contentView.dataSource == self)
    {
        // Must set ourselves as dataSource again to refresh respondsToSelector: cache.
        contentView.dataSource = nil;
        contentView.dataSource = self;
    }
}

- (void)setPredicate:(NSPredicate *)predicate
{
    _predicate = predicate;
    
    [self filterContentWithPredicate:_predicate];
}

- (void)setPlaceholderView:(UIView *)placeholderView
{
    if (_placeholderView != nil && self.contentView.backgroundView == _placeholderView)
    {
        self.contentView.backgroundView = placeholderView;
    }
    
    _placeholderView = placeholderView;
    _placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Show placeholder only if there are no items to display.
    
    BOOL shouldShowPlaceholderView = YES;
    
    for (int i = 0; i < [self numberOfSectionsInContentView:self.contentView]; i++)
    {
        if ([self contentView:self.contentView numberOfItemsInSection:i] > 0)
        {
            shouldShowPlaceholderView = NO;
            break;
        }
    }
    
    if (shouldShowPlaceholderView)
    {
        [self showPlaceholderView];
    }
    else
    {
        [self hidePlaceholderView];
    }
}

@end
