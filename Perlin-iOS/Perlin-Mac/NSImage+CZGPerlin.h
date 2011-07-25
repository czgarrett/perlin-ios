//
//  NSImage+CZGPerlin.h
//  Perlin-Mac
//
//  Created by Rob Keniger on 25/07/11.
//  Copyright 2011 Big Bang Software Pty Ltd. All rights reserved.
//
//  Based on code created by Christopher Garrett
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.

#import <AppKit/AppKit.h>


@class CZGPerlinGenerator;

@interface NSImage (CZGPerlin)

+ (NSImage*)skyWithPerlinGenerator:(CZGPerlinGenerator*)generator size:(NSSize)size;
+ (NSImage*)paperWithPerlinGenerator:(CZGPerlinGenerator*)generator size:(NSSize)size;
+ (NSImage*)noiseWithPerlinGenerator:(CZGPerlinGenerator*)generator size:(NSSize)size firstColor:(NSColor*)color1 secondColor:(NSColor*)color2;

@end
