//
//  Perlin_iOSAppDelegate.h
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface Perlin_iOSAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
