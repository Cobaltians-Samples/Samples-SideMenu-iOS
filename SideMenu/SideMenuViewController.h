//
//  SideMenuViewController.h
//  Cobaltians
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DefaultViewController.h"

@interface SideMenuViewController : UIViewController <UIGestureRecognizerDelegate, MenuDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableDictionary *viewControllersForIdentifier;
@property (strong, nonatomic) NSString *viewControllersSelected;
@property (strong, nonatomic) UIPanGestureRecognizer *dragMenuGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *closeMenuGestureRecognizer;
@property (strong, nonatomic) DefaultViewController *menuViewController;
@property (assign, nonatomic) BOOL menuVisible;
@property (assign, nonatomic) BOOL menuRevealed;

@end
