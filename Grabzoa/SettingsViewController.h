//
//  SettingsViewController.h
//  Grabzoa
//
//  Created by Billy Lindeman on 5/14/10.
//  Copyright 2010 Protozoa, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SettingsViewController : NSObject {
	NSPanel *panel;
	NSTextField *urlToPost;
}
@property (nonatomic,retain) IBOutlet NSPanel *panel;
@property (nonatomic,retain) IBOutlet NSTextField *urlToPost;
-(void)buttonPressed:(id)sender ;

@end
