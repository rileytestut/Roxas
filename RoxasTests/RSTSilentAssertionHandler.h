//
//  RSTSilentAssertionHandler.h
//  Roxas
//
//  Created by Riley Testut on 1/13/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

@import Foundation;

@interface RSTSilentAssertionHandler : NSAssertionHandler

+ (void)enable;
+ (void)disable;

@end
