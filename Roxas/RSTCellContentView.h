//
//  RSTCellContentView.h
//  Roxas
//
//  Created by Riley Testut on 2/13/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#import "RSTCellContentCell.h"

@import UIKit;

@class RSTCellContentChange;

NS_ASSUME_NONNULL_BEGIN

@protocol RSTCellContentView <NSObject>

@property (nonatomic, nullable) id dataSource;
@property (nonatomic, nullable) id prefetchDataSource;

@property (nonatomic, readonly) Protocol *dataSourceProtocol;

@property (nonatomic, nullable) UIView *backgroundView;

@property (nonatomic, readonly) NSInteger numberOfSections;

- (void)beginUpdates;
- (void)endUpdates;
- (void)reloadData;

- (void)addChange:(RSTCellContentChange *)change;

- (nullable id)indexPathForCell:(id)cell;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end



NS_ASSUME_NONNULL_END
