//
//  AZTableViewController.m
//  115SpeedUp
//
//  Created by Aladdin on 3/8/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import "AZTableViewController.h"
#import "AZ115URL.h"
#import "AZDownloadTask.h"
@implementation AZTableViewController

@synthesize downloadArray;
@synthesize listTableView;
- (id)init{
	self = [super init];
	if (self) {
		self.downloadArray = [NSMutableArray arrayWithCapacity:10];
	}
	return self;
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
	return [downloadArray count];
}

- (NSCell *)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
	AZDownloadTask * task = [self.downloadArray objectAtIndex:row];
	task.adelegate = self;
	task.curIndex = row;
//	AZ115URL * tempURL = [self.downloadArray objectAtIndex:row];
	if ([[tableColumn identifier] isEqualToString:@"filename"] ) {
		[(NSTextFieldCell*)[tableColumn dataCell] setStringValue:task.az115URL.fileNameString];
	}
	if ([[tableColumn identifier] isEqualToString:@"progress"] ) {
		if (!task.curProgress) {
			[(NSLevelIndicatorCell *)[tableColumn dataCell] setDoubleValue:0.0];
		}else {
			[(NSLevelIndicatorCell *)[tableColumn dataCell] setDoubleValue:[task.curProgress doubleValue]];
		}
	}
	if ([[tableColumn identifier]isEqualToString:@"speed"]) {
		if (!task.curSpeed) {
			[(NSTextFieldCell *)[tableColumn dataCell] setStringValue:@"连接中..."];
		}else {
			[(NSTextFieldCell *)[tableColumn dataCell] setStringValue:task.curSpeed];
		}
	}
	return [tableColumn dataCell];
}
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
	AZDownloadTask * task = [self.downloadArray objectAtIndex:row];
	if ([[tableColumn identifier] isEqualToString:@"filename"] ) {
		[(NSTextFieldCell*)[tableColumn dataCell] setStringValue:task.az115URL.fileNameString];
	}
	if ([[tableColumn identifier] isEqualToString:@"progress"] ) {
		if (!task.curProgress) {
			[(NSLevelIndicatorCell *)[tableColumn dataCell] setDoubleValue:0.0];
		}else {
			[(NSLevelIndicatorCell *)[tableColumn dataCell] setDoubleValue:[task.curProgress doubleValue]];
		}
	}
	if ([[tableColumn identifier]isEqualToString:@"speed"]) {
		if (!task.curSpeed) {
			[(NSTextFieldCell *)[tableColumn dataCell] setStringValue:@"连接中..."];
		}else {
			[(NSTextFieldCell *)[tableColumn dataCell] setStringValue:task.curSpeed];
		}
	}
}

- (void)dealloc
{
	[listTableView release];
	listTableView = nil;

	[downloadArray release];
	downloadArray = nil;

	[super dealloc];
}

#pragma mark AZDownloadTaskDelegate
- (void)downloadWillBegin:(AZDownloadTask*)task{

}
- (void)downloadUpdateSpeed:(NSString *)speed andProgress:(NSString*)progress{
	NSDictionary * uiDic = [NSDictionary dictionaryWithObjectsAndKeys:speed,@"speedValue",progress,@"progressLevelValue",nil];
	
 	[self performSelectorOnMainThread:@selector(updateUI:) withObject:uiDic waitUntilDone:NO];
}
- (void)updateUI:(NSDictionary*)dic{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[self.listTableView reloadData];
//	[self.progressLevelIndicator setDoubleValue:[[dic objectForKey:@"progressLevelValue"] doubleValue]];
//	[self.downloadBtn setTitle:[dic objectForKey:@"speedValue"]];	
	[pool release];
}
- (void)downloadDidEnd:(AZDownloadTask*)manager{
//	[self enableAndClear:YES];
	[self.listTableView reloadData];
}
- (void) enableAndClear:(BOOL)YesOrNo{
//	if(YesOrNo){
//		[self.input115URLTextField setStringValue:@""];
//		[self.progressLevelIndicator setDoubleValue:0.0];
//	}
//	[self.downloadBtn setTitle:@"下载"];
//	[self.downloadBtn setEnabled:YES];
//	[self.input115URLTextField setEditable:YES];
//	[self.input115URLTextField setEnabled:YES];
//	[self.speedSlider setEnabled:YES];
//	[self.networkComboBox setEnabled:YES];
//	[self.changePathBtn setEnabled:YES];
}
- (void) disableUIWithString:(NSString *)str{
//	[self.downloadBtn setTitle:str];
//	[self.downloadBtn setEnabled:NO];
//	[self.input115URLTextField setEditable:NO];
//	[self.input115URLTextField setEnabled:NO];
//	[self.speedSlider setEnabled:NO];
//	[self.networkComboBox setEnabled:NO];
//	[self.changePathBtn setEnabled:NO];
}


@end
