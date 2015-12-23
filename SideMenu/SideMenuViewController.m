//
//  SideMenuViewController.m
//  SideMenu
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright © 2015 Cobaltians. All rights reserved.
//

#import "SideMenuViewController.h"

#define MENU_WIDTH      100
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
    
    // Setup gesture
    _dragMenuGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(dragMenu:)];
    [_dragMenuGestureRecognizer setMinimumNumberOfTouches:1];
    [_dragMenuGestureRecognizer setMaximumNumberOfTouches:1];
    
    _closeMenuGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeMenu:)];
    [_closeMenuGestureRecognizer setNumberOfTouchesRequired:1];
    [_closeMenuGestureRecognizer setNumberOfTapsRequired:1];
    
    // Setup view
    [self setMenu];
    [self setNavController];
    
    _viewControllersForIdentifier = [NSMutableDictionary dictionaryWithCapacity:1];
    [self setViewControllersForIdentifier:@"home"
                           withController:@"withSidemenu"
                                 withPage:@"home.html"
                                  andData:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
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

///////////////////////////////////////////////////////////////

#pragma mark MENU

///////////////////////////////////////////////////////////////

- (void)setNavController {
    if (_navigationController == nil) {
        _navigationController = [[UINavigationController alloc] init];
        
        [self addChildViewController:_navigationController];
        [_navigationController didMoveToParentViewController:self];
        
        UIView *navigationControllerView = [_navigationController view];
        CALayer *navigationControllerViewLayer = [navigationControllerView layer];
        CGSize viewFrameSize = [[self view] frame].size;
        
        [navigationControllerView setFrame:CGRectMake(0, 0,
                                                      viewFrameSize.width,
                                                      viewFrameSize.height)];
        
        // set up view shadows
        [navigationControllerViewLayer setShadowColor:[UIColor blackColor].CGColor];
        [navigationControllerViewLayer setShadowOpacity:0.8];
        [navigationControllerViewLayer setShadowOffset:CGSizeMake(-2, -2)];
        
        [self.view addSubview:navigationControllerView];
    }
    
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
            viewController.pushedData = data;
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

- (void)setMenu {
    if (_menuViewController == nil) {
        [AbstractViewController setMenuEnableDelegate:self];
        
        _menuViewController = (MenuViewController *)[Cobalt cobaltViewControllerForController:@"menu"
                                                                                      andPage:@"sidemenu.html"];
        [_menuViewController setMenuSwitchDelegate:self];
        
        [self addChildViewController:_menuViewController];
        [_menuViewController didMoveToParentViewController:self];
        
        [self.view addSubview:_menuViewController.view];
        
        _menuEnabled = YES;
        _menuVisible = NO;
    }
    
    _menuViewController.view.frame = CGRectMake(0, 0, MENU_WIDTH, self.view.frame.size.height);
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
    [UIView animateWithDuration:SLIDE_TIMING * ((MENU_WIDTH - _navigationController.view.frame.origin.x) / MENU_WIDTH)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _navigationController.view.frame = CGRectMake(MENU_WIDTH, 0,
                                                                       self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _menuVisible = YES;
                             [self setNavController];
                         }
                     }];
}

- (void)hideMenu {
    [UIView animateWithDuration:SLIDE_TIMING * (_navigationController.view.frame.origin.x / MENU_WIDTH)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _navigationController.view.frame = CGRectMake(0, 0,
                                                                       self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _menuVisible = NO;
                             [self setNavController];
                         }
                     }];
}

- (void)setMenuEnabled:(BOOL)enabled {
    _menuEnabled = enabled;
    
    [self setNavController];
}

- (void)switchNavigationController:(NSString *)identifier
                    withController:(NSString *)controller
                          withPage:(NSString *)page
                           andData:(NSDictionary *)data {
    [self setViewControllersForIdentifier:identifier
                           withController:controller
                                 withPage:page
                                  andData:data];
    
    [self toggleMenu];
}

///////////////////////////////////////////////////////////////

#pragma mark TOUCH DELEGATES

///////////////////////////////////////////////////////////////

- (void)dragMenu:(id)sender {
    UIView *gestureView = [(UIPanGestureRecognizer *)sender view];
    [[gestureView layer] removeAllAnimations];
    
    CGPoint gestureTranslation = [(UIPanGestureRecognizer *)sender translationInView:self.view];
    CGRect gestureViewFrame = [gestureView frame];
    
    UIGestureRecognizerState gestureState = [(UIPanGestureRecognizer *)sender state];
    switch (gestureState) {
        case UIGestureRecognizerStateChanged:
            // Are you more than halfway? If so, show the menu when done dragging by setting this value to YES.
            _menuRevealed = gestureViewFrame.origin.x > MENU_WIDTH / 2;
            
            // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
            CGFloat newOriginX = gestureView.frame.origin.x + gestureTranslation.x;
            if (newOriginX >= 0
                && newOriginX <= MENU_WIDTH) {
                gestureView.frame = CGRectMake(newOriginX,
                                               gestureView.frame.origin.y,
                                               gestureView.frame.size.width,
                                               gestureView.frame.size.height);
            }
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0)
                                                      inView:self.view];
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

///////////////////////////////////////////////////////////////

#pragma mark ORIENTATION DELEGATE

///////////////////////////////////////////////////////////////

- (void)orientationDidChange:(NSNotification *)notification {
    [self setMenu];
}

@end
