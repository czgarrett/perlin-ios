//
//  MainViewController.h
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "FlipsideViewController.h"

@class CZGPerlinGenerator;

typedef enum {
   ColorSchemeClouds = 0,
   ColorSchemePaper
} ColorScheme;


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIActionSheetDelegate> {

}

@property (nonatomic, retain) CZGPerlinGenerator *perlinGenerator;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *persistenceLabel;
@property (nonatomic, retain) IBOutlet UILabel *zoomLabel;
@property (nonatomic, retain) IBOutlet UILabel *colorLabel;

@property (nonatomic, assign) ColorScheme colorScheme;

- (IBAction)showInfo:(id)sender;

- (IBAction)zoomChanged: (UISlider *) src;
- (IBAction)persistenceChanged: (UISlider *) src;
- (IBAction)octavesSelected: (UISegmentedControl *) src;
- (IBAction)chooseColor: (UIButton *) src;

- (void) generateImage;

@end
