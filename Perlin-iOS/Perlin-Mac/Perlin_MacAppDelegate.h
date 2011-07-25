//
//  Perlin_MacAppDelegate.h
//  Perlin-Mac
//
//  Created by Rob Keniger on 25/07/11.
//  Copyright 2011 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CZGPerlinGenerator;

typedef enum {
	ColorSchemeClouds = 0,
	ColorSchemePaper,
	ColorSchemeCustom
} ColorScheme;

@interface Perlin_MacAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
	NSWindow *window;
	NSImageView *imageView;
	NSTextField *timeLabel;
	NSColor* color1;
	NSColor* color2;
}

@property (retain) CZGPerlinGenerator *perlinGenerator;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imageView;
@property (assign) IBOutlet NSTextField *timeLabel;

@property ColorScheme colorScheme;
@property (retain) NSColor* color1;
@property (retain) NSColor* color2;
@property (readonly) BOOL customColorInUse;

- (void)generateImage;

@end
