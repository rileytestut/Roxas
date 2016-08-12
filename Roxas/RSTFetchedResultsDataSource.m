//
//  RSTFetchedResultsDataSource.m
//  Roxas
//
//  Created by Riley Testut on 8/12/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsDataSource.h"

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
    }
    
    return self;
}

#pragma mark - Getters/Setters -

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
    
    if (_fetchedResultsController.delegate == nil)
    {
        _fetchedResultsController.delegate = self;
    }
}

@end
