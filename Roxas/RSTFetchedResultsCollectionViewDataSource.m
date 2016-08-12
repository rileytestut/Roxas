//
//  RSTFetchedResultsCollectionViewDataSource.m
//  Roxas
//
//  Created by Riley Testut on 8/12/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

#import "RSTFetchedResultsCollectionViewDataSource.h"

#import "UICollectionView+FetchedResultsChanges.h"

@interface RSTFetchedResultsCollectionViewDataSource ()

@property (nullable, weak, nonatomic) UICollectionView *collectionView;

@end

@implementation RSTFetchedResultsCollectionViewDataSource

#pragma mark - <UICollectionViewDataSource> -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    self.collectionView = collectionView;
    
    NSInteger numberOfSections = self.fetchedResultsController.sections.count;
    return numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.cellIdentifierHandler(indexPath);
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.cellConfigurationHandler(cell, indexPath);
    return cell;
}

#pragma mark - <NSFetchedResultsControllerDelegate> -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView rst_beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    RSTFetchedResultsChange *change = [[RSTFetchedResultsChange alloc] initWithType:type sectionIndex:sectionIndex];
    [self.collectionView rst_addChange:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    RSTFetchedResultsChange *change = [[RSTFetchedResultsChange alloc] initWithType:type currentIndexPath:indexPath destinationIndexPath:newIndexPath];
    [self.collectionView rst_addChange:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView rst_endUpdates];
}

@end
