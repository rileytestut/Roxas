//
//  RSTPersistentContainer.m
//  Roxas
//
//  Created by Riley Testut on 7/16/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

#import "RSTPersistentContainer.h"
#import "RSTRelationshipPreservingMergePolicy.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSTPersistentContainer ()

@property (readonly, nonatomic) NSHashTable<NSManagedObjectContext *> *parentBackgroundContexts;
@property (readonly, nonatomic) NSHashTable<NSManagedObjectContext *> *pendingSaveParentBackgroundContexts;

@end

NS_ASSUME_NONNULL_END

@implementation RSTPersistentContainer

- (instancetype)initWithName:(NSString *)name bundle:(NSBundle *)bundle
{
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
    
    _parentBackgroundContexts = [NSHashTable weakObjectsHashTable];
    _pendingSaveParentBackgroundContexts = [NSHashTable weakObjectsHashTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextWillSave:) name:NSManagedObjectContextWillSaveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextObjectsDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
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
        [self configureManagedObjectContext:self.viewContext parent:nil];
        
        completionHandler(description, error);
    }];
}

- (NSManagedObjectContext *)newBackgroundContext
{
    NSManagedObjectContext *context = [super newBackgroundContext];
    [self configureManagedObjectContext:context parent:nil];
    return context;
}

- (NSManagedObjectContext *)newBackgroundSavingViewContext
{
    NSManagedObjectContext *parentBackgroundContext = [self newBackgroundContext];
    [self.parentBackgroundContexts addObject:parentBackgroundContext];
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self configureManagedObjectContext:context parent:parentBackgroundContext];
    return context;
}

- (NSManagedObjectContext *)newBackgroundContextWithParent:(NSManagedObjectContext *)parentContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self configureManagedObjectContext:context parent:parentContext];
    return context;
}

- (void)configureManagedObjectContext:(NSManagedObjectContext *)context parent:(nullable NSManagedObjectContext *)parent
{
    if (parent != nil)
    {
        context.parentContext = parent;
    }
    
    context.automaticallyMergesChangesFromParent = YES;
    context.mergePolicy = self.preferredMergePolicy;
}

#pragma mark - NSNotifications -

- (void)managedObjectContextWillSave:(NSNotification *)notification
{
    NSManagedObjectContext *context = notification.object;
    if (![self.parentBackgroundContexts containsObject:context.parentContext])
    {
        return;
    }
    
    [self.pendingSaveParentBackgroundContexts addObject:context.parentContext];
}

- (void)managedObjectContextObjectsDidChange:(NSNotification *)notification
{
    NSManagedObjectContext *context = notification.object;
    if (![self.pendingSaveParentBackgroundContexts containsObject:context])
    {
        return;
    }
    
    NSError *error = nil;
    if (![context save:&error])
    {
        ELog(error);
    }
    
    [self.pendingSaveParentBackgroundContexts removeObject:context];
}

@end
