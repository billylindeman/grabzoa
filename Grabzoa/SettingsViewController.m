//
//  SettingsViewController.m
//  Grabzoa
//
//  Created by Billy Lindeman on 5/14/10.
//  Copyright 2010 Protozoa, LLC. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController
@synthesize panel;
@synthesize urlToPost;

-(void)awakeFromNib {
	NSUserDefaults *savedPrefrences = [NSUserDefaults standardUserDefaults];
	[urlToPost setStringValue:[savedPrefrences objectForKey:@"GZPostUrl"]];
}

-(void)buttonPressed:(id)sender {
	NSUserDefaults *savedPrefrences = [NSUserDefaults standardUserDefaults];
	
	[savedPrefrences setObject:[urlToPost stringValue] forKey:@"GZPostUrl"];
	
	[panel close];
}
@end
