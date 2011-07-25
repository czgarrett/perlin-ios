//
//  Perlin_MacAppDelegate.m
//  Perlin-Mac
//
//  Created by Rob Keniger on 25/07/11.
//  Copyright 2011 Big Bang Software Pty Ltd. All rights reserved.
//

#import "Perlin_MacAppDelegate.h"
#import "CZGPerlinGenerator.h"
#import "NSImage+CZGPerlin.h"

static NSString* PerlinCtx = @"PerlinCtx";

@implementation Perlin_MacAppDelegate

@synthesize window;
@synthesize imageView;
@synthesize timeLabel;
@synthesize perlinGenerator;
@synthesize colorScheme;
@synthesize color1;
@synthesize color2;

- (id)init 
{
    self = [super init];
    if (self) 
	{
        perlinGenerator = [[CZGPerlinGenerator alloc] init];
		color1 = [[NSColor blackColor] retain];
		color2 = [[NSColor whiteColor] retain];
    }
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	perlinGenerator.octaves = 1;
	perlinGenerator.zoom = 50;
	perlinGenerator.persistence = 0.5; //0.00001;
	[self generateImage];
	
	//the UI uses Cocoa bindings so we need to observe for changes in the various keys and react when something interesting happens.
	//we don't need to clean up these observers because this object will not go away until the app quits.
	[perlinGenerator addObserver:self forKeyPath:@"octaves" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[perlinGenerator addObserver:self forKeyPath:@"zoom" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[perlinGenerator addObserver:self forKeyPath:@"persistence" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[self addObserver:self forKeyPath:@"color1" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[self addObserver:self forKeyPath:@"color2" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[self addObserver:self forKeyPath:@"colorScheme" options:NSKeyValueObservingOptionNew context:PerlinCtx];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == PerlinCtx) 
	{
		[self generateImage];
	} 
	else 
	{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
	[perlinGenerator release];
	perlinGenerator = nil;
	[color1 release];
	color1 = nil;
	[color2 release];
	color2 = nil;
	[super dealloc];
}

- (void) generateImage
{
	[self.timeLabel setStringValue:@"Rendering…"];
	NSSize imageSize = [self.imageView frame].size;
	/*
	 The image is rendered in the background so that the UI remains responsive.
	 The image rendering can be called several times in succession if the user changes parameters before the image rendering is complete,
	 but this will just make image updates pile up, they will be rendered eventually once the user leaves the UI alone.
	 Improving this (perhaps with NSOperation and some sort of cancellation mechanism) is left as an exercise for the reader!
	 */
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSLog(@"Begin generating image");
		NSDate *start = [NSDate date];
		NSImage *image = nil;
		switch (self.colorScheme) 
		{
			case ColorSchemePaper:
				image = [NSImage paperWithPerlinGenerator:self.perlinGenerator size:imageSize];
				break;
			case ColorSchemeCustom:
				image = [NSImage noiseWithPerlinGenerator:self.perlinGenerator size:imageSize firstColor:self.color1 secondColor:self.color2];
				break;
			case ColorSchemeClouds:
			default:
				image = [NSImage skyWithPerlinGenerator:self.perlinGenerator size:imageSize];
				break;
		}

		NSTimeInterval time = [[NSDate date] timeIntervalSinceDate: start];
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"Generated image");
			[self.timeLabel setStringValue:[NSString stringWithFormat: @"%f", time]];
			self.imageView.image = image;
		});
	});
	
}


//set up a dependent boolean property that we can use to control the visibility of the custom color wells
+ (NSSet*)keyPathsForValuesAffectingCustomColorInUse
{
	return [NSSet setWithObject:@"colorScheme"];
}

- (BOOL)customColorInUse
{
	return (self.colorScheme == ColorSchemeCustom);
}

	 
//this makes the app to create a new version of the image when the window is resized
- (void)windowDidEndLiveResize:(NSNotification *)notification
{
	[self generateImage];
}

@end
