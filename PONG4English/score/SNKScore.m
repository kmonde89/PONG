//
//  SNKScore.m
//  PONG4English
//
//  Created by Kévin Mondésir on 27/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKScore.h"
#define credential @"012GREGHTD06H54GQEGVQG5H45O54QZG"
@interface SNKScore()
{
	NSString *post;
	NSData *postData;
	NSURLConnection *conn;
	NSMutableURLRequest *request;
	NSArray *array;
}
@end
@implementation SNKScore
-(id)init
{
	if(self=[super init])
	{
		receivedData=[[NSMutableData alloc]init];
	}
	return self;
}
-(void)dealloc
{
	[receivedData release];
	[super dealloc];
}
-(void)sendScore:(NSString *)pseudo andScore:(int)score
{
	post = [NSString stringWithFormat:@"hello"];
	postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
	request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kevinmondesir.fr/saveScore.php"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	[postData release];
	conn = [[[NSURLConnection alloc]initWithRequest:request delegate:self]autorelease];
	if(conn)
	{
		NSLog(@"Connection Successful");
	}
	else
	{
		NSLog(@"Connection could not be made");
	}
}
-(void)getScore
{
	post = [NSString stringWithFormat:@"hello"];
	postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
	request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kevinmondesir.fr/saveScore.php"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	[postData release];
	conn = [[[NSURLConnection alloc]initWithRequest:request delegate:self]autorelease];
	if(conn)
	{
		NSLog(@"Connection Successful");
	}
	else
	{
		NSLog(@"Connection could not be made");
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
	//[receivedData appendBytes:data length:[data length]];
	
	//NSLog(@"%@",[NSString stringWithUTF8String:[data bytes]] );
	
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	array = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:nil];
	NSLog(@"%lu",(unsigned long)[postData retainCount]);
	
	NSLog(@"%lu",(unsigned long)[request retainCount]);
	NSLog(@"yes %@",array);
	NSLog(@"%@",[NSString stringWithUTF8String:[receivedData bytes]] );
}
-(NSArray *)recupererScore
{
	return array;
}
@end
