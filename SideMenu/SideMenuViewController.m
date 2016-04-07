//
//  SideMenuViewController.m
//  SideMenu
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import "SideMenuViewController.h"

#define SLIDE_TIMING    0.25

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

///////////////////////////////////////////////////////////////

#pragma mark LIFECYCLE

///////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark NAVIGATION

///////////////////////////////////////////////////////////////

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"menu"]) {
        _menuViewController = (MenuViewController *) segue.destinationViewController;
        
        for (NSLayoutConstraint *constraint in [_menuContainer constraints]) {
            if ([@"menuContainerWidth" isEqualToString:[constraint identifier]]) {
                _menuContainerWidth = constraint;
            }
        }
        
        [self initMenu];
    }
    else if ([segue.identifier isEqualToString:@"navigationController"]) {
        _navigationController = (UINavigationController *) segue.destinationViewController;
        
        [self initRootViewController];
        
        _navigationController.navigationBar.translucent = NO;
        _navigationController.toolbar.translucent = NO;
        
        // Set up view shadows
        CALayer *navigationControllerViewLayer = [_navigationController.view layer];
        [navigationControllerViewLayer setShadowColor:[UIColor blackColor].CGColor];
        [navigationControllerViewLayer setShadowOpacity:0.8];
        [navigationControllerViewLayer setShadowOffset:CGSizeMake(-2, -2)];
        
        for (NSLayoutConstraint *constraint in [self.view constraints]) {
            if ([@"navigationControllerAlignLeading" isEqualToString:[constraint identifier]]) {
                _navigationControllerAlignLeading = constraint;
            }
        }
        
        [self initMenuGestures];
        [self updateMenuGestures];
    }
}

///////////////////////////////////////////////////////////////

#pragma mark MENU

///////////////////////////////////////////////////////////////

- (void)initMenu {
    [AbstractViewController setMenuEnableDelegate:self];
    
    [_menuViewController initWithPage:@"sidemenu.html"
                        andController:@"menu"];
    [_menuViewController setMenuSwitchDelegate:self];
    
    _menuEnabled = YES;
    _menuVisible = NO;
}

- (void)initRootViewController {
    RootViewController *rootViewController = (RootViewController *) _navigationController.topViewController;
    [rootViewController initWithPage:@"home.html"
                       andController:@"home"];
    [rootViewController setMenuToggleDelegate:self];
    
    _viewControllersForIdentifier = [NSMutableDictionary dictionaryWithDictionary:@{@"home": rootViewController}];
    _viewControllersSelected = @"home";
}

- (void)setViewControllersForIdentifier:(NSString *)identifier
                         withController:(NSString *)controller
                               withPage:(NSString *)page
                                andData:(NSDictionary *)data {
    NSArray *viewControllers = [_viewControllersForIdentifier objectForKey:identifier];
    if (viewControllers == nil) {
        RootViewController *viewController = (RootViewController *)[Cobalt cobaltViewControllerForController:controller
                                                                                                     andPage:page];
        [viewController setMenuToggleDelegate:self];
        if (data != nil) {
            viewController.navigationData = data;
        }
        
        viewControllers = [NSArray arrayWithObject:viewController];
        
        [_viewControllersForIdentifier setObject:viewControllers
                                          forKey:identifier];
    }
    
    if (_viewControllersSelected != nil) {
        [_viewControllersForIdentifier setObject:[_navigationController viewControllers]
                                          forKey:_viewControllersSelected];
    }
    
    [_navigationController setViewControllers:viewControllers
                                     animated:NO];
    
    _viewControllersSelected = identifier;
}

///////////////////////////////////////////////////////////////

#pragma mark MENU DELEGATE

///////////////////////////////////////////////////////////////

- (void)toggleMenu {
    if (! _menuVisible) {
        [self showMenu];
    }
    else {
        [self hideMenu];
    }
}

- (void)showMenu {
    [UIView animateWithDuration:SLIDE_TIMING * ((_menuContainerWidth.constant - _navigationControllerAlignLeading.constant) / _menuContainerWidth.constant)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _navigationControllerAlignLeading.constant = _menuContainerWidth.constant;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _menuVisible = YES;
                             [self updateMenuGestures];
                         }
                     }];
}

- (void)hideMenu {
    [UIView animateWithDuration:SLIDE_TIMING * (_navigationControllerAlignLeading.constant / _menuContainerWidth.constant)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _navigationControllerAlignLeading.constant = 0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _menuVisible = NO;
                             [self updateMenuGestures];
                         }
                     }];
}

- (void)setMenuEnabled:(BOOL)enabled {
    _menuEnabled = enabled;
    
    [self updateMenuGestures];
}

- (void)switchNavigationController:(NSString *)identifier
                    withController:(NSString *)controller
                          withPage:(NSString *)page
                           andData:(NSDictionary *)data {
    [self setViewControllersForIdentifier:identifier
                           withController:controller
                                 withPage:page
                                  andData:data];
    
    [self hideMenu];
}

///////////////////////////////////////////////////////////////

#pragma mark TOUCH DELEGATES

///////////////////////////////////////////////////////////////

- (void)initMenuGestures {
    _dragMenuGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(dragMenu:)];
    [_dragMenuGestureRecognizer setMinimumNumberOfTouches:1];
    [_dragMenuGestureRecognizer setMaximumNumberOfTouches:1];
    
    _closeMenuGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeMenu:)];
    [_closeMenuGestureRecognizer setNumberOfTouchesRequired:1];
    [_closeMenuGestureRecognizer setNumberOfTapsRequired:1];
}

- (void)updateMenuGestures {
    UIViewController *topViewController = [_navigationController topViewController];
    if (_menuEnabled) {
        [_navigationController.view addGestureRecognizer:_dragMenuGestureRecognizer];
        
        if (_menuVisible) {
            [_navigationController.view addGestureRecognizer:_closeMenuGestureRecognizer];
            if (topViewController != nil) {
                [topViewController.view setUserInteractionEnabled:NO];
            }
        }
        else {
            [_navigationController.view removeGestureRecognizer:_closeMenuGestureRecognizer];
            if (topViewController != nil) {
                [topViewController.view setUserInteractionEnabled:YES];
            }
        }
    }
    else {
        [_navigationController.view removeGestureRecognizer:_dragMenuGestureRecognizer];
        [_navigationController.view removeGestureRecognizer:_closeMenuGestureRecognizer];
        if (topViewController != nil) {
            [topViewController.view setUserInteractionEnabled:YES];
        }
    }
}

- (void)dragMenu:(id)sender {
    UIView *gestureView = [(UIPanGestureRecognizer *)sender view];
    [[gestureView layer] removeAllAnimations];
    
    UIGestureRecognizerState gestureState = [(UIPanGestureRecognizer *)sender state];
    switch (gestureState) {
        case UIGestureRecognizerStateChanged:
            // Note: just a fucking self assign cause var declaration just after a case instruction raise an error in C... What a mess!
            gestureState = gestureState;
            
            CGPoint gestureTranslation = [(UIPanGestureRecognizer *)sender translationInView:[self view]];
            
            // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
            CGFloat newOriginX = _navigationControllerAlignLeading.constant + [gestureView frame].origin.x + gestureTranslation.x;
            if (newOriginX >= 0
                && newOriginX <= _menuContainerWidth.constant) {
                _navigationControllerAlignLeading.constant = newOriginX;
                [[self view] layoutIfNeeded];
            }
            
            // Are you more than halfway? If so, show the menu when done dragging by setting this value to YES.
            _menuRevealed = newOriginX > _menuContainerWidth.constant / 2;
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0)
                                                      inView:[self view]];
            break;
        case UIGestureRecognizerStateEnded:
            if (_menuRevealed) {
                [self showMenu];
            }
            else {
                [self hideMenu];
            }
            break;
        default:
            break;
    }
}

- (void)closeMenu:(id)sender {
    switch ([(UITapGestureRecognizer *)sender state]) {
        case UIGestureRecognizerStateEnded:
            [self hideMenu];
            break;
        default:
            break;
    }
}

@end
