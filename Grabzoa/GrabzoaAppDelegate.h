//
//  GrabzoaAppDelegate.h
//  Grabzoa
//
//  Created by Billy Lindeman on 5/14/10.
//  Copyright 2010 Protozoa, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import	"DDHotKeyCenter.h"
#import "ImgurUploader.h"

@interface GrabzoaAppDelegate : NSObject <NSApplicationDelegate,ImgurUploaderDelegate> {
	NSStatusItem *statusItem;
	DDHotKeyCenter *hotKeyCenter;
	ImgurUploader *imgur;
    
    
    
	BOOL isUploading;
	BOOL lava_send;
	
	int currentFrame;
	NSTimer *statusAnimationTimer;
}
@property (assign) NSMutableData *urlData;
-(NSMenu *)buildMenu;

-(void)copyToClipboard:(NSString *)str;

-(void)animateStatusBarUpload;
@end
