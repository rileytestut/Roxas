//
//  RSTSearchResultsController.h
//  Roxas
//
//  Created by Riley Testut on 2/7/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface RSTSearchValue : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSPredicate *predicate;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface RSTSearchController : UISearchController <UISearchResultsUpdating>

// Used to generate RSTSearchValue predicates.
@property (copy, nonatomic) NSSet<NSString *> *searchableKeyPaths;

@property (nullable, copy, nonatomic) void (^searchHandler)(RSTSearchValue *searchValue, RSTSearchValue *_Nullable previousSearchValue);

@end

NS_ASSUME_NONNULL_END
