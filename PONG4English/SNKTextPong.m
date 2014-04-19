//
//  SNKTextPong.m
//  PONG4English
//
//  Created by Kévin Mondésir on 09/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKTextPong.h"

@implementation SNKTextPong
@synthesize val;
-(id)initWithObjectID:(uint *)objectID
{
	if(self=[self init])
	{
		OBjectID=objectID;
	}
	return self;
}
-(void)drawIntAtPoint:(CGPoint) point
{
	int temp=val;
	
	if(val==0)
	{
		
	}
	else{
		while (temp!=0){
			if(temp%10)
			{
				
			}
			else{
				
			}
		}
	}
}
@end
