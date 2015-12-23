//
//  MenuViewController.h
//  SideMenu
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright (c) 2015 Cobaltians. All rights reserved.
//

#import "AbstractViewController.h"

@protocol MenuSwitchDelegate <NSObject>

@required

- (void)switchNavigationController:(NSString *)name
                    withController:(NSString *)controller
                          withPage:(NSString *)page
                           andData:(NSDictionary *)data;

@end

@interface MenuViewController : AbstractViewController

@property (weak, nonatomic) id<MenuSwitchDelegate> menuSwitchDelegate;

@end
