//
//  AZDowloadViewController.m
//  115SpeedUp
//
//  Created by Aladdin on 3/16/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import "AZDowloadViewController.h"
#import "AZDownloadConfig.h"
#import "AZDownloadTask.h"
#import "_15SpeedUpAppDelegate.h"
#import "AZ115URL.h"
@implementation AZDowloadViewController

@synthesize tableVC;
@synthesize changePathBtn;
@synthesize speedLimitTextField;
@synthesize window;
@synthesize progressLevelIndicator;
@synthesize input115URLTextField;
@synthesize downloadBtn;
@synthesize speedSlider;
@synthesize networkComboBox;
@synthesize pathField;

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[window release];
	window = nil;
	[progressLevelIndicator release];
	progressLevelIndicator = nil;
	[input115URLTextField release];
	input115URLTextField = nil;
	[downloadBtn release];
	downloadBtn = nil;
	[speedSlider release];
	speedSlider = nil;
	[networkComboBox release];
	networkComboBox = nil;
	[pathField release];
	pathField = nil;

	[speedLimitTextField release];
	speedLimitTextField = nil;

	[changePathBtn release];
	changePathBtn = nil;

	[tableVC release];
	tableVC = nil;

	[super dealloc];
}

- (void)awakeFromNib{
	[self.pathField setStringValue:[[AZDownloadConfig sharedInstance] targetPath]];
	[self.networkComboBox selectItemAtIndex:[[AZDownloadConfig sharedInstance] network]];
	[self.speedSlider setDoubleValue:[[AZDownloadConfig sharedInstance] speedLimit]];
	[self.speedLimitTextField setStringValue:[[AZDownloadConfig sharedInstance] speedLimitString]];
	[self.networkComboBox setDelegate:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNews:) name:@"DownloadNews" object:nil];
}
- (void)updateNews:(NSNotification *)n{
	[self.window setTitle: [[n userInfo] objectForKey:@"news"]];
}
- (BOOL)check115URL{
	if(![[self.input115URLTextField stringValue] hasPrefix:@"http://u.115.com/file/"]){
		return NO;
	}
	return YES;
}


- (IBAction) actionsToSelectPath:(id)sender{
	NSOpenPanel *openPanel;
	
    openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
	[openPanel setCanChooseFiles:NO	];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setResolvesAliases:YES];
	
    if ([openPanel runModalForTypes:nil] == NSOKButton)
    {
        NSArray *filesToOpen = [openPanel filenames];
        NSString *theFilePath = [filesToOpen objectAtIndex:0];	
		[[AZDownloadConfig sharedInstance] setTargetPath:theFilePath];
		[self.pathField setStringValue:[[AZDownloadConfig sharedInstance] targetPath]];
		[[AZDownloadConfig sharedInstance] save];
    }
}
- (IBAction) actionsToDownload:(id)sender{
	if(![self check115URL]){
		NSAlert * theAlert = [NSAlert alertWithMessageText:@"115下载页面链接格式错误"
											 defaultButton:@"好，重新输入"
										   alternateButton:nil
											   otherButton:nil
								 informativeTextWithFormat:@"请输入115下载页面的链接，类似这样的：http://u.115.com/file/t5fbf18c0a"];
		
		[theAlert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
		return;
	}
	//[self disableUIWithString:@"连接中..."];
	
	NSDictionary * newsDic = [NSDictionary dictionaryWithObject:@"开始获取下载链接" forKey:@"news"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNews" object:nil userInfo:newsDic];
	AZ115URL * a115URL = [[[AZ115URL alloc] init] autorelease];
	[a115URL getURLsFrom115ApiWithURL:[input115URLTextField stringValue]];
	AZDownloadTask * aTask = [[[AZDownloadTask alloc] init] autorelease];
	[aTask performSelector:@selector(taskWith115URL:) withObject:a115URL afterDelay:0.5];
//	[aTask setAdelegate:self];
	
	[self.tableVC.downloadArray addObject:aTask];
	[self.tableVC.listTableView reloadData];
}
- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
	[[AZDownloadConfig sharedInstance] setNetwork:[self.networkComboBox indexOfSelectedItem]];
	[[AZDownloadConfig sharedInstance] save];
}
- (IBAction) actionsToLimitSpeed:(id)sender{
	[[AZDownloadConfig sharedInstance] setSpeedLimit:[self.speedSlider doubleValue]];
	[self.speedLimitTextField setStringValue:[[AZDownloadConfig sharedInstance] speedLimitString]];
}
#pragma mark AZDownloadTaskDelegate
- (void)downloadWillBegin:(AZDownloadTask*)manager{
	[self.progressLevelIndicator setDoubleValue:0.0];
}
- (void)downloadUpdateSpeed:(NSString *)speed andProgress:(NSString*)progress{
	NSDictionary * uiDic = [NSDictionary dictionaryWithObjectsAndKeys:speed,@"speedValue",progress,@"progressLevelValue",nil];
	
 	[self performSelectorOnMainThread:@selector(updateUI:) withObject:uiDic waitUntilDone:NO];
}
- (void)updateUI:(NSDictionary*)dic{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[self.progressLevelIndicator setDoubleValue:[[dic objectForKey:@"progressLevelValue"] doubleValue]];
	[self.downloadBtn setTitle:[dic objectForKey:@"speedValue"]];	
	[pool release];
}
- (void)downloadDidEnd:(AZDownloadTask*)manager{
	[self enableAndClear:YES];
}
- (void) enableAndClear:(BOOL)YesOrNo{
	if(YesOrNo){
		[self.input115URLTextField setStringValue:@""];
		[self.progressLevelIndicator setDoubleValue:0.0];
	}
	[self.downloadBtn setTitle:@"下载"];
	[self.downloadBtn setEnabled:YES];
	[self.input115URLTextField setEditable:YES];
	[self.input115URLTextField setEnabled:YES];
	[self.speedSlider setEnabled:YES];
	[self.networkComboBox setEnabled:YES];
	[self.changePathBtn setEnabled:YES];
}
- (void) disableUIWithString:(NSString *)str{
	[self.downloadBtn setTitle:str];
	[self.downloadBtn setEnabled:NO];
	[self.input115URLTextField setEditable:NO];
	[self.input115URLTextField setEnabled:NO];
	[self.speedSlider setEnabled:NO];
	[self.networkComboBox setEnabled:NO];
	[self.changePathBtn setEnabled:NO];
}

@end
