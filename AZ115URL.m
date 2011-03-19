//
//  AZ115URL.m
//  115SpeedUp
//
//  Created by Aladdin on 3/7/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import "AZ115URL.h"
#import "JSON.h"

@implementation AZ115URL

@synthesize fileNameString;
@synthesize a115URLString;
@synthesize chinaUnicomString;
@synthesize chinaTelecomString;
@synthesize backupString;
@synthesize unknownString;

#define UeggVersion 1169
- (void)getURLsFrom115ApiWithURL:(NSString*)aurl{
	self.a115URLString = aurl;
	NSString * pickcode = [a115URLString lastPathComponent];
	NSString * apiURL = [NSString stringWithFormat:@"http://u.115.com/?ct=upload_api&ac=get_pick_code_info&pickcode=%@&version=%d",pickcode,UeggVersion];
	NSString * retStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiURL] encoding:NSUTF8StringEncoding error:nil];
	NSDictionary * newsDic = [NSDictionary dictionaryWithObject:@"获取下载链接中" forKey:@"news"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNews" object:nil userInfo:newsDic];
	NSDictionary * retDict = [retStr JSONValue];
	
	NSArray * downloadUrls = [retDict objectForKey:@"DownloadUrl"];
	
	newsDic = [NSDictionary dictionaryWithObject:@"分析链接中" forKey:@"news"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNews" object:nil userInfo:newsDic];
	
	switch ([downloadUrls count]) {
		case 0:
			break;
		case 1:
			self.chinaUnicomString = [[downloadUrls objectAtIndex:0] valueForKey:@"Url"];
			self.chinaTelecomString = @"";
			self.backupString = @"";
			break;
		case 2:
			self.chinaUnicomString = [[downloadUrls objectAtIndex:0] valueForKey:@"Url"];
			self.chinaTelecomString = [[downloadUrls objectAtIndex:1] valueForKey:@"Url"];
			self.backupString = @"";
			break;
		case 3:
			self.chinaUnicomString = [[downloadUrls objectAtIndex:0] valueForKey:@"Url"];
			self.chinaTelecomString = [[downloadUrls objectAtIndex:1] valueForKey:@"Url"];
			self.backupString = [[downloadUrls objectAtIndex:2] valueForKey:@"Url"];
			break;
		default:
			break;
	}
	
	
    //for (id obj in downloadUrls) {
//        NSString *urlString = [obj objectForKey:@"Url"];
//        if () 
//            self.chinaUnicomString = urlString;
//        
//        else if ([urlString rangeOfString:@"tel.115.cdn"].location != NSNotFound
//                 || [urlString rangeOfString:@"http://1.hot"].location != NSNotFound)
//            self.chinaTelecomString = urlString;
//        
//        else if ([urlString rangeOfString:@"bak"].location != NSNotFound
//                 || [urlString rangeOfString:@"http://bak"].location != NSNotFound)
//            self.backupString = urlString;
//        
//        else self.unknownString = urlString;
//    }
    

	self.fileNameString = [retDict objectForKey:@"FileName"];
	newsDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 准备下载",self.fileNameString] forKey:@"news"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadNews" object:nil userInfo:newsDic];
	NSLog(@"%@",retDict);
}

- (void)dealloc
{
	[a115URLString release];
	a115URLString = nil;
	[chinaUnicomString release];
	chinaUnicomString = nil;
	[chinaTelecomString release];
	chinaTelecomString = nil;
	[backupString release];
	backupString = nil;

	[fileNameString release];
	fileNameString = nil;

	[super dealloc];
}

@end
