//
//  RSTFetchedResultsTableViewDataSource.m
//  Roxas
//
//  Created by Riley Testut on 10/21/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsTableViewDataSource.h"

#import "UITableView+FetchedResultsChanges.h"

@interface RSTFetchedResultsTableViewDataSource ()

@property (nullable, weak, nonatomic) UITableView *tableView;

@end

@implementation RSTFetchedResultsTableViewDataSource

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    self = [super initWithFetchedResultsController:fetchedResultsController];
    if (self)
    {
        _rowAnimation = UITableViewRowAnimationAutomatic;
    }
    
    return self;
}

#pragma mark - <UITableViewDataSource> -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableView = tableView;
    
    NSInteger numberOfSections = self.fetchedResultsController.sections.count;
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.cellIdentifierHandler(indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    self.cellConfigurationHandler(cell, indexPath);
    return cell;
}

#pragma mark - <NSFetchedResultsControllerDelegate> -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    RSTFetchedResultsChange *change = [[RSTFetchedResultsChange alloc] initWithType:type sectionIndex:sectionIndex];
    [self.tableView rst_addChange:change withRowAnimation:self.rowAnimation];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    RSTFetchedResultsChange *change = [[RSTFetchedResultsChange alloc] initWithType:type currentIndexPath:indexPath destinationIndexPath:newIndexPath];
    [self.tableView rst_addChange:change withRowAnimation:self.rowAnimation];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
