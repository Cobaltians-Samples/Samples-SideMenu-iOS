//
//  MenuViewController.m
//  SideMenu
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright (c) 2015 Cobaltians. All rights reserved.
//

#import "MenuViewController.h"
#import <Cobalt/PubSub.h>

@interface MenuViewController ()

@end

@implementation MenuViewController

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark COBALT

////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PubSub *pubsub = [PubSub sharedInstance];
    [pubsub subscribeDelegate:self
                    toChannel:@"sidemenu:switch"];
    
}

- (void)didReceiveMessage:(nullable NSDictionary *)message
                onChannel:(nonnull NSString *)channel {
    if ([channel isEqualToString:@"sidemenu:switch"]) {
        if (message != nil && [message isKindOfClass:[NSDictionary class]]) {
            
            id identifier = [message objectForKey:@"id"];
            id controller = [message objectForKey:@"controller"];
            id page = [message objectForKey:@"page"];
            id innerData = [message objectForKey:@"data"];
            
            if (identifier != nil && [identifier isKindOfClass:[NSString class]]
                && controller != nil && [controller isKindOfClass:[NSString class]]
                && page != nil && [page isKindOfClass:[NSString class]]
                && (innerData == nil || [innerData isKindOfClass:[NSDictionary class]])) {
                if (_menuSwitchDelegate != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_menuSwitchDelegate switchNavigationController:identifier
                                                         withController:controller
                                                               withPage:page
                                                                andData:innerData];
                    });
                }
            }
            
        }
    }
}

@end
