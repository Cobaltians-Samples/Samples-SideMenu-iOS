//
//  DefaultViewController.m
//  Cobaltians
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright (c) 2015 Cobaltians. All rights reserved.
//

#import "DefaultViewController.h"

@interface DefaultViewController ()

@end

@implementation DefaultViewController

static __weak id<MenuDelegate> menuDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark LIFECYCLE

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (void)setDelegate:(id<MenuDelegate>)delegate {
    menuDelegate = delegate;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark COBALT

////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)onUnhandledMessage:(NSDictionary *)message {
    return false;
}

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
            if (menuDelegate != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [menuDelegate switchNavigationController:identifier
                                              withController:controller
                                                    withPage:page
                                                     andData:innerData];
                });
            }
        }
        
        return true;
    }
    
    return false;
}

- (BOOL)onUnhandledCallback:(NSString *)callback
                   withData:(NSDictionary *)data {
    return false;
}

@end
