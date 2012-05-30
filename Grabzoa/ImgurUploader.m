//
//  ThoughtSender.m
//  ThoughtBackDesktop
//
//  Created by Randall Brown on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImgurUploader.h"
#import "NSString+URLEncoding.h"
#import "NSString+SBJSON.h"
#import "NSData+Base64.h"
#import <dispatch/dispatch.h>

#define kImgurAPIKey @"964affa395a0784c3afc67c6f1e445ff"
#define kImgurAPIEndpoint @"http://api.imgur.com/2/upload.json"

@implementation ImgurUploader

@synthesize delegate;

-(void)uploadImage:(NSData*)imageData
{
	dispatch_queue_t queue = dispatch_queue_create("com.Blocks.task",NULL);
	dispatch_queue_t main = dispatch_get_main_queue();
	
	dispatch_async(queue,^{
		NSString *imageB64   = [imageData base64EncodingWithLineLength:0];
		imageB64 = [imageB64 encodedURLString];
		
		dispatch_async(main,^{
			
			NSString *uploadCall = [NSString stringWithFormat:@"key=%@&image=%@",kImgurAPIKey,imageB64];
			
			NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.imgur.com/2/upload.json"]];
			[request setHTTPMethod:@"POST"];
			[request setValue:[NSString stringWithFormat:@"%d",[uploadCall length]] forHTTPHeaderField:@"Content-length"];
			[request setHTTPBody:[uploadCall dataUsingEncoding:NSUTF8StringEncoding]];
			
			NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
			if (theConnection) 
			{
				// Create the NSMutableData that will hold
				// the received data
				// receivedData is declared as a method instance elsewhere
				//receivedData=[[NSMutableData data] retain];
				receivedData=[[NSMutableData data] retain];
			} 
			else 
			{
				
			}
			
		});
	});  		
}


-(void)dealloc
{
	[super dealloc];
	[imageURL release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[delegate uploadFailedWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	[delegate uploadProgressedToPercentage:(CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	NSLog( @"%@", dataString );
    
    NSDictionary *dict = [dataString JSONValue];
    NSString *original = [[[dict objectForKey:@"upload"] objectForKey:@"links"] objectForKey:@"original"];

	[delegate imageUploadedWithURLString:original];
}


@end
