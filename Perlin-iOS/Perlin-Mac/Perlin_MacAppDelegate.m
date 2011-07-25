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

- (id)init 
{
    self = [super init];
    if (self) 
	{
        perlinGenerator = [[CZGPerlinGenerator alloc] init];
    }
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	perlinGenerator.octaves = 1;
	perlinGenerator.zoom = 50;
	perlinGenerator.persistence = 0.5; //0.00001;
	[self generateImage];
	[perlinGenerator addObserver:self forKeyPath:@"octaves" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[perlinGenerator addObserver:self forKeyPath:@"zoom" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[perlinGenerator addObserver:self forKeyPath:@"persistence" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[self addObserver:self forKeyPath:@"colorScheme" options:NSKeyValueObservingOptionNew context:PerlinCtx];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidEndLiveResize:) name:NSWindowDidEndLiveResizeNotification object:self.window];
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
	[super dealloc];
}

- (void) generateImage
{
	[self.timeLabel setStringValue:@"Rendering…"];
	NSSize imageSize = [self.imageView frame].size;
	/*
	 The image is rendered in the background so that the UI remains responsive.
	 the image rendering can be called several times in succession, but this will just make
	 image updates pile up, they will be rendered eventually.
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
	 
	 
	 

- (void)windowDidEndLiveResize:(NSNotification *)notification
{
	[self generateImage];
}

@end
