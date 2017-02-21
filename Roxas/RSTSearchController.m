//
//  RSTSearchResultsController.m
//  Roxas
//
//  Created by Riley Testut on 2/7/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTSearchController.h"

#import "NSPredicate+Search.h"

@implementation RSTSearchValue

- (instancetype)initWithText:(NSString *)text predicate:(NSPredicate *)predicate
{
    self = [super init];
    if (self)
    {
        _text = [text copy];
        _predicate = [predicate copy];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    RSTSearchValue *copy = [[RSTSearchValue alloc] initWithText:self.text predicate:self.predicate];
    return copy;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[RSTSearchValue class]])
    {
        return NO;
    }
    
    return [self.text isEqual:[(RSTSearchValue *)object text]];
}

- (NSUInteger)hash
{
    return self.text.hash;
}

@end


@interface RSTSearchController ()

@property (nullable, copy, nonatomic) RSTSearchValue *previousSearchValue;

@end


@implementation RSTSearchController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    self = [super initWithSearchResultsController:searchResultsController];
    if (self)
    {
        _searchableKeyPaths = [NSSet setWithObject:@"self"];
        
        self.searchResultsUpdater = self;
        
        if (searchResultsController == nil)
        {
            self.obscuresBackgroundDuringPresentation = NO;
        }
    }
    
    return self;
}

#pragma mark - <UISearchResultsUpdating> -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text ?: @"";
    NSPredicate *searchPredicate = [NSPredicate predicateForSearchingForText:searchText inValuesForKeyPaths:self.searchableKeyPaths];
    
    RSTSearchValue *searchValue = [[RSTSearchValue alloc] initWithText:searchText predicate:searchPredicate];
    
    if (self.searchHandler)
    {
        self.searchHandler(searchValue, self.previousSearchValue);
    }

    self.previousSearchValue = searchValue;
}

@end
