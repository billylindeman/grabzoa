//
//  GrabzoaAppDelegate.m
//  Grabzoa
//
//  Created by Billy Lindeman on 5/14/10.
//  Copyright 2010 Protozoa, LLC. All rights reserved.
//

#import "GrabzoaAppDelegate.h"

@implementation GrabzoaAppDelegate

@synthesize urlData;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	//create status item and add menu
	NSMenu *menu = [self buildMenu];
	NSImage *menuImage = [[NSImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]];
	statusItem = [[[NSStatusBar systemStatusBar]
					statusItemWithLength:NSSquareStatusItemLength] retain];
	[statusItem setMenu:menu];
	[statusItem setHighlightMode:YES];
	[statusItem setToolTip:@"Test Tray"];
	[statusItem setImage:menuImage];
	
	
	hotKeyCenter = [[DDHotKeyCenter alloc] init];
	[hotKeyCenter registerHotKeyWithKeyCode:0x15 modifierFlags:NSCommandKeyMask target:self action:@selector(takeScreenshot:) object:nil];
	
	isUploading = NO;
    imgur =[[ImgurUploader alloc] init];
    [imgur setDelegate:self];
}

-(NSMenu *)buildMenu {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	// Add To Items
	menuItem = [menu addItemWithTitle:@"Take Screenshot"
							   action:@selector(takeScreenshot:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
	// Add To Items
	menuItem = [menu addItemWithTitle:@"Settings"
							   action:@selector(actionSettings:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];
	
	// Add Quit Action
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(actionQuit:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Click to Quit this App"];
	[menuItem setTarget:self];
	
	return menu;
	
	
	
}
-(void)takeScreenshot:(id)sender {
	[NSThread detachNewThreadSelector:@selector(takeScreenshotThread) toTarget:self withObject:nil];
}

-(void)takeScreenshotThread {

	NSLog(@"Taking Screenshot");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSTask *theProcess;
	theProcess = [[NSTask alloc] init];
	
	[theProcess setLaunchPath:@"/usr/sbin/screencapture"];
	// use arguments to set save location
	[theProcess setArguments:[NSArray arrayWithObjects:@"-i", @"/tmp/tmp.png", nil]];
	[theProcess launch];
	[theProcess waitUntilExit];
	

    //generate nsdata for png file
	NSData *theImage = [NSData dataWithContentsOfFile:@"/tmp/tmp.png"];	
    [imgur uploadImage:theImage];
    
    
	[pool drain];
}

-(void)imageUploadedWithURLString:(NSString*)urlString{
    [self copyToClipboard:urlString];
}
-(void)uploadProgressedToPercentage:(CGFloat)percentage{

}
-(void)uploadFailedWithError:(NSError*)error{

}


-(void)copyToClipboard:(NSString*)str
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:self];
    [pb setString: str forType:NSStringPboardType];
}

-(void)animateStatusBarUpload {
	//animate the status bar image	
	currentFrame = 1;
	statusAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/9.0f target:self selector:@selector(statusBarUploadTick) userInfo:nil repeats:YES];
}

-(void)statusBarUploadTick {
	NSLog(@"%i", currentFrame);
	if(currentFrame > 9) currentFrame = 1;
	
	if(!isUploading) {
		[statusAnimationTimer invalidate];
		statusAnimationTimer = nil;
		
		NSImage *image = [[NSImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icon"
																								  ofType:@"png"]];
		[statusItem setImage:image];
		
		currentFrame = 1;
	}
	
	
	NSImage *image = [[NSImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon-%i", currentFrame]
																							  ofType:@"png"]];
	[statusItem setImage:image];
	
	currentFrame+=1;
	
	return;
	
}
- (void) actionQuit:(id)sender {
	[NSApp terminate:sender];
}
- (void) actionSettings:(id)sender {
	[NSBundle loadNibNamed:@"Settings" owner:self];

}
@end
