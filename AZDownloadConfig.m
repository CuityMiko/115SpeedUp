//
//  AZDownloadConfig.m
//  115SpeedUp
//
//  Created by Aladdin on 3/16/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import "AZDownloadConfig.h"
#import "AZ115URL.h"
static AZDownloadConfig *sharedInstance;
@implementation AZDownloadConfig

@synthesize targetPath;
@synthesize connectionLimit;
@synthesize speedLimit;
@synthesize network;
+ (AZDownloadConfig *)sharedInstance{
	if (!sharedInstance) {
		sharedInstance = [[AZDownloadConfig alloc] init];
	}
	return sharedInstance;
}
- (id)init{
	self = [super init];
	if (self) {
		NSString * defaultTargetPath = [[NSUserDefaults standardUserDefaults] valueForKey:kTARGETPATHKEY];
		if(defaultTargetPath&&[defaultTargetPath length]>0){
			self.targetPath = defaultTargetPath;
		}else {
			self.targetPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Downloads"];
		}
		
		NSString * defaultConnectionLimit = [[NSUserDefaults standardUserDefaults] valueForKey:kCONNECTIONLIMITKEY];
		if (defaultConnectionLimit&&[defaultConnectionLimit length]>0) {
			self.connectionLimit = defaultConnectionLimit;
		}else {
			self.connectionLimit = @"100";
		}

		double defaultSpeedLimit = [[NSUserDefaults standardUserDefaults] doubleForKey:kSPEEDLIMITKEY];
		if (defaultSpeedLimit>0) {
			self.speedLimit = defaultSpeedLimit;
		}else {
			self.speedLimit = 4000000;
		}

		NSInteger defaultNetwork = [[NSUserDefaults standardUserDefaults] integerForKey:kNETWORKKEY];
		if (defaultNetwork>=0) {
			self.network = defaultNetwork;
		}else {
			self.network = kNetWorkChinaUnicom;
		}

	}
	return self;
}
- (void)save{
	[[NSUserDefaults standardUserDefaults] setValue:self.targetPath forKey:kTARGETPATHKEY];
	[[NSUserDefaults standardUserDefaults] setValue:self.connectionLimit forKey:kCONNECTIONLIMITKEY];
	[[NSUserDefaults standardUserDefaults] setDouble:self.speedLimit forKey:kSPEEDLIMITKEY];
	[[NSUserDefaults standardUserDefaults] setInteger:self.network forKey:kNETWORKKEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)dealloc
{
	[targetPath release];
	targetPath = nil;
	[connectionLimit release];
	connectionLimit = nil;

	[super dealloc];
}
- (NSString*)speedLimitString{
	return [NSString stringWithFormat:@"%.1f KB/s",self.speedLimit/1024/8];
}
- (NSMutableArray *)argsForAxelFor115URL:(AZ115URL*)url{
	NSString * sourceUrl;
//    if(url.urlCounts==3){
//        switch (self.network) {
//            case kNetWorkChinaUnicom:
//                sourceUrl = url.chinaUnicomString;
//                break;
//            case kNetWorkChinaTelecom:
//                sourceUrl = url.chinaTelecomString;
//                break;
//            case kNetWorkBackup:
//                sourceUrl = url.backupString;
//                break;
//            default:
//                break;
//        }
//    }else{
//        if (url.chinaUnicomString) {
//            <#statements#>
//        }        
//    }
    
    switch (url.urlCounts) {
		case 0:
			break;
		case 1:
			sourceUrl = url.chinaTelecomString;
			break;
		case 2:
			sourceUrl = url.chinaUnicomString;
			break;
		case 3:
			sourceUrl =  url.chinaUnicomString;
//			self.chinaTelecomString = [[downloadUrls objectAtIndex:0] valueForKey:@"Url"];
//			self.backupString = [[downloadUrls objectAtIndex:2] valueForKey:@"Url"];
			break;
		default:
			break;
	}

	NSMutableArray * args = [NSMutableArray arrayWithObjects:@"-n",self.connectionLimit,
							 @"-U",@"User-Agent:Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
							 @"-s",[NSString stringWithFormat:@"%f",self.speedLimit],
//							 @"-S",url.backupString,
							 @"-o",[NSString stringWithFormat:@"%@/%@",self.targetPath,url.fileNameString],sourceUrl,nil];
	return args;
}
@end
