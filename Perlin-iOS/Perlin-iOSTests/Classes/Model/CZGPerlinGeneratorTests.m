//
//  CZGPerlinGeneratorTests.m
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "CZGPerlinGeneratorTests.h"
#import "CZGPerlinGenerator.h"

@implementation CZGPerlinGeneratorTests

- (void) setUp {
   perlin = [[CZGPerlinGenerator alloc] init];
}

- (void) tearDown {
   [perlin release];
}

- (void)testNoise {
   BOOL someLessThanZero = NO;
   BOOL someGreaterThanZero = NO;
   srand(1);
   for (int i=0; i<100; i++) {
      float noise = [perlin perlinNoiseX: (float) rand() y: (float) rand() z: (float) rand() t: (float) rand()];
      STAssertTrue(noise > -1.0 && noise < 1.0, @"Noise should be between -1 and 1, was %f", noise );
      if (noise<0) someLessThanZero = YES;
      if (noise>0) someGreaterThanZero = YES;
   }
   STAssertTrue(someGreaterThanZero, @"Some noise should be >0" );
   STAssertTrue(someLessThanZero, @"Some noise should be <0" );
   
   // Make sure the function always returns the same values for a given x,y,z,t
   STAssertEquals([perlin perlinNoiseX: 3 y: 4 z: 5 t: 6], [perlin perlinNoiseX: 3 y: 4 z: 5 t: 6], @"Perlin noise should be the same for a given set of coordinates");
   
}

@end
