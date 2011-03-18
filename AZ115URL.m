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
	NSDictionary * retDict = [retStr JSONValue];
	NSArray * downloadUrls = [retDict objectForKey:@"DownloadUrl"];
    
    for (id obj in downloadUrls) {
        NSString *urlString = [obj objectForKey:@"Url"];
        if ([urlString rangeOfString:@"cnc.115.cdn"].location != NSNotFound
            || [urlString rangeOfString:@"http://2.hot"].location != NSNotFound) 
            self.chinaUnicomString = urlString;
        
        else if ([urlString rangeOfString:@"tel.115.cdn"].location != NSNotFound
                 || [urlString rangeOfString:@"http://1.hot"].location != NSNotFound)
            self.chinaTelecomString = urlString;
        
        else if ([urlString rangeOfString:@"bak.115.cdn"].location != NSNotFound
                 || [urlString rangeOfString:@"http://bak"].location != NSNotFound)
            self.backupString = urlString;
        
        else self.unknownString = urlString;
    }
    

	self.fileNameString = [retDict objectForKey:@"FileName"];
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
