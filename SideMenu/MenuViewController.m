//
//  MenuViewController.m
//  SideMenu
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright (c) 2015 Cobaltians. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark COBALT

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)onUnhandledEvent:(NSString *)event
                withData:(NSDictionary *)data
             andCallback:(NSString *)callback {
    if ([@"sidemenu:switch" isEqualToString:event]
        && data != nil && [data isKindOfClass:[NSDictionary class]]) {
        id identifier = [data objectForKey:@"id"];
        id controller = [data objectForKey:@"controller"];
        id page = [data objectForKey:@"page"];
        id innerData = [data objectForKey:@"data"];
        
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
        
        return true;
    }
    
    return [super onUnhandledEvent:event
                          withData:data
                       andCallback:callback];
}

@end
