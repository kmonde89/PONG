//
//  SNKBall.h
//  PONG4English
//
//  Created by Kévin Mondésir on 02/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNKBall : NSObject
{
	CGPoint vitesse;
	CGPoint location;
}
@property (readonly) int color;
-(id)	initWithSpeed:(float)speed andPosition:(CGPoint)position;
-(id)	initWithSpeed:(float)speed;
-(id)	init;
-(void) maj;
-(void) maj2;
-(BOOL)	impactTest;
-(CGPoint)getPosition;
-(CGPoint)getSpeed;
-(void)modifSpeed:(CGPoint)speed;
-(void)contact;
-(BOOL)disappear;
@end
