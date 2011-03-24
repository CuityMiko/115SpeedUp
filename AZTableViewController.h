//
//  AZTableViewController.h
//  115SpeedUp
//
//  Created by Aladdin on 3/8/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZDownloadTask.h"

@interface AZTableViewController : NSObject<NSTableViewDelegate,NSTableViewDataSource,AZDownloadTaskDelegate> {
	NSTableView * listTableView;
	
	NSMutableArray * downloadArray;
}

@property (nonatomic, retain) NSMutableArray *downloadArray;
@property (nonatomic, retain) IBOutlet NSTableView *listTableView;

@end
