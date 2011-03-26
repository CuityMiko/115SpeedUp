//
//  AZDownloadManager.m
//  115SpeedUp
//
//  Created by Aladdin on 3/8/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import "AZDownloadTask.h"
#import "AZ115URL.h"
#import "AZDownloadConfig.h"
@implementation AZDownloadTask

@synthesize curIndex;
@synthesize curTread;
@synthesize az115URL;
@synthesize curSpeed;
@synthesize curProgress;
@synthesize outFileHandle;
@synthesize adelegate;
@synthesize aTask;
- (id)init{
	self = [super init];
	if (self) {
		self.aTask = [[NSTask alloc] init];
		[aTask setLaunchPath:[[NSBundle mainBundle] pathForResource:@"axel" ofType:nil]];
		NSPipe * outPipe = [[NSPipe alloc]init];
		[aTask setStandardOutput:outPipe];
		self.outFileHandle = [outPipe fileHandleForReading];
		
	}
	return self;
}

- (void)dealloc
{
	[aTask release];
	aTask = nil;
	[outFileHandle release];
	outFileHandle = nil;

	[curSpeed release];
	curSpeed = nil;
	[curProgress release];
	curProgress = nil;

	[az115URL release];
	az115URL = nil;

	[curTread release];
	curTread = nil;


	[super dealloc];
}
- (void)taskWith115URL:(AZ115URL*)a115URL{
	self.curTread = [[NSThread alloc] initWithTarget:self selector:@selector(startWith115URL:) object:a115URL];
	[self.curTread start];
}
- (void)startWith115URL:(AZ115URL*)a115URL{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	self.az115URL = a115URL;
	NSMutableArray * args = [[AZDownloadConfig sharedInstance] argsForAxelFor115URL:self.az115URL];
	[aTask setArguments:args];
	
	if (self.adelegate) {
		if ([self.adelegate respondsToSelector:@selector(downloadWillBegin:)]) {
			[self.adelegate downloadWillBegin:self];
		}
	}
	NSDictionary * newsDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 开始下载",a115URL.fileNameString] forKey:@"news"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNews" object:nil userInfo:newsDic];
	[aTask launch];
	while (1) {
		[NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow:1]];
		NSData * data = [outFileHandle availableData];
		if ([data length]>0) {
			NSString * errs = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
			NSArray * infos = [errs componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
			for (NSString * info in infos){
				NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
				if ([info length]>12) {
					NSRange r1 = [info rangeOfString:@"[100%]"];
					NSRange r2 = [info rangeOfString:@"Downloaded"];
					NSRange r3 = [info rangeOfString:@"seconds"];
					if (r1.length>0||r2.length>0||r3.length>0) {
						self.curProgress = [NSString stringWithFormat:@"%f",100.0];
						self.curSpeed = @"完成";
						[aTask terminate];
						break;
					}
					NSString * prefixStr = [info substringToIndex:6];
					if ([prefixStr hasPrefix:@"["]&&[prefixStr hasSuffix:@"]"]) {
						self.curProgress = [prefixStr substringWithRange:NSMakeRange(1, 3)];
					}
					NSString * suffixStr = [info substringWithRange:NSMakeRange([info length]-12, 12)];
					if ([suffixStr hasPrefix:@"["]&&[suffixStr hasSuffix:@"]"]) {
						self.curSpeed = [suffixStr substringWithRange:NSMakeRange(1, 10)];
					}
				}
				[pool release];
			}			
			if (self.curSpeed&&self.curProgress) {
				if (self.adelegate) {
//					NSLog(@"%@ %@",self.curSpeed,self.curProgress);
					if ([self.adelegate respondsToSelector:@selector(downloadUpdateSpeed:andProgress:)]) {
						[self.adelegate downloadUpdateSpeed:self.curSpeed andProgress:self.curProgress];
					}
				}
			}
			if ([self.curProgress intValue] >= 100) {
				self.curProgress = [NSString stringWithFormat:@"%f",100.0];
				self.curSpeed = @"完成";
				[aTask terminate];
				break;
			}
		}
	}
	if (self.curSpeed&&self.curProgress) {
		if (self.adelegate) {
			//					NSLog(@"%@ %@",self.curSpeed,self.curProgress);
			if ([self.adelegate respondsToSelector:@selector(downloadUpdateSpeed:andProgress:)]) {
				[self.adelegate downloadUpdateSpeed:self.curSpeed andProgress:self.curProgress];
			}
		}
	}
	newsDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 下载完毕",a115URL.fileNameString] forKey:@"news"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNews" object:nil userInfo:newsDic];
	if (self.adelegate) {
		if ([self.adelegate respondsToSelector:@selector(downloadDidEnd:)]) {
			[self.adelegate downloadDidEnd:self];
		}
	}
	[pool release];
}
@end
