//
//  AZDowloadViewController.h
//  115SpeedUp
//
//  Created by Aladdin on 3/16/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/Automator.h>
#import "AZWindow.h"
#import "AZDownloadTask.h"
#import "AZTableViewController.h"
@interface AZDowloadViewController : NSObject <NSComboBoxDelegate,AZDownloadTaskDelegate>{
	IBOutlet	AZWindow * window;
	IBOutlet	NSLevelIndicator * progressLevelIndicator;
	IBOutlet	NSTextField * input115URLTextField;
	IBOutlet	NSButton * downloadBtn;
	IBOutlet	NSButton * changePathBtn;
	IBOutlet	NSSlider * speedSlider;
	IBOutlet	NSComboBox * networkComboBox;
	IBOutlet	NSTextField * pathField;
	IBOutlet	NSTextField * speedLimitTextField;
	IBOutlet	AZTableViewController * tableVC;
}

@property (nonatomic, retain) AZTableViewController *tableVC;
@property (nonatomic, retain) NSButton *changePathBtn;
@property (nonatomic, retain) NSTextField *speedLimitTextField;
@property (nonatomic, retain) AZWindow *window;
@property (nonatomic, retain) NSLevelIndicator *progressLevelIndicator;
@property (nonatomic, retain) NSTextField *input115URLTextField;
@property (nonatomic, retain) NSButton *downloadBtn;
@property (nonatomic, retain) NSSlider *speedSlider;
@property (nonatomic, retain) NSComboBox *networkComboBox;
@property (nonatomic, retain) NSTextField *pathField;

- (IBAction) actionsToSelectPath:(id)sender;
- (IBAction) actionsToDownload:(id)sender;
- (IBAction) actionsToLimitSpeed:(id)sender;
- (void) disableUIWithString:(NSString *)str;
- (void) enableAndClear:(BOOL)YesOrNo;
@end
