//
//  RSTPersistentContainer.m
//  Roxas
//
//  Created by Riley Testut on 7/16/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

#import "RSTPersistentContainer.h"
#import "RSTRelationshipPreservingMergePolicy.h"

@implementation RSTPersistentContainer

- (instancetype)initWithName:(NSString *)name
{
    // Reimplement initWithName: so we can override initWithName: in Swift instead of just initWithName:managedObjectModel:.
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    
    self = [super initWithName:name managedObjectModel:managedObjectModel];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super initWithName:name managedObjectModel:model];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _shouldAddStoresAsynchronously = NO;
    
    _preferredMergePolicy = [[RSTRelationshipPreservingMergePolicy alloc] init];
}

- (void)loadPersistentStoresWithCompletionHandler:(void (^)(NSPersistentStoreDescription * _Nonnull, NSError * _Nullable))completionHandler
{
    if (self.shouldAddStoresAsynchronously)
    {
        for (NSPersistentStoreDescription *description in self.persistentStoreDescriptions)
        {
            description.shouldAddStoreAsynchronously = YES;
        }
    }
    
    [super loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        self.viewContext.automaticallyMergesChangesFromParent = YES;
        
        completionHandler(description, error);
    }];
}

- (NSManagedObjectContext *)newBackgroundContext
{
    NSManagedObjectContext *context = [super newBackgroundContext];
    context.mergePolicy = self.preferredMergePolicy;
    return context;
}

@end
