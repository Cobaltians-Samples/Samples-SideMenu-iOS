//
//  AbstractViewController.h
//  SideMenu
//
//  Created by Sébastien Vitard on 23/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import "Cobalt.h"

@protocol MenuEnableDelegate <NSObject>

@required

- (void)setMenuEnabled:(BOOL)enabled;

@end

@interface AbstractViewController : CobaltViewController <CobaltDelegate>

+ (id<MenuEnableDelegate>)menuEnableDelegate;
+ (void)setMenuEnableDelegate:(id<MenuEnableDelegate>)delegate;

@end
