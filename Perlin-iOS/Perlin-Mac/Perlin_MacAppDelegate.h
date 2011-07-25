//
//  Perlin_MacAppDelegate.h
//  Perlin-Mac
//
//  Created by Rob Keniger on 25/07/11.
//  Copyright 2011 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Perlin_MacAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
