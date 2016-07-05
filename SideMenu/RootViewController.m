//
//  RootViewController.m
//  SideMenu
//
//  Created by Sébastien Vitard on 23/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark LIFECYCLE

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UIBarButtonItem *sideMenuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidemenu"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:_menuToggleDelegate
                                                                             action:@selector(toggleMenu)];
    
    [self.navigationItem setLeftBarButtonItem:sideMenuBarButtonItem
                                     animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<MenuEnableDelegate> delegate = [AbstractViewController menuEnableDelegate];
    if (delegate != nil) {
        [delegate setMenuEnabled:YES];
    }
}

@end
