//
//  DefaultViewController.h
//  Cobaltians
//
//  Created by Sébastien Vitard on 22/12/2015.
//  Copyright (c) 2015 Cobaltians. All rights reserved.
//

#import "Cobalt.h"

@protocol MenuDelegate <NSObject>

@required

- (void)switchNavigationController:(NSString *)name
                    withController:(NSString *)controller
                          withPage:(NSString *)page
                           andData:(NSDictionary *)data;

@end

@interface DefaultViewController : CobaltViewController <CobaltDelegate>

+ (void)setDelegate:(id<MenuDelegate>)delegate;

@end
