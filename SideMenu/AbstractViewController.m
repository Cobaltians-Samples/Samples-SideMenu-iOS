//
//  AbstractViewController.m
//  SideMenu
//
//  Created by Sébastien Vitard on 23/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

static __weak id<MenuEnableDelegate> menuEnableDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark LIFECYCLE

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // [self setDelegate:self];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0
                                                                        green:0.36
                                                                         blue:0.41
                                                                        alpha:1];
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

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark MENU ENABLE DELEGATE

////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id<MenuEnableDelegate>)menuEnableDelegate {
    return menuEnableDelegate;
}

+ (void)setMenuEnableDelegate:(id<MenuEnableDelegate>)delegate {
    menuEnableDelegate = delegate;
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
    return false;
}

- (BOOL)onUnhandledCallback:(NSString *)callback
                   withData:(NSDictionary *)data {
    return false;
}

@end
