//
//  AZDownloadManager.h
//  115SpeedUp
//
//  Created by Aladdin on 3/8/11.
//  Copyright 2011 innovation-works. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AZ115URL;
@protocol AZDownloadTaskDelegate;

@interface AZDownloadTask : NSObject {
	NSTask * aTask;
	NSFileHandle * outFileHandle;
	
	NSString * curSpeed;
	NSString * curProgress;
	id<AZDownloadTaskDelegate> adelegate;
	
	NSString * destinationPath;
	NSString * speedLimit;
	
	AZ115URL * az115URL;
	
	NSThread * curTread;
	
	NSInteger curIndex;
}

@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, retain) NSThread *curTread;
@property (nonatomic, retain) AZ115URL *az115URL;
@property (nonatomic, copy) NSString *curSpeed;
@property (nonatomic, copy) NSString *curProgress;
@property (nonatomic, retain) NSFileHandle *outFileHandle;
@property (nonatomic, assign) id<AZDownloadTaskDelegate> adelegate;
@property (nonatomic, retain) NSTask *aTask;

- (void)taskWith115URL:(AZ115URL*)a115URL;


@end

@protocol AZDownloadTaskDelegate<NSObject>

- (void)downloadWillBegin:(AZDownloadTask*)manager;
- (void)downloadUpdateSpeed:(NSString *)speed andProgress:(NSString*)progress;
- (void)downloadDidEnd:(AZDownloadTask*)manager;
@end

