//
//  SNKracket.h
//  PONG4English
//
//  Created by Kévin Mondésir on 03/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNKBall.h"
@interface SNKracket : NSObject
{
	CGPoint location;
	CGPoint vitesse;
	BOOL move;
	BOOL top;
}

-(id)init;
-(id)initWithPosition:(CGPoint)position;
-(CGPoint)getPosition;
-(void)stopMoveTop;
-(void)beginMoveTop;
-(void)beginMoveBottom;
-(void)stopMoveBottom;
-(void)animate;
-(BOOL)TestBall:(SNKBall *)ball;
@end
