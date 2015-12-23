//
//  DefaultViewController.m
//  SideMenu
//
//  Created by Sébastien Vitard on 23/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import "DefaultViewController.h"

@interface DefaultViewController ()

@end

@implementation DefaultViewController

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark LIFECYCLE

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<MenuEnableDelegate> delegate = [AbstractViewController menuEnableDelegate];
    if (delegate != nil) {
        [delegate setMenuEnabled:NO];
    }
}

@end
