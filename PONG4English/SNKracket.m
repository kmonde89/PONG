//
//  SNKracket.m
//  PONG4English
//
//  Created by Kévin Mondésir on 03/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKracket.h"

@implementation SNKracket

-(id)initWithPosition:(CGPoint)position
{
	if(self=[self init])
	{
		location=position;
	}
	return self;
}
-(id)init
{
	if(self=[super init])
	{
		location=CGPointMake(-65, 0);
		vitesse=CGPointMake(0.0, 0.0);
	}
	return self;
}
-(void)animate
{
	if(move)
	{
		vitesse.y*=1.03;
		location.x+=vitesse.x;
		location.y+=vitesse.y;
		location.y=location.y>42?42:location.y;
		location.y=location.y<-42?-42:location.y;
	}
}
-(CGPoint)getPosition
{
	return location;
}
-(void)stopMoveBottom
{
	if(!top)
		move=NO;
}
-(void)stopMoveTop
{
	if(top)
		move=NO;
}
-(void)beginMoveBottom
{
	move=YES;
	top=NO;
	vitesse=CGPointMake(0, -1.3);
}
-(void)beginMoveTop
{
	move=YES;
	top=YES;
	vitesse=CGPointMake(0, 1.3);
}
-(BOOL)TestBall:(SNKBall *)ball
{
	
	if([ball getPosition].x>(location.x+3)&&[ball getPosition].x+[ball getSpeed].x<=(location.x+3)&&location.y-[ball getPosition].y<8&&location.y-[ball getPosition].y>-8)
	{
		//NSLog(@"ball speed.y %f  raquette speed.y %f",[ball getSpeed].y,vitesse.y);
		//augmenter la modification de vitesse du a la diff de position au cours de la parti
		[ball modifSpeed:CGPointMake( 0.0,([ball getPosition].y-location.y)*0.0037+vitesse.y*0.0078)];
		//NSLog(@"ball speed.y %f  raquette speed.y %f",[ball getSpeed].y,vitesse.y);
		[ball contact];
		return YES;
	}
	return NO;
}
@end
