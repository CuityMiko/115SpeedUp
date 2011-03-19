//
//  AZDownloadConfig.h
//  115SpeedUp
//
//  Created by Aladdin on 3/16/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kTARGETPATHKEY @"targetPathKey"
#define kCONNECTIONLIMITKEY @"connectionLimitKey"
#define kSPEEDLIMITKEY @"speedLimitKey"
#define kNETWORKKEY @"networkKey"
typedef enum{
	kNetWorkChinaUnicom,
	kNetWorkChinaTelecom,
	kNetWorkBackup,
	kNetWorkUnknown
}kNetWorkType;
@class AZ115URL;
@interface AZDownloadConfig : NSObject {
	IBOutlet	NSString * targetPath;
	IBOutlet	NSString * connectionLimit;
	IBOutlet	double speedLimit;
	IBOutlet	kNetWorkType network;
}

@property (nonatomic, copy) NSString *targetPath;
@property (nonatomic, copy) NSString *connectionLimit;
@property (nonatomic, assign) double speedLimit;
@property (nonatomic, assign) kNetWorkType network;
+ (AZDownloadConfig *)sharedInstance;
- (NSMutableArray *)argsForAxelFor115URL:(AZ115URL *)url;
- (void)save;
- (NSString*)speedLimitString;
@end
