//
//  MainViewController.m
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "MainViewController.h"
#import "CZGPerlinGenerator.h"
#import "UIImage+CZGPerlin.h"

@implementation MainViewController

@synthesize perlinGenerator, imageView, timeLabel, colorScheme, persistenceLabel, zoomLabel, colorLabel;

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

#pragma mark controls

- (IBAction)zoomChanged: (UISlider *) src {
   self.perlinGenerator.zoom = src.value;
   self.zoomLabel.text = [NSString stringWithFormat: @"%d", (int)src.value];
   [self generateImage];
}

- (IBAction)persistenceChanged: (UISlider *) src {
   self.perlinGenerator.persistence = src.value;
   self.persistenceLabel.text = [NSString stringWithFormat: @"%1.2f", src.value];
   [self generateImage];
}

- (IBAction)octavesSelected: (UISegmentedControl *) src {
   self.perlinGenerator.octaves = src.selectedSegmentIndex + 1;
   [self generateImage];
}

- (IBAction)chooseColor: (UIButton *) src {
   UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"Choose Color Scheme" 
                                                            delegate: self 
                                                   cancelButtonTitle: @"Cancel" 
                                              destructiveButtonTitle: nil 
                                                   otherButtonTitles: @"Clouds", @"Paper", nil];
   [actionSheet showFromRect: self.view.bounds inView: self.view animated: YES];
   [actionSheet release];
}

#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
   self.colorScheme = buttonIndex;
   self.colorLabel.text = [actionSheet buttonTitleAtIndex: buttonIndex];
   [self generateImage];
}

#pragma mark image generation

- (void) generateImage {
   NSLog(@"Begin generating image");
   NSDate *start = [NSDate date];
   UIImage *image = nil;
   switch (self.colorScheme) {
      case ColorSchemeClouds:
         image = [UIImage skyWithPerlinGenerator: self.perlinGenerator size: CGSizeMake(200,300)];
         break;
      case ColorSchemePaper:
         image = [UIImage paperWithPerlinGenerator: self.perlinGenerator size: CGSizeMake(400,600)];
         break;
      default:
         image = [UIImage skyWithPerlinGenerator: self.perlinGenerator size: CGSizeMake(200,300)];
         break;
   }
   
   NSTimeInterval time = [[NSDate date] timeIntervalSinceDate: start];
   self.timeLabel.text = [NSString stringWithFormat: @"Render time: %f", time];
   NSLog(@"Generated image");
   self.imageView.image = image;
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) viewDidLoad {
   self.perlinGenerator = [[[CZGPerlinGenerator alloc] init] autorelease];
   self.perlinGenerator.octaves = 1;
   self.perlinGenerator.zoom = 50;
   self.perlinGenerator.persistence = 0.5; //0.00001;
}

- (void) viewDidAppear: (BOOL) animated {
   [super viewDidAppear: animated];
   [self generateImage];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
   [imageView release];
   [timeLabel release];
   [perlinGenerator release];
   [persistenceLabel release];
   [colorLabel release];
   [zoomLabel release];
    [super dealloc];
}

@end
