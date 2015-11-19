//
//  CZGPerlinGenerator.m
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

// For references on the Perlin algorithm:
// Each of these has a slightly different way of explaining Perlin noise.  They were all useful:
// Overviews of Perlin: http://paulbourke.net/texture_colour/perlin/ and http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
// Awesome C++ tutorial on Perlin: http://www.dreamincode.net/forums/topic/66480-perlin-noise/

#import "CZGPerlinGenerator.h"
#import <math.h>


static const char gradient[32][4] =
{
   { 1, 1, 1, 0}, { 1, 1, 0, 1}, { 1, 0, 1, 1}, { 0, 1, 1, 1},
   { 1, 1, -1, 0}, { 1, 1, 0, -1}, { 1, 0, 1, -1}, { 0, 1, 1, -1},
   { 1, -1, 1, 0}, { 1, -1, 0, 1}, { 1, 0, -1, 1}, { 0, 1, -1, 1},
   { 1, -1, -1, 0}, { 1, -1, 0, -1}, { 1, 0, -1, -1}, { 0, 1, -1, -1},
   {-1, 1, 1, 0}, {-1, 1, 0, 1}, {-1, 0, 1, 1}, { 0, -1, 1, 1},
   {-1, 1, -1, 0}, {-1, 1, 0, -1}, {-1, 0, 1, -1}, { 0, -1, 1, -1},
   {-1, -1, 1, 0}, {-1, -1, 0, 1}, {-1, 0, -1, 1}, { 0, -1, -1, 1},
   {-1, -1, -1, 0}, {-1, -1, 0, -1}, {-1, 0, -1, -1}, { 0, -1, -1, -1},
};

@interface CZGPerlinGenerator (Private)

- (float) interpolateA: (float)a b: (float) b x: (float) x;
- (float) smoothNoiseX: (float) x y: (float) y z: (float) z t: (float) t;
- (int) gradientAtX: (int) i y: (int)j z: (int)k t: (int)l;
- (float) productOfA: (float) a b: (char) b;

@end

@implementation CZGPerlinGenerator

@synthesize octaves, persistence, zoom;

+ (CZGPerlinGenerator *) perlinGenerator {
   return [[CZGPerlinGenerator alloc] init];
}

- (id) init {
   if ((self = [super init])) {
      for (unsigned int i = 0; i < PERMUTATION_SIZE; i++) {
         permut[i] = rand() & 0xff;
         octaves = 1;
         persistence = 1.0;
         zoom = 1.0;
      }
   }
   return self;
}

- (int) gradientAtX: (const int) i y: (const int)j z: (const int)k t: (const int)l {
      return (permut[(l + permut[(k + permut[(j + permut[i & 0xff])
                                             & 0xff])
                                 & 0xff])
                     & 0xff]
              & 0x1f);
}

- (float) productOfA: (const float) a b: (const char) b {
   if (b > 0)
      return a;
   if (b < 0)
      return -a;
   return 0;
}

- (float) dotProductX0: (const float) x0 x1: (const char) x1 
                    y0: (const float) y0 y1: (const char) y1 
                    z0: (const float) z0 z1: (const char) z1 
                    t0: (const float) t0 t1: (const char) t1 {
   return   [self productOfA: x0 b: x1] +
            [self productOfA: y0 b: y1] +
            [self productOfA: z0 b: z1] +
            [self productOfA: t0 b: t1];
}

- (float) spline: (const float) state {
   const float square = state * state;
   const float cubic = square * state;
   return cubic * (6 * square - 15 * state + 10);
}

- (float) interpolateA: (const float)a b: (const float) b x: (const float) x {
   return a + x*(b-a);
}

- (float) perlinNoiseX: (const float) x y: (const float) y z: (const float) z t: (const float) t {
   float noise = 0.0;
   for (NSUInteger octave = 0; octave<self.octaves; octave++) {
      float frequency = pow(2,octave);
      float amplitude = pow(self.persistence, octave);
      noise += [self smoothNoiseX: x * frequency/zoom 
                                y: y * frequency/zoom 
                                z: z * frequency/zoom 
                                t: t * frequency/zoom] * amplitude;
   }
   return noise; 
}


- (float) smoothNoiseX: (const float) x y: (const float) y z: (const float) z t: (const float) t {
   const int x0 = (int) (x > 0 ? x : x - 1);
   const int y0 = (int) (y > 0 ? y : y - 1);
   const int z0 = (int) (z > 0 ? z : z - 1);
   const int t0 = (int) (t > 0 ? t : t - 1);
   
   const int x1 = x0+1;
   const int y1 = y0+1;
   const int z1 = z0+1;
   const int t1 = t0+1;
   
   // The vectors
   float dx0 = x-x0;
   float dy0 = y-y0;
   float dz0 = z-z0;
   float dt0 = t-t0;
   const float dx1 = x-x1;
   const float dy1 = y-y1;
   const float dz1 = z-z1;
   const float dt1 = t-t1;

   // The 16 gradient values
   const char * g0000 = gradient[[self gradientAtX: x0 y: y0 z: z0 t: t0]];
   const char * g0001 = gradient[[self gradientAtX: x0 y: y0 z: z0 t: t1]];
   const char * g0010 = gradient[[self gradientAtX: x0 y: y0 z: z1 t: t0]];
   const char * g0011 = gradient[[self gradientAtX: x0 y: y0 z: z1 t: t1]];
   const char * g0100 = gradient[[self gradientAtX: x0 y: y1 z: z0 t: t0]];
   const char * g0101 = gradient[[self gradientAtX: x0 y: y1 z: z0 t: t1]];
   const char * g0110 = gradient[[self gradientAtX: x0 y: y1 z: z1 t: t0]];
   const char * g0111 = gradient[[self gradientAtX: x0 y: y1 z: z1 t: t1]];
   const char * g1000 = gradient[[self gradientAtX: x1 y: y0 z: z0 t: t0]];
   const char * g1001 = gradient[[self gradientAtX: x1 y: y0 z: z0 t: t1]];
   const char * g1010 = gradient[[self gradientAtX: x1 y: y0 z: z1 t: t0]];
   const char * g1011 = gradient[[self gradientAtX: x1 y: y0 z: z1 t: t1]];
   const char * g1100 = gradient[[self gradientAtX: x1 y: y1 z: z0 t: t0]];
   const char * g1101 = gradient[[self gradientAtX: x1 y: y1 z: z0 t: t1]];
   const char * g1110 = gradient[[self gradientAtX: x1 y: y1 z: z1 t: t0]];
   const char * g1111 = gradient[[self gradientAtX: x1 y: y1 z: z1 t: t1]];
   
   //NSLog(@"y=%f", y);
   //NSLog(@"y0 =  %d, g0000[1] = %d", y0, (int)g0000[1]);
   //NSLog(@"y1 = %d, g0100[1] = %d", y1, (int)g0100[1]);
   
   // The 16 dot products
   const float b0000 = [self dotProductX0: dx0 x1: g0000[0] y0: dy0 y1: g0000[1] z0: dz0 z1: g0000[2] t0: dt0 t1: g0000[3]];
   const float b0001 = [self dotProductX0: dx0 x1: g0001[0] y0: dy0 y1: g0001[1] z0: dz0 z1: g0001[2] t0: dt1 t1: g0001[3]];
   const float b0010 = [self dotProductX0: dx0 x1: g0010[0] y0: dy0 y1: g0010[1] z0: dz1 z1: g0010[2] t0: dt0 t1: g0010[3]];
   const float b0011 = [self dotProductX0: dx0 x1: g0011[0] y0: dy0 y1: g0011[1] z0: dz1 z1: g0011[2] t0: dt1 t1: g0011[3]];
   const float b0100 = [self dotProductX0: dx0 x1: g0100[0] y0: dy1 y1: g0100[1] z0: dz0 z1: g0100[2] t0: dt0 t1: g0100[3]];
   const float b0101 = [self dotProductX0: dx0 x1: g0101[0] y0: dy1 y1: g0101[1] z0: dz0 z1: g0101[2] t0: dt1 t1: g0101[3]];
   const float b0110 = [self dotProductX0: dx0 x1: g0110[0] y0: dy1 y1: g0110[1] z0: dz1 z1: g0110[2] t0: dt0 t1: g0110[3]];
   const float b0111 = [self dotProductX0: dx0 x1: g0111[0] y0: dy1 y1: g0111[1] z0: dz1 z1: g0111[2] t0: dt1 t1: g0111[3]];
   const float b1000 = [self dotProductX0: dx1 x1: g1000[0] y0: dy0 y1: g1000[1] z0: dz0 z1: g1000[2] t0: dt0 t1: g1000[3]];
   const float b1001 = [self dotProductX0: dx1 x1: g1001[0] y0: dy0 y1: g1001[1] z0: dz0 z1: g1001[2] t0: dt1 t1: g1001[3]];
   const float b1010 = [self dotProductX0: dx1 x1: g1010[0] y0: dy0 y1: g1010[1] z0: dz1 z1: g1010[2] t0: dt0 t1: g1010[3]];
   const float b1011 = [self dotProductX0: dx1 x1: g1011[0] y0: dy0 y1: g1011[1] z0: dz1 z1: g1011[2] t0: dt1 t1: g1011[3]];
   const float b1100 = [self dotProductX0: dx1 x1: g1100[0] y0: dy1 y1: g1100[1] z0: dz0 z1: g1100[2] t0: dt0 t1: g1100[3]];
   const float b1101 = [self dotProductX0: dx1 x1: g1101[0] y0: dy1 y1: g1101[1] z0: dz0 z1: g1101[2] t0: dt1 t1: g1101[3]];
   const float b1110 = [self dotProductX0: dx1 x1: g1110[0] y0: dy1 y1: g1110[1] z0: dz1 z1: g1110[2] t0: dt0 t1: g1110[3]];
   const float b1111 = [self dotProductX0: dx1 x1: g1111[0] y0: dy1 y1: g1111[1] z0: dz1 z1: g1111[2] t0: dt1 t1: g1111[3]];
   
   //NSLog(@"b0000 = %f, b0100 = %f", b0000, b0100);
   
   dx0 = [self spline: dx0];
   dy0 = [self spline: dy0];
   dz0 = [self spline: dz0];
   dt0 = [self spline: dt0];
   
   const float b111 = [self interpolateA: b1110 b: b1111 x: dt0];
   const float b110 = [self interpolateA: b1100 b: b1101 x: dt0];
   const float b101 = [self interpolateA: b1010 b: b1011 x: dt0];
   const float b100 = [self interpolateA: b1000 b: b1001 x: dt0];
   const float b011 = [self interpolateA: b0110 b: b0111 x: dt0];
   const float b010 = [self interpolateA: b0100 b: b0101 x: dt0];
   const float b001 = [self interpolateA: b0010 b: b0011 x: dt0];
   const float b000 = [self interpolateA: b0000 b: b0001 x: dt0];
   
   //NSLog(@"b000 = %f, b010 = %f", b000, b010);
   
   const float b11 = [self interpolateA: b110 b: b111 x: dz0];
   const float b10 = [self interpolateA: b100 b: b101 x: dz0];
   const float b01 = [self interpolateA: b010 b: b011 x: dz0];
   const float b00 = [self interpolateA: b000 b: b001 x: dz0];
   
   //NSLog(@"b00 = %f, b01 = %f", b00, b01);
   //NSLog(@"b10 = %f, b11 = %f", b10, b11);
   
   const float b1 = [self interpolateA: b10 b: b11 x: dy0];
   const float b0 = [self interpolateA: b00 b: b01 x: dy0];
   
   //NSLog(@"b0 = %f, b1 = %f", b0, b1);
   
   const float result = [self interpolateA: b0 b: b1 x: dx0];
   
   //NSLog(@"result = %f", result);
   
   return result;
}


@end
