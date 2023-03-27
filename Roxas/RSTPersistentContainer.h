//
//  RSTPersistentContainer.h
//  Roxas
//
//  Created by Riley Testut on 7/16/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface RSTPersistentContainer : NSPersistentContainer

@property (nonatomic, readonly) BOOL isMigrationRequired;

@property (assign) BOOL shouldAddStoresAsynchronously;
@property (nonatomic) NSMergePolicy *preferredMergePolicy;

- (instancetype)initWithName:(NSString *)name bundle:(NSBundle *)bundle;
- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model;

- (NSManagedObjectContext *)newBackgroundSavingViewContext;

- (NSManagedObjectContext *)newViewContextWithParent:(nullable NSManagedObjectContext *)parent;
- (NSManagedObjectContext *)newBackgroundContextWithParent:(NSManagedObjectContext *)parent;

@end

NS_ASSUME_NONNULL_END
