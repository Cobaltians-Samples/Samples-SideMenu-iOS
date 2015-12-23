//
//  SideMenuViewController.h
//  SideMenu
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"
#import "RootViewController.h"

@interface SideMenuViewController : UIViewController <UIGestureRecognizerDelegate, MenuEnableDelegate, MenuSwitchDelegate, MenuToggleDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableDictionary *viewControllersForIdentifier;
@property (strong, nonatomic) NSString *viewControllersSelected;
@property (strong, nonatomic) UIPanGestureRecognizer *dragMenuGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *closeMenuGestureRecognizer;
@property (strong, nonatomic) MenuViewController *menuViewController;
@property (assign, nonatomic) BOOL menuEnabled;
@property (assign, nonatomic) BOOL menuVisible;
@property (assign, nonatomic) BOOL menuRevealed;

@end
