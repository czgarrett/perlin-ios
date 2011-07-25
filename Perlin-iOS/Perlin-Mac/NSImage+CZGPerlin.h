//
//  NSImage+CZGPerlin.h
//  Perlin-iOS
//
//  Created by Rob Keniger on 25/07/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <AppKit/AppKit.h>


@class CZGPerlinGenerator;

@interface NSImage (CZGPerlin)

+ (NSImage*)skyWithPerlinGenerator:(CZGPerlinGenerator*)generator size:(NSSize)size;
+ (NSImage*)paperWithPerlinGenerator:(CZGPerlinGenerator*)generator size:(NSSize)size;

@end
