//
//  NSImage+CZGPerlin.m
//  Perlin-iOS
//
//  Created by Rob Keniger on 25/07/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSImage+CZGPerlin.h"
#import "CZGPerlinGenerator.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSImage (CZGPerlin)

+ (NSImage*)skyWithPerlinGenerator:(CZGPerlinGenerator*)generator size:(NSSize)size
{
	NSImage* perlinImage = [[NSImage alloc] initWithSize:size];
	[perlinImage lockFocus];
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	
	CGContextSetRGBFillColor(ctx, 0.000, 0.868, 1.000, 1.000); // light blue
	CGContextFillRect(ctx, CGRectMake(0.0, 0.0, size.width, size.height));
	for (CGFloat x = 0.0; x < size.width; x+=1.0) {
		for (CGFloat y=0.0; y < size.height; y+=1.0) {
			CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, ABS([generator perlinNoiseX: x y: y z: 0 t: 0]));
			CGContextFillRect(ctx, CGRectMake(x, y, 1.0, 1.0));
		}
	}
	
	[perlinImage unlockFocus];
	return [perlinImage autorelease];
}

+ (NSImage *) paperWithPerlinGenerator: (CZGPerlinGenerator *) generator size: (NSSize) size 
{
	NSImage* perlinImage = [[NSImage alloc] initWithSize:size];
	[perlinImage lockFocus];
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	
	CGContextSetRGBFillColor(ctx, 0.936, 0.892, 0.779, 1.000); 
	CGContextFillRect(ctx, CGRectMake(0.0, 0.0, size.width, size.height));
	for (CGFloat x = 0.0; x < size.width; x+=1.0) {
		for (CGFloat y=0.0; y < size.height; y+=1.0) {
			CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.125 * ABS([generator perlinNoiseX: x y: y z: 0 t: 0]));
			CGContextFillRect(ctx, CGRectMake(x, y, 1.0, 1.0));
		}
	}
	[perlinImage unlockFocus];
	return [perlinImage autorelease];
}


@end