//
//  SNKScore.h
//  PONG4English
//
//  Created by Kévin Mondésir on 27/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNKScore : NSObject<NSURLConnectionDelegate>
{
	NSMutableData * receivedData;
	
}
-(void)sendScore:(NSString *)pseudo andScore:(int)score;
-(void)getScore;
-(NSArray *)recupererScore;
@end
