//
//  UIImage+CZGPerlin.h
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CZGPerlinGenerator;

@interface UIImage (CZGPerlin)

+ (UIImage *) skyWithPerlinGenerator: (CZGPerlinGenerator *) generator size: (CGSize) size;
+ (UIImage *) paperWithPerlinGenerator: (CZGPerlinGenerator *) generator size: (CGSize) size;

@end
