//
//  UIImage+CZGPerlin.m
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "UIImage+CZGPerlin.h"
#import "CZGPerlinGenerator.h"

@implementation UIImage (CZGPerlin)

+ (CGContextRef) contextSetup: (CGSize) size {
	UIGraphicsBeginImageContext(size);		
	CGContextRef context = UIGraphicsGetCurrentContext();		
	UIGraphicsPushContext(context);								
   NSLog(@"Begin drawing");
   return context;
}

+ (UIImage *) finishImageContext {
   NSLog(@"End drawing");
   UIGraphicsPopContext();		
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
   [outputImage retain];
	UIGraphicsEndImageContext();
   return [outputImage autorelease];
}

+ (UIImage *) skyWithPerlinGenerator: (CZGPerlinGenerator *) generator size: (CGSize) size {
   
   CGContextRef ctx = [self contextSetup: size];
   
   CGContextSetRGBFillColor(ctx, 0.000, 0.868, 1.000, 1.000); // light blue
   CGContextFillRect(ctx, CGRectMake(0.0, 0.0, size.width, size.height));
   for (CGFloat x = 0.0; x<size.width; x+=1.0) {
      for (CGFloat y=0.0; y< size.height; y+=1.0) {
         CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, ABS([generator perlinNoiseX: x y: y z: 0 t: 0]));
         CGContextFillRect(ctx, CGRectMake(x, y, 1.0, 1.0));
      }
   }
   
   return [self finishImageContext];
}

+ (UIImage *) paperWithPerlinGenerator: (CZGPerlinGenerator *) generator size: (CGSize) size {
   
   CGContextRef ctx = [self contextSetup: size];
   
   CGContextSetRGBFillColor(ctx, 0.936, 0.892, 0.779, 1.000); 
   CGContextFillRect(ctx, CGRectMake(0.0, 0.0, size.width, size.height));
   for (CGFloat x = 0.0; x<size.width; x+=1.0) {
      for (CGFloat y=0.0; y< size.height; y+=1.0) {
         CGContextSetRGBFillColor(ctx, 0.0, 0.0, 0.0, 0.125 * ABS([generator perlinNoiseX: x y: y z: 0 t: 0]));
         CGContextFillRect(ctx, CGRectMake(x, y, 1.0, 1.0));
      }
   }
   
   return [self finishImageContext];
}


@end
