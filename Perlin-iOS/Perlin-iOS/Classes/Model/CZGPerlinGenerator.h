//
//  CZGPerlinGenerator.h
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PERMUTATION_SIZE 256

@interface CZGPerlinGenerator : NSObject {
   int permut[PERMUTATION_SIZE];
}

@property (nonatomic, assign) NSUInteger octaves;
@property (nonatomic, assign) float persistence;
@property (nonatomic, assign) float zoom;

+ (CZGPerlinGenerator *) perlinGenerator;

- (float) perlinNoiseX: (float) x y: (float) y z: (float) z t: (float) t;


@end
