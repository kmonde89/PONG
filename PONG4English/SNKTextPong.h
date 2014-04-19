//
//  SNKTextPong.h
//  PONG4English
//
//  Created by Kévin Mondésir on 09/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNKTextPong : NSObject
{
	uint * OBjectID;
}
@property (readwrite) int val;
-(id)initWithObjectID:(uint *)objectID;
-(void)drawIntAtPoint:(CGPoint) point;

@end
