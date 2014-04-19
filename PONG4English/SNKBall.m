//
//  SNKBall.m
//  PONG4English
//
//  Created by Kévin Mondésir on 02/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "SNKBall.h"
#define standardSpeed 	0.7
#define basePositionX	20
#define basePositionY	0
#define PI				3.141592653589f
int BallColor=0;
@implementation SNKBall
@synthesize color;
-(id)initWithSpeed:(float)speed andPosition:(CGPoint)position
{
	if (self=[self initWithSpeed:speed]) {
		location=CGPointMake(position.x, position.y);
	}
	return self;
}
-(id)initWithSpeed:(float)speed
{
	if(self=[self init])
	{
		float angle=(((float)rand()/RAND_MAX)-0.5)*.4;
		vitesse=CGPointMake(speed*cos(PI*angle), speed*sin(PI*angle));
	}
	return  self;
}
-(id)init
{
	if(self=[super init])
	{
		vitesse=CGPointMake(standardSpeed, standardSpeed);
		location=CGPointMake(basePositionX, basePositionY);
		color=BallColor;
		BallColor=(BallColor+1)%6;
		//NSLog(@"%d",color);
	}
	return self;
}
-(void)maj
{
	BOOL infinity=NO;
	if(location.x>76)
	{
		infinity=YES;
		vitesse.x=-vitesse.x*1.02;
	}
	if(location.y<-47||location.y>47)
	{
		vitesse.y=-vitesse.y;
	}
	location.x+=vitesse.x;
	if (infinity&&location.x<-60) {
		location.x=-60;
	}
	location.y+=vitesse.y;
}
-(void)modifSpeed:(CGPoint)speed
{
	vitesse.x+=speed.x;
	vitesse.y+=speed.y;
}
-(void)maj2
{
	BOOL infinity=NO;
	if(location.x>76)
	{
		infinity=YES;
		vitesse.x=-vitesse.x;
	}
	if(location.y<-47||location.y>47)
	{
		vitesse.y=-vitesse.y;
	}
	location.x+=vitesse.x;
	if (infinity&&location.x<-60) {
		location.x=-60;
	}
	location.y+=vitesse.y;
}
-(void)contact
{
	vitesse.x=-vitesse.x;
}
-(BOOL)impactTest
{
	return location.x>76;
}
-(CGPoint)getSpeed
{
	return vitesse;
}
-(void)dealloc
{
	[super dealloc];
}
-(CGPoint)getPosition
{
	return location;
}
-(BOOL)disappear
{
	return location.x<-80;
}
@end
