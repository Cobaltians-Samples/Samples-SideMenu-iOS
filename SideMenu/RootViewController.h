//
//  RootViewController.h
//  SideMenu
//
//  Created by Sébastien Vitard on 23/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import "AbstractViewController.h"

@protocol MenuToggleDelegate <NSObject>

@required

- (void)toggleMenu;

@end

@interface RootViewController : AbstractViewController

@property (weak, nonatomic) id<MenuToggleDelegate> menuToggleDelegate;

@end
